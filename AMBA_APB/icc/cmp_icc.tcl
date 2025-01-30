
#
# set design name
#
set design_name MCA_Project

set my_type "_icc"
set my_input_type "_scan"

set my_max_area 1200
#
# compile effort can be: low, medium, high
#
set my_compile_effort "high"

set hdlin_enable_presto false
set hdlin_keep_signal_name all

set bus_naming_style {%s[%d]}
set bus_inference_style {%s[%d]}

#/* connect to all ports in the design, even if driven by the same net */
#/* compile_fix_multiple_port_nets = true */
set_fix_multiple_port_nets -all -buffer_constants

#/* do not allow wire type tri in the netlist */
set verilogout_no_tri true

set verilogout_equation false

#/* to fix those pesky escaped names */
#/* to be used with 'change_names -hierarchy' */
#/* after a compile - should only be needed in */
#/* extreme cases when 'bus_naming_style' isn't fully working */
define_name_rules Verilog -allowed {a-z A-Z 0-9 _} -first_restricted {0-9 _} -replacement_char "__" -type cell
define_name_rules Verilog -allowed {a-z A-Z 0-9 _ []} -first_restricted {0-9 _} -replacement_char "__" -type port
define_name_rules Verilog -allowed {a-z A-Z 0-9 _} -first_restricted {0-9 _} -replacement_char "__" -type net
set default_name_rules Verilog

#
# for SAIF file generation
#
set power_preserve_rtl_hier_names true

remove_design -all
file delete -force "./gds/" "./lib"
file delete "./PIM_Cluster_port_map.*"
file mkdir "./gds/" "./lib" "./netlist" "./sdf" "./spf" \
	"./report" "./report/dc" "./report/pt" "./report/pr" "./report/icc" "./saif"

set report_dir "./report/icc/"
set saif_dir "./saif/"

set hdlin_use_cin true
set synlib_model_map_effort "high"
set hdlout_uses_internal_busses true
# Turn on auto wire load selection
# (library must support this feature)
set auto_wire_load_selection true

set synlib_wait_for_design_license "DesignWare"

#/* set technology library */
source "dc/tech_config.tcl"

set link_library [concat  $link_library $synthetic_library]

#
#/*********************************************************/
#/*                                                       */
#/* Set up environment for ic compiler                    */
#/*                                                       */
#/*********************************************************/
#
set SAED_EDK32nm_ROOT "/class/ee620/maieee/lib/synopsys/SAED_EDK32-28nm/SAED32_EDK"
set PR_MW_LIB [format "%s%s" [format "%s%s" "./lib/" $design_name] $my_type]
set SAED_EDK32nm_MW_TF "saed32nm_1p9m_mw.tf"
set SAED_EDK32nm_OA_TF "saed32nm_1p9m_oa.tf"
set SAED_EDK32nm_REF_LIB [list \
	"${SAED_EDK32nm_ROOT}/lib/stdcell_rvt/milkyway/saed32nm_rvt_1p9m" \
	"${SAED_EDK32nm_ROOT}/lib/stdcell_lvt/milkyway/saed32nm_lvt_1p9m" \
	"${SAED_EDK32nm_ROOT}/lib/stdcell_hvt/milkyway/saed32nm_hvt_1p9m" \
]

# Create Milkyway library
create_mw_lib \
	-technology ${SAED_EDK32nm_ROOT}/tech/milkyway/${SAED_EDK32nm_MW_TF} \
	-mw_reference_library ${SAED_EDK32nm_REF_LIB} \
	-bus_naming_style {[%d]} \
	${PR_MW_LIB}

# Add timing and cap libraries
set_tlu_plus_files \
	-max_tluplus ${SAED_EDK32nm_ROOT}/tech/star_rcxt/saed32nm_1p9m_Cmax.tluplus \
	-min_tluplus ${SAED_EDK32nm_ROOT}/tech/star_rcxt/saed32nm_1p9m_Cmin.tluplus \
	-tech2itf_map ${SAED_EDK32nm_ROOT}/tech/milkyway/saed32nm_tf_itf_tluplus.map

open_mw_lib ${PR_MW_LIB}

file copy .oalib ${PR_MW_LIB}

import_design [list [format "%s%s%s%s" "netlist/" $design_name $tech_lib "${my_input_type}.vs"]] \
	-format verilog \
	-top $design_name \
	-cel $design_name

