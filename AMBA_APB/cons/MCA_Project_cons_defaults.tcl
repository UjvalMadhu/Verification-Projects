
#
# dc default constraint settings
#

#/* 100 MHz */
set CLK_PERIOD 10.00
set CLK_SKEW     [expr $CLK_PERIOD*0.0100]
set INPUT_DELAY  [expr $CLK_PERIOD*0.0020]
set OUTPUT_DELAY [expr $CLK_PERIOD*0.0050]
set RCC_MULT 2

#/* Output Load Multiplier */
set LOAD_MULT 10



