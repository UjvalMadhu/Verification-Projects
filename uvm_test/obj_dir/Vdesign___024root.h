// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vdesign.h for the primary calling header

#ifndef VERILATED_VDESIGN___024ROOT_H_
#define VERILATED_VDESIGN___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"
class Vdesign___024unit;


class Vdesign__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vdesign___024root final : public VerilatedModule {
  public:
    // CELLS
    Vdesign___024unit* __PVT____024unit;

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ top__DOT__clk;
    CData/*0:0*/ top__DOT__reset;
    CData/*0:0*/ top__DOT__enable;
    CData/*3:0*/ top__DOT__count;
    CData/*3:0*/ __Vtrigprevexpr___TOP__top__DOT__count__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__top__DOT__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__top__DOT__reset__0;
    CData/*0:0*/ __VactDidInit;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ __VactIterCount;
    VlDelayScheduler __VdlySched;
    VlTriggerVec<4> __VactTriggered;
    VlTriggerVec<4> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vdesign__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vdesign___024root(Vdesign__Syms* symsp, const char* v__name);
    ~Vdesign___024root();
    VL_UNCOPYABLE(Vdesign___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
