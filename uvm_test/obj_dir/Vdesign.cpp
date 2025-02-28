// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vdesign__pch.h"

//============================================================
// Constructors

Vdesign::Vdesign(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vdesign__Syms(contextp(), _vcname__, this)}
    , __PVT____024unit{vlSymsp->TOP.__PVT____024unit}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vdesign::Vdesign(const char* _vcname__)
    : Vdesign(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vdesign::~Vdesign() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vdesign___024root___eval_debug_assertions(Vdesign___024root* vlSelf);
#endif  // VL_DEBUG
void Vdesign___024root___eval_static(Vdesign___024root* vlSelf);
void Vdesign___024root___eval_initial(Vdesign___024root* vlSelf);
void Vdesign___024root___eval_settle(Vdesign___024root* vlSelf);
void Vdesign___024root___eval(Vdesign___024root* vlSelf);

void Vdesign::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vdesign::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vdesign___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vdesign___024root___eval_static(&(vlSymsp->TOP));
        Vdesign___024root___eval_initial(&(vlSymsp->TOP));
        Vdesign___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vdesign___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vdesign::eventsPending() { return !vlSymsp->TOP.__VdlySched.empty(); }

uint64_t Vdesign::nextTimeSlot() { return vlSymsp->TOP.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vdesign::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vdesign___024root___eval_final(Vdesign___024root* vlSelf);

VL_ATTR_COLD void Vdesign::final() {
    Vdesign___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vdesign::hierName() const { return vlSymsp->name(); }
const char* Vdesign::modelName() const { return "Vdesign"; }
unsigned Vdesign::threads() const { return 1; }
void Vdesign::prepareClone() const { contextp()->prepareClone(); }
void Vdesign::atClone() const {
    contextp()->threadPoolpOnClone();
}
