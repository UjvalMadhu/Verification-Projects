
#
# This variable controls VHDL simulation errors and can
# stop a simulation if range constraint is detected when
# set to error
#
set rangecnst_severity_level warning
#
# dump switching activity for power analysis
#
dumpsaif -overwrite -hierarchy -scope test.top -output ./saif/MCA_Project_bw.saif
