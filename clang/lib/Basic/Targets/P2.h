//===--- P2.h - Declare P2 target feature support -------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares P2 TargetInfo objects.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CLANG_LIB_BASIC_TARGETS_P2_H
#define LLVM_CLANG_LIB_BASIC_TARGETS_P2_H

#include "clang/Basic/TargetInfo.h"
#include "clang/Basic/TargetOptions.h"
#include "llvm/ADT/Triple.h"
#include "llvm/Support/Compiler.h"

namespace clang {
namespace targets {

// P2 Target
class LLVM_LIBRARY_VISIBILITY P2TargetInfo : public TargetInfo {
  static const char *const GCCRegNames[];

  bool IsDebug;

public:
  P2TargetInfo(const llvm::Triple &Triple, const TargetOptions &)
      : TargetInfo(Triple) {
    TLSSupported = false;
    FloatFormat =  &llvm::APFloat::IEEEsingle();
    DoubleFormat = &llvm::APFloat::IEEEdouble();
    BigEndian = false;

    IsDebug = false;
    resetDataLayout("e-p:32:32-i32:32-i64:32");
  }

  void getTargetDefines(const LangOptions &Opts, MacroBuilder &Builder) const override;

  ArrayRef<Builtin::Info> getTargetBuiltins() const override { return None; }
  BuiltinVaListKind getBuiltinVaListKind() const override {
    return TargetInfo::VoidPtrBuiltinVaList;
  }

  const char *getClobbers() const override { return ""; }

  ArrayRef<const char *> getGCCRegNames() const override;

  ArrayRef<TargetInfo::AddlRegName> getGCCAddlRegNames() const override {
    return None;
  }

  ArrayRef<TargetInfo::GCCRegAlias> getGCCRegAliases() const override {
    static const TargetInfo::GCCRegAlias GCCRegAliases[] = {
        {{"ptra"}, "sp"},
    };
    return llvm::makeArrayRef(GCCRegAliases);
  }

  bool validateAsmConstraint(const char *&Name, TargetInfo::ConstraintInfo &Info) const override {
    if (StringRef(Name).size() > 1)
      return false;

    switch (*Name) {
    default:
      return false;
    case 'r':
      Info.setAllowsRegister();
      return true;
    case 'i': // 6-bit positive integer constant
      Info.setRequiresImmediate(0, 0xffffffff);
      return true;
    }

    return false;
  }

  bool handleTargetFeatures(std::vector<std::string> &Features,
                            DiagnosticsEngine &Diags) override {

    for (const auto &Feature : Features) {
      if (Feature == "+p2db") IsDebug = true;
    }

    return true;
  }

  IntType getIntTypeByWidth(unsigned BitWidth, bool IsSigned) const final {
    return TargetInfo::getIntTypeByWidth(BitWidth, IsSigned);
  }

  IntType getLeastIntTypeByWidth(unsigned BitWidth, bool IsSigned) const final {
    return TargetInfo::getLeastIntTypeByWidth(BitWidth, IsSigned);
  }

protected:
  std::string CPU;
};

} // namespace targets
} // namespace clang

#endif // LLVM_CLANG_LIB_BASIC_TARGETS_P2_H
