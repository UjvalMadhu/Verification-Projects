// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vdesign__pch.h"
#include "Vdesign.h"
#include "Vdesign___024root.h"

// FUNCTIONS
Vdesign__Syms::~Vdesign__Syms()
{
}

Vdesign__Syms::Vdesign__Syms(VerilatedContext* contextp, const char* namep, Vdesign* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
        // Check resources
        Verilated::stackCheck(13);
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-9);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
}
