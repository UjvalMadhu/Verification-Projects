// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdesign.h for the primary calling header

#include "Vdesign__pch.h"
#include "Vdesign__Syms.h"
#include "Vdesign___024root.h"

void Vdesign___024root___ctor_var_reset(Vdesign___024root* vlSelf);

Vdesign___024root::Vdesign___024root(Vdesign__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vdesign___024root___ctor_var_reset(this);
}

void Vdesign___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vdesign___024root::~Vdesign___024root() {
}
