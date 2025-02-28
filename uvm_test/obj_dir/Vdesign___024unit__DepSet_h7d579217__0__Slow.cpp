// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdesign.h for the primary calling header

#include "Vdesign__pch.h"
#include "Vdesign___024unit.h"

VL_ATTR_COLD void Vdesign___024unit___ctor_var_reset(Vdesign___024unit* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+  Vdesign___024unit___ctor_var_reset\n"); );
    Vdesign__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->__VmonitorOff = VL_RAND_RESET_I(1);
}
