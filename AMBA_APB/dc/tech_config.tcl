
#/* set technology library */

set tsmc18 "../maieee/lib/tsmc-0.18/synopsys"
set tsmc065 "/classes/ee620/maieee/lib/synopsys/TSMC_tcbc65/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn65lp_200a"
set SAED_EDK90nm "/classes/ee620/maieee/lib/synopsys/SAED_EDK90nm/Digital_Standard_Cell_Library/synopsys/models/"
set SAED_EDK32nm_rvt "/classes/ee620/maieee/lib/synopsys/SAED_EDK32-28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm"
set SAED_EDK32nm_lvt "/classes/ee620/maieee/lib/synopsys/SAED_EDK32-28nm/SAED32_EDK/lib/stdcell_lvt/db_nldm"
set SAED_EDK32nm_hvt "/classes/ee620/maieee/lib/synopsys/SAED_EDK32-28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm"
set stdcells5u "../../lib/tech/synopsys"

set search_path [list . [format "%s%s"  $synopsys_root "/libraries/syn"] $tsmc18 $tsmc065 $SAED_EDK32nm_rvt $SAED_EDK32nm_lvt $SAED_EDK32nm_hvt $SAED_EDK90nm ./include ./src]

set tsmc18_tech_lib _tsmc18
set tsmc065_tech_lib _tsmc065
set saed90nm_tech_lib _saed90nm
set saed32nm_tech_lib _saed32nm
set tech_lib $saed32nm_tech_lib

set tsmc18_library_name "typical"
set tsmc18_library_file [list "typical.db"]

set tsmc065_library_name "tcbn65lptc"
set tsmc065_library_file [list "tcbn65lptc.db"]

set saed90nm_library_name "saed90nm_typ"
set saed90nm_library_file [list "saed90nm_typ.db"]

set saed32nm_library_name "saed32rvt_tt1p05v25c"
set saed32nm_library_file [list "saed32rvt_tt1p05v25c.db" "saed32lvt_tt1p05v25c.db" "saed32hvt_tt1p05v25c.db"]

if {$tech_lib == $tsmc18_tech_lib} {
  set library_name $tsmc18_library_name
  set library_file $tsmc18_library_file
}

if {$tech_lib == $tsmc065_tech_lib} {
  set library_name $tsmc065_library_name
  set library_file $tsmc065_library_file
}

if {$tech_lib == $saed90nm_tech_lib} {
  set library_name $saed90nm_library_name
  set library_file $saed90nm_library_file
}

if {$tech_lib == $saed32nm_tech_lib} {
  set library_name $saed32nm_library_name
  set library_file $saed32nm_library_file
}

set target_library $library_file
set link_library [concat  "*" $target_library]

