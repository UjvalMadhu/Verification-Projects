#include "obj_dir/Vdesign.h"  // Use the name Verilator actually generated
#include "verilated.h"
#include <iostream>

int main(int argc, char** argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);
    
    // Create an instance of our module under test
    Vdesign* top = new Vdesign;
    
    // Simulation variables
    vluint64_t sim_time = 0;
    
    // Run simulation for 100 cycles
    while (sim_time < 100) {
        // Toggle clock every cycle
        top->clk = (sim_time % 2) ? 1 : 0;
        
        // Reset for the first 10 clock cycles
        if (sim_time < 20) {
            top->reset = 1;
            top->enable = 0;
        } else {
            top->reset = 0;
            top->enable = 1;
        }
        
        // Evaluate model
        top->eval();
        
        // Print values only on rising clock edge
        if (top->clk == 1) {
            std::cout << "Cycle=" << (sim_time/2) 
                      << " reset=" << (int)top->reset
                      << " enable=" << (int)top->enable
                      << " count=" << (int)top->count << std::endl;
        }
        
        // Increment time
        sim_time++;
    }
    
    // Clean up
    delete top;
    return 0;
}