#include "P2.h"
#include "clang/Driver/Driver.h"
#include "clang/Driver/DriverDiagnostic.h"
#include "clang/Driver/Options.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/Option/ArgList.h"

using namespace clang::driver;
using namespace clang::driver::tools;
using namespace clang;
using namespace llvm::opt;

void sparc::getP2TargetFeatures(const Driver &D, const ArgList &Args,
                                   std::vector<StringRef> &Features) {
    if (Args.hasArg(options::mp2db))
        Features.push_back("+p2db");
}