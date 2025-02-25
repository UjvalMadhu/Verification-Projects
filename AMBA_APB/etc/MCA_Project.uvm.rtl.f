+nowarnTFNPC
+nowarnIWFA
+nowarnSVTL

-xmerror CUVMPW
-nowarn DLNCML
-nowarn CUVWSP
-sysv_ext .sv
-sysv_ext .sv
-sysv_ext .svh
-sysv_ext .svp
-ALLOWREDEFINITION
-dumpstack
-access rwc
-uvmlinedebug
-uvmhome ${UVM_HOME}
//+UVM_VERBOSITY=UVM_LOW
//+UVM_VERBOSITY=UVM_MEDIUM
+UVM_VERBOSITY=UVM_HIGH
//+UVM_VERBOSITY=UVM_FULL
//+UVM_VERBOSITY=UVM_DEBUG
-define UVM_REG_DATA_WIDTH=64
${UVM_HOME}/src/dpi/uvm_dpi.cc
+UVM_TR_RECORD
+UVM_LOG_RECORD

-incdir src
-libverbose
-librescan

-top test

+UVM_TESTNAME=MCA_Project_test

src/timescale.v
src/MCA_Project_test.sv
src/MCA_Project.v

// 
// Insert your UVM / SystemVerilog Testbench files above
// Remove src/MCA_Project_test.sv if necessary
//
// --------------
//
//
// Uncomment for TSMC 180nm
// -v /classes/ee620/maieee/lib/tsmc-0.18/verilog/tsmc18.v
//
// Uncomment for TSMC 65nm
// -v /classes/ee620/maieee/lib/synopsys/TSMC_tcbc65/TSMCHOME/digital/Front_End/verilog/tcbn65lp_200a/tcbn65lp.v
//
// Uncomment for SAED 90nm
// -y /classes/ee620/maieee/lib/synopsys/SAED_EDK90nm/Digital_Standard_Cell_Library/verilog/
//
// Uncomment for SAED 32nm
-v /classes/ee620/maieee/lib/synopsys/SAED_EDK32-28nm/SAED32_EDK/lib/stdcell_rvt/verilog/saed32nm.v
-v /classes/ee620/maieee/lib/synopsys/SAED_EDK32-28nm/SAED32_EDK/lib/stdcell_lvt/verilog/saed32nm_lvt.v
-v /classes/ee620/maieee/lib/synopsys/SAED_EDK32-28nm/SAED32_EDK/lib/stdcell_hvt/verilog/saed32nm_hvt.v

//
+librescan
//
