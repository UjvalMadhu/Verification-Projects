+define+NETLIST+SDFSCAN
+notimingchecks
+nowarnTFNPC
+nowarnIWFA
+nowarnSVTL
src/timescale.v
src/MCA_Project_test.v
//
// Uncomment for TSMC 180nm
// -v ../maieee/lib/tsmc-0.18/verilog/tsmc18.v
//
// Uncomment for TSMC 65nm
// -v /classes/ee620/maieee/lib/synopsys/TSMC_tcbc65/TSMCHOME/digital/Front_End/verilog/tcbn65lp_200a/tcbn65lp.v
//
// Uncomment for SAED 90nm
// -v /classes/ee620/maieee/lib/synopsys/SAED_EDK90nm/Digital_Standard_Cell_Library/verilog/saed90nm.v
//
// Uncomment for SAED 32nm
-v /classes/ee620/maieee/lib/synopsys/SAED_EDK32-28nm/SAED32_EDK/lib/stdcell_rvt/verilog/saed32nm.v
-v /classes/ee620/maieee/lib/synopsys/SAED_EDK32-28nm/SAED32_EDK/lib/stdcell_lvt/verilog/saed32nm_lvt.v
-v /classes/ee620/maieee/lib/synopsys/SAED_EDK32-28nm/SAED32_EDK/lib/stdcell_hvt/verilog/saed32nm_hvt.v

//
+libext+.vs
+librescan
//
// Uncomment for TSMC 180nm
// -y netlist/MCA_Project_tsmc18_scan/
//
// Uncomment for TSMC 65nm
// -y netlist/MCA_Project_tsmc065_scan/
//
// Uncomment for SAED 90nm
// -y netlist/MCA_Project_saed90nm_scan/
//
// Uncomment for SAED 32nm
-y netlist/MCA_Project_saed32nm_scan/
