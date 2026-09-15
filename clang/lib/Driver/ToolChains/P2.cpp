//===--- P2.cpp - P2 ToolChain Implementations ----------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "P2.h"
#include "CommonArgs.h"
#include "clang/Driver/Compilation.h"
#include "clang/Driver/DriverDiagnostic.h"
#include "clang/Driver/Options.h"
#include "llvm/Option/ArgList.h"
#include "llvm/Support/Path.h"

using namespace clang::driver;
using namespace clang::driver::toolchains;
using namespace clang::driver::tools;
using namespace clang;
using namespace llvm::opt;


/// Headers, libraries and linker scripts must come from the same SDK.
P2ToolChain::P2ToolChain(const Driver &D, const llvm::Triple &Triple,
                       const ArgList &Args) : Generic_ELF(D, Triple, Args) {
    const std::string SysRoot = computeSysRoot();
    getFilePaths().push_back(SysRoot + "/libc/lib");
    getFilePaths().push_back(SysRoot + "/libp2/lib");
}

void P2ToolChain::AddClangSystemIncludeArgs(const ArgList &DriverArgs,
                                                ArgStringList &CC1Args) const {
    if (DriverArgs.hasArg(options::OPT_nostdinc) ||
        DriverArgs.hasArg(options::OPT_nostdlibinc)) return;

    std::string sys_root = computeSysRoot();

    addSystemInclude(DriverArgs, CC1Args, sys_root + std::string("/libp2/include"));
    addSystemInclude(DriverArgs, CC1Args, sys_root + std::string("/libc/include"));
}

void P2ToolChain::addClangTargetOptions(const ArgList &DriverArgs,
                                            ArgStringList &CC1Args,
                                            Action::OffloadKind) const {
    CC1Args.push_back("-fno-rtti");
    CC1Args.push_back("-fno-jump-tables");
}

std::string P2ToolChain::computeSysRoot() const {
    if (!getDriver().SysRoot.empty())
        return getDriver().SysRoot;

    SmallString<128> Dir;
    llvm::sys::path::append(Dir, getDriver().Dir, "..");

    return std::string(Dir.str());
}

Tool *P2ToolChain::buildLinker() const {
  return new tools::P2::Linker(getTriple(), *this);
}

void P2::Linker::ConstructJob(Compilation &C, const JobAction &JA,
                               const InputInfo &Output,
                               const InputInfoList &Inputs,
                               const ArgList &Args,
                               const char *LinkingOutput) const {

    std::string Linker = getToolChain().GetProgramPath(getShortName());
    ArgStringList CmdArgs;
    AddLinkerInputs(getToolChain(), Inputs, Args, CmdArgs, JA);

    CmdArgs.push_back("-o");
    CmdArgs.push_back(Output.getFilename());

    Args.AddAllArgs(CmdArgs, options::OPT_L);
    getToolChain().AddFilePathLibArgs(Args, CmdArgs);

    Args.AddAllArgs(CmdArgs, options::OPT_r, options::OPT_T);
    const bool Relocatable = Args.hasArg(options::OPT_r);
    const bool NoStdLib = Args.hasArg(options::OPT_nostdlib);
    const bool DefaultLibs = !Relocatable && !NoStdLib &&
                            !Args.hasArg(options::OPT_nodefaultlibs);
    if (DefaultLibs) {
        // Startup and the shared LUT image are members of these archives.
        // They cannot yet be selected independently with -nostartfiles.
        if (const Arg *A = Args.getLastArg(options::OPT_nostartfiles)) {
            getToolChain().getDriver().Diag(diag::err_drv_unsupported_opt_for_target)
                << A->getAsString(Args) << getToolChain().getTripleString();
            return;
        }
        CmdArgs.push_back("--whole-archive");
        CmdArgs.push_back("-lc");
        CmdArgs.push_back("-lp2");
        if (Args.hasArg(options::OPT_mp2db))
            CmdArgs.push_back("-lp2db");
        CmdArgs.push_back("--no-whole-archive");
    }

    // Include scripts passed through -Wl, or -Xlinker as well as driver -T.
    // -Ttext/-Tdata/-Tbss set addresses; they do not replace the layout script.
    bool HasScript = false;
    for (StringRef A : CmdArgs) {
        if (A == "--script" || A.startswith("--script=") ||
            (A.startswith("-T") && !A.startswith("-Ttext") &&
             !A.startswith("-Tdata") && !A.startswith("-Tbss")))
            HasScript = true;
    }
    if (!Relocatable && !NoStdLib && !HasScript) {
        const char *Script = Args.hasArg(options::OPT_mp2db) ?
                             "/p2_debug.ld" : "/p2.ld";
        CmdArgs.push_back("-T");
        CmdArgs.push_back(Args.MakeArgString(getToolChain().computeSysRoot() + Script));
    }

    C.addCommand(std::make_unique<Command>(JA, *this, ResponseFileSupport::AtFileCurCP(),
                                            Args.MakeArgString(Linker), CmdArgs, Inputs));
}

