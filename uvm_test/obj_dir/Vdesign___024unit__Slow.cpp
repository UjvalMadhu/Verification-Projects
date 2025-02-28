// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdesign.h for the primary calling header

#include "Vdesign__pch.h"
#include "Vdesign__Syms.h"
#include "Vdesign___024unit.h"

void Vdesign___024unit___ctor_var_reset(Vdesign___024unit* vlSelf);

Vdesign___024unit::Vdesign___024unit(Vdesign__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vdesign___024unit___ctor_var_reset(this);
}

void Vdesign___024unit::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vdesign___024unit::~Vdesign___024unit() {
}
