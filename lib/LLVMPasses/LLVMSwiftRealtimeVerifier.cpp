//===------- LLVMSwiftRealtimeVerifier.cpp - LLVM Realtime Verification --===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#include "swift/LLVMPasses/Passes.h"
#include "swift/AST/DiagnosticsIRGen.h"
#include "swift/AST/DiagnosticEngine.h"
#include "swift/AST/IRGenOptions.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/IR/LegacyPassManager.h" 
#include "llvm/IR/Module.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/Support/Mutex.h"
#include "swift/Demangling/Demangle.h"
#include "swift/Basic/SourceManager.h"

using namespace llvm;
using namespace swift;

char SwiftRealtimeVerifier::ID = 0;

void SwiftRealtimeVerifier::getAnalysisUsage(llvm::AnalysisUsage &AU) const {
  // do nothing for now
}

template<typename ...ArgTypes>
static void
diagnoseSync(DiagnosticEngine &Diags, llvm::sys::Mutex *DiagMutex,
             SourceLoc Loc, Diag<ArgTypes...> ID,
             typename swift::detail::PassArgument<ArgTypes>::type... Args) {
  if (DiagMutex)
    DiagMutex->lock();

  Diags.diagnose(Loc, ID, std::move(Args)...);

  if (DiagMutex)
    DiagMutex->unlock();
}

static void warnRuntimeSafety(llvm::Function& F,
                              CallInst* call,
                              StringRef calledFunctionName,
                              DiagnosticEngine &Diags,
                              llvm::sys::Mutex *DiagMutex,
                              bool isRealtimeViolation) {

  auto name = Demangle::demangleSymbolAsString(F.getName());

  Diag<StringRef, StringRef> diagnostic1;
  Optional< Diag<> > diagnostic2;
  if (isRealtimeViolation) {
    // the runtime is supported but it is violating hard realtime context
    diagnostic1 = diag::runtime_violates_realtime_directive;
    diagnostic2 = diag::runtime_violates_realtime_suggestion;
  } else {
    diagnostic1 = diag::absent_uswift_runtime;
    diagnostic2 = Optional< Diag<> >();
  }

  SourceLoc sl;

  auto dbg = call->getDebugLoc().get();
  if (dbg) {
    StringRef filename;
    unsigned line, col;
    auto inlined = dbg->getInlinedAt();
    auto scope = dbg->getScope();
    if (inlined) {
      auto inlinedInside = inlined;
      while (inlinedInside) {
        inlinedInside = inlined->getInlinedAt();
        if (inlinedInside) {
          inlined = inlinedInside;
        } else {
          break;
        }
      }
      filename = inlined->getFilename();
      line = inlined->getLine();
      col = inlined->getColumn();
    } else if (auto *subprogram = dyn_cast<DISubprogram>(scope)) {
      filename = subprogram->getFilename();
      line = subprogram->getLine();
      col = 0; // n/a
    } else {
      line = dbg->getLine();
      col = dbg->getColumn();
      filename = dbg->getFilename();
    }


    if (Diags.SourceMgr.getIDForBufferIdentifier(filename).hasValue()) {      
      auto bufferID = Diags.SourceMgr.getIDForBufferIdentifier(filename);
      sl = Diags.SourceMgr.getLocForLineCol(bufferID.getValue(),line,col);
    } else {
      sl = SourceLoc();
    }
  } else {
    // fallback for when no debug information is available
    sl = SourceLoc();
  }

  diagnoseSync(Diags, DiagMutex, sl, diagnostic1, calledFunctionName, name);
  if (diagnostic2.hasValue()) {
    diagnoseSync(Diags, DiagMutex, sl, diagnostic2.getValue());
  }
}

static bool isRuntimeSafe(llvm::Function& F,
                           DiagnosticEngine &Diags,
                           llvm::sys::Mutex *DiagMutex,
                           bool isRealtime) {

  bool isRuntimeSafe = true;
  for (auto& block : F) {
    for (auto& inst : block) {
      if (inst.getOpcode() == Instruction::Call) {
        auto call = static_cast<CallInst*>(&inst);
        auto fun = call->getCalledFunction();
        if (fun) {
          auto name = fun->getName();
          if(name.startswith("swift") || name.startswith("_swift") || name.startswith("__swift")) {
            // runtime call, check it is whitelisted
            isRuntimeSafe = false;
            bool isRealtimeUnsafe = false;

            #define RUNTIME_WHITELISTED(NAME) if (name.equals(#NAME)) { isRuntimeSafe = true; }
            #include "swift/Runtime/USwiftRuntimeWhitelist.def"
            #undef RUNTIME_WHITELISTED

            #define RUNTIME_GREYLISTED(NAME) if (name.equals(#NAME)) { isRealtimeUnsafe = true; }
            #include "swift/Runtime/USwiftRuntimeGreylist.def"
            #undef RUNTIME_GREYLISTED

            if (isRealtimeUnsafe&&!isRealtime) {
              isRealtimeUnsafe = false; // not in realtime context
            }

            if (!isRuntimeSafe||isRealtimeUnsafe) {
              warnRuntimeSafety(F, call, name, Diags, DiagMutex, isRealtimeUnsafe && isRealtime);
            }
          }
        }
      }
    }
  }

  return isRuntimeSafe;
}

void verifyRuntimeSafety(llvm::Function& F,
                          DiagnosticEngine &Diags,
                          llvm::sys::Mutex *DiagMutex,
                          const IRGenOptions &Opts) {

  auto rtMDNode = F.getMetadata("realtime");
  auto nrtMDNode = F.getMetadata("norealtime");
  auto name = Demangle::demangleSymbolAsString(F.getName());
  bool isRealtime = (!Opts.Realtime && rtMDNode != nullptr) || (Opts.Realtime && nrtMDNode == nullptr);

  if (!isRuntimeSafe(F, Diags, DiagMutex,isRealtime)) {
    // report a build error up to swift, e.g. exit code
    // errs() << "???:0:0: warning: ";
    // errs().write_escaped(name) << " contains swift runtime calls.\n";
  }
}

// done as a pass, we don't have Swift AST context for reporting diagnostics
bool SwiftRealtimeVerifier::runOnFunction(llvm::Function &F) {
  // this approach now obsolete
  // verifyRuntimeSafety(F);
  return false;
}

//===----------------------------------------------------------------------===//
//                           Top Level Entry Point
//===----------------------------------------------------------------------===//

llvm::FunctionPass *swift::createSwiftRealtimeVerifierPass() {
  return new SwiftRealtimeVerifier();
}