current_design $design_name
current_mw_cel [get_mw_cel $design_name]

read_sdf [list [format "%s%s%s%s" "sdf/" $design_name $tech_lib "${my_input_type}.sdf"]]

#
# apply constraints
#
source "cons/${design_name}_cons_defaults_icc.tcl"
source "cons/${design_name}_clocks_cons.tcl"
source "cons/${design_name}_cons_icc.tcl"

set_clock_uncertainty 0 clk

current_design $design_name
current_mw_cel [get_mw_cel $design_name]

#
# uncomment the following commmands to constrain routing layers - in this case M1 to M5
#
#set_ignored_layers -min_routing_layer M1 -max_routing_layer M5
#
#set_route_zrt_common_options \
#        -global_min_layer_mode hard \
#        -global_max_layer_mode hard
#

# Add power rails
set power "VDD"
set ground "VSS"
set powerPort "VDD"
set groundPort "VSS"
foreach net {VDD} {
	derive_pg_connection -power_net $net -power_pin $net -create_ports top
}
foreach net {VSS} {
	derive_pg_connection -ground_net $net -ground_pin $net -create_ports top
}
derive_pg_connection -tie

current_design $design_name
current_mw_cel [get_mw_cel $design_name]

echo [concat {++++ Floorplan Design}]
# Create floor plan
create_floorplan \
	-control_type aspect_ratio \
	-core_utilization 0.80 \
	-core_aspect_ratio 1.0 \
	-left_io2core 0.50 \
	-bottom_io2core 0.50 \
	-right_io2core 0.50 \
	-top_io2core 0.50
save_mw_cel

current_design $design_name
current_mw_cel [get_mw_cel $design_name]

echo [concat {++++ Create Power Rings}]
# Create power rings
create_rectangular_rings \
	-nets {VDD VSS} \
	-left_offset 0.2 \
	-left_segment_width 1 \
	-right_offset 0.2 \
	-right_segment_width 1 \
	-bottom_offset 0.2 \
	-bottom_segment_width 1 \
	-top_offset 0.2 \
	-top_segment_width 1
save_mw_cel

current_design $design_name
current_mw_cel [get_mw_cel $design_name]

echo [concat {++++ Place Design}]
get_scan_chains
# Run placer
place_opt \
	-area_recovery \
	-congestion \
	-power \
	-continue_on_missing_scandef \
	-cts
save_mw_cel

current_design $design_name
current_mw_cel [get_mw_cel $design_name]

echo [concat {++++ Route Power Rails}]
# Route power rails
preroute_standard_cells -nets {VDD VSS} \
	-connect horizontal \
	-extend_to_boundaries_and_generate_pins
save_mw_cel

current_design $design_name
current_mw_cel [get_mw_cel $design_name]

echo [concat {++++ Insert Clock Tree}]
# Insert clock tree
clock_opt \
	-fix_hold_all_clocks \
	-area_recovery \
	-congestion \
	-continue_on_missing_scandef \
	-power
save_mw_cel

echo [concat {++++ Pre-Route Timing Analysis}]
# Check timing
current_design $design_name
current_mw_cel [get_mw_cel $design_name]
redirect [format "%s%s"  [format "%s%s"  [format "%s%s"  $report_dir $design_name] $tech_lib] "${my_type}.rpt"] { echo [concat {Pre-Route Timing Analysis}] }
redirect -append [format "%s%s"  [format "%s%s"  [format "%s%s"  $report_dir $design_name] $tech_lib] "${my_type}.rpt"] { report_clock_tree }
redirect -append [format "%s%s"  [format "%s%s"  [format "%s%s"  $report_dir $design_name] $tech_lib] "${my_type}.rpt"] { report_timing -sign 4 -max_paths 10 }
redirect -append [format "%s%s"  [format "%s%s"  [format "%s%s"  $report_dir $design_name] $tech_lib] "${my_type}.rpt"] { report_area }
redirect -append [format "%s%s"  [format "%s%s"  [format "%s%s"  $report_dir $design_name] $tech_lib] "${my_type}.rpt"] { report_area -hierarchy }


current_design $design_name
current_mw_cel [get_mw_cel $design_name]

echo [concat {++++ Route Design}]
# route design
route_opt -effort high
save_mw_cel

