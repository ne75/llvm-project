#ifndef LLVM_CLANG_LIB_DRIVER_TOOLCHAINS_ARCH_P2_H
#define LLVM_CLANG_LIB_DRIVER_TOOLCHAINS_ARCH_P2_H

#include "clang/Driver/Driver.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Option/Option.h"
#include <string>
#include <vector>

namespace clang {
namespace driver {
namespace tools {
namespace p2 {
void getP2TargetFeatures(const Driver &D, const llvm::Triple &Triple,
                            const llvm::opt::ArgList &Args,
                            std::vector<llvm::StringRef> &Features);
} // end namespace riscv
} // namespace tools
} // end namespace driver
} // end namespace clang

#endif // LLVM_CLANG_LIB_DRIVER_TOOLCHAINS_ARCH_RISCV_H
