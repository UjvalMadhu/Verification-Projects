TOPLEVEL_LANG ?= verilog
SIM ?= icarus
VERILOG_SOURCES = $(shell pwd)/half_add.sv $(shell pwd)/full_add.sv $(shell pwd)/rca4b.sv
TOPLEVEL := top # Verilog or SystemVerilog TOP file module name
MODULE   := rca4b_tb # Python file name
 
 
include $(shell cocotb-config --makefiles)/Makefile.sim