#!/bin/csh -f
#
# SystemVerilog Coverage GUI

# The simulator will need to generate a coverage
# database for GUI use, add the following
# command to your testcase:
#  $set_coverage_db_name("MCA_Project");

source /classes/ee620/etc/cadence_env.csh

imc -gui -init etc/imc_gui.tcl
