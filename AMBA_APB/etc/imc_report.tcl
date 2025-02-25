load ./cov_work/scope/MCA_Project
exec mkdir -p report
exec mkdir -p report/coverage
#report -out report/coverage/coverage.rpt -detail -metrics covergroup -all -aspect both -assertionStatus -allAssertionCounters -type *
report_metrics -out report/coverage/coverage.rpt -overwrite -detail -metrics covergroup -all -aspect both -assertionStatus -allAssertionCounters -type *
