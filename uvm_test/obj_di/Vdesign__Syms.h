// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VDESIGN__SYMS_H_
#define VERILATED_VDESIGN__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vdesign.h"

// INCLUDE MODULE CLASSES
#include "Vdesign___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vdesign__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vdesign* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vdesign___024root              TOP;

    // CONSTRUCTORS
    Vdesign__Syms(VerilatedContext* contextp, const char* namep, Vdesign* modelp);
    ~Vdesign__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