echo [concat {++++ Check, Fix DRC Errors}]
# Check & Fix DRC Errors
route_search_repair \
	-rerun_drc \
	-loop "4" \
	-num_cpus "4" \
	-run_time_limit "10"
save_mw_cel

echo [concat {++++ Check, Fix LVS Errors}]
# Check & Fix LVS Errors
route_zrt_eco -max_detail_route_iterations 5
verify_lvs -check_open_locator -check_short_locator
save_mw_cel

# Add filler cells
insert_stdcell_filler \
	-cell_without_metal "SHFILL128_RVT SHFILL64_RVT SHFILL3_RVT SHFILL2_RVT SHFILL1_RVT" \
	-connect_to_power {VDD} \
	-connect_to_ground {VSS}
save_mw_cel

# Fix power nets
foreach net {VDD} {
	derive_pg_connection -power_net $net -power_pin $net -create_ports top
}
foreach net {VSS} {
	derive_pg_connection -ground_net $net -ground_pin $net -create_ports top
}
save_mw_cel

echo [concat {++++ Check DRC}]
# Run DRC & LVS
verify_route \
	-num_cpu "4"

echo [concat {++++ Check LVS}]
verify_lvs

echo [concat {++++ Post-Route Timing Analysis}]
# Check timing
current_design $design_name
current_mw_cel [get_mw_cel $design_name]
redirect -append [format "%s%s"  [format "%s%s"  [format "%s%s"  $report_dir $design_name] $tech_lib] "${my_type}.rpt"] { echo [concat {Post-Route Timing Analysis}] }
redirect -append [format "%s%s"  [format "%s%s"  [format "%s%s"  $report_dir $design_name] $tech_lib] "${my_type}.rpt"] { report_clock_tree }
redirect -append [format "%s%s"  [format "%s%s"  [format "%s%s"  $report_dir $design_name] $tech_lib] "${my_type}.rpt"] { report_timing -sign 4 -max_paths 10 }
redirect -append [format "%s%s"  [format "%s%s"  [format "%s%s"  $report_dir $design_name] $tech_lib] "${my_type}.rpt"] { report_area }
redirect -append [format "%s%s"  [format "%s%s"  [format "%s%s"  $report_dir $design_name] $tech_lib] "${my_type}.rpt"] { report_area -hierarchy }

echo [concat {++++ Post-Route Power Analysis}]
current_design $design_name
current_mw_cel [get_mw_cel $design_name]

if {[file exists [format "%s%s" $saif_dir "${design_name}_bw.saif"]]} {
	reset_switching_activity
	echo [concat {Reading Backwards SAIF File}]
	read_saif -input [format "%s%s" $saif_dir "${design_name}_bw.saif"] -instance_name test/top
}

redirect -append [format "%s%s"  [format "%s%s"  [format "%s%s"  $report_dir $design_name] $tech_lib] "${my_type}.rpt"] { echo [concat {Post-Route Power Analysis}] }
redirect -append [format "%s%s"  [format "%s%s"  [format "%s%s"  $report_dir $design_name] $tech_lib] "${my_type}.rpt"] { report_power -analysis_effort medium -verbose }
redirect -append [format "%s%s"  [format "%s%s"  [format "%s%s"  $report_dir $design_name] $tech_lib] "${my_type}.rpt"] { report_power -analysis_effort medium -verbose -hier }

echo [concat {++++ Stream out GDSII, Netlist and SDF}]
current_design $design_name
current_mw_cel [get_mw_cel $design_name]
# Stream out GDSII
set_write_stream_options \
	-output_pin {text geometry} \
	-keep_data_type

write_stream \
	-format gds \
	[format "%s%s" [format "%s%s" "./gds/" $design_name] ".gds"]

#
# Write Netlist and SDF
#
current_design $design_name
current_mw_cel [get_mw_cel $design_name]
change_names -rules Verilog -hierarchy
write_verilog [format "%s%s"  [format "%s%s"  [format "%s%s"  "./netlist/" $design_name] $tech_lib] "${my_type}.vs"]
write_sdf -context verilog [format "%s%s"  [format "%s%s"  [format "%s%s"  "./sdf/" $design_name] $tech_lib] "${my_type}.sdf"]
save_mw_cel
close_mw_cel

echo [concat {++++ Finished...}]

