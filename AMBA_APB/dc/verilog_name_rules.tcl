#/* to fix those pesky escaped names */
#/* to be used with 'change_names -hierarchy' */
#/* after a compile - should only be needed in */
#/* extreme cases when 'bus_naming_style' isn't fully working */
define_name_rules Verilog -special verilog -allowed {a-z A-Z 0-9 _} -first_restricted {0-9 _} -replacement_char "__" -type cell
define_name_rules Verilog -special verilog -allowed {a-z A-Z 0-9 _ [ ]} -first_restricted {0-9 _ [ ]} -replacement_char "__" -type port -equal_ports_nets
define_name_rules Verilog -special verilog -allowed {a-z A-Z 0-9 _ [ ]} -first_restricted {0-9 _ [ ]} -replacement_char "__" -type net -equal_ports_nets
set default_name_rules Verilog
#

