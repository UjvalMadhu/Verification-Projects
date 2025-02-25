
Top level directories:

src......source files
include..header files
etc......tool arguments files
report...synthesis report files
netlist..post synthesis netlists
sdf......post synthesis timing data
icc......physical synthesis tool scripts
dc.......synthesis tool scripts
pt.......timing analysis tool scripts
pr.......power analysis tool scripts
cons.....design constraints


The following scripts are used to simulate, synthesize the
design:

./sim.csh.......RTL/Netlist Simulation Script
./syn.csh.......Logic Synthesize Script
./pt.csh........Timing Analysis Script
./pr.csh........Power Analysis Analysis Script

The following scripts are used Physical Synthesis, Place and Route of
the design:

./icc.csh.......IC Compiler Script

The following scripts are used to report and explore
coverage metrics (working in SystemVerilog and UVM)

./cov_rpt.csh...Coverage Report Script
./imc.csh.......Coverage GUI Launch Script
 
Obviously the gate level design will require substantially more time
to simulate than the RTL design.

