// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vdesign.h for the primary calling header

#ifndef VERILATED_VDESIGN___024UNIT_H_
#define VERILATED_VDESIGN___024UNIT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vdesign__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vdesign___024unit final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ __VmonitorOff;

    // INTERNAL VARIABLES
    Vdesign__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vdesign___024unit(Vdesign__Syms* symsp, const char* v__name);
    ~Vdesign___024unit();
    VL_UNCOPYABLE(Vdesign___024unit);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
