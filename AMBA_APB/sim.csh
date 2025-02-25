#!/bin/csh -f

source /classes/ee620/etc/cadence_env.csh

set DES = "MCA_Project" ;
set INCA = "./INCA_libs" ;
set WORKLIB = "/tmp/${USER}/worklib/${DES}" ;

set RTL = 0 ;
set VEC = 0 ;
set SPI = 0 ;
set NET = 0 ;
set NCSIM = 1 ;
set SV = 0 ;
set UVM = 0 ;
set GUI = 1 ;
set RUN = 0 ;
set SAIF = " "
set COV = 0 ;

set NC = "xrun +xmaccess+r +xmvpicompat+1364v1995 +nowarnTFNPC +nowarnIWFA +nowarnSVTL +nowarnSDFNCAP"
set XL = "verilog +access+r +linedebug +nowarnTFNPC +nowarnIWFA +nowarnSVTL +nowarnSDFA"

set i = 1 ;

#
# collect arguments
#
while ( $i <= $#argv )
  switch ( ${argv[${i}]} )
    case "-r":
      set RTL = 1 ;
      breaksw
    case "-n":
      set NET = 1 ;
      breaksw
    case "-v":
      set VEC = 1 ;
      breaksw
    case "-xl":
      set NCSIM = 0 ;
      breaksw
    case "-sv":
      set SV = 1 ;
      breaksw
    case "-uvm":
      set UVM = 1 ;
      breaksw
    case "-ng":
      set GUI = 0 ;
      breaksw
    case "-run":
      set RUN = 1 ;
      breaksw
    case "-c":
      set COV = 1 ;
      breaksw
    default:
      breaksw
  endsw
  @ i = $i + 1 ;
end

#
# check if any arguments are passed, and only 1 argument is passed
#
if ((( $RTL == 0 ) && ( $NET == 0 )) || (( $RTL == 1 ) && ( $NET == 1 ))) then
  echo "USAGE : $0 [-r] [-n] [-v] [-ng] [-sv] [-uvm] [-run] [-xl] [-c]"
  echo "        -r   : simulate RTL";
  echo "        -n   : simulate scan inserted netlist";
  echo " Note: only pass one of -r or -n";
  echo "        -v   : use vector based testbench";
  echo " Note: Default is to use the behavioral testbench";
  echo "        -ng  : do not start gui";
  echo " Note: Default is to use the GUI";
  echo "        -sv : add compilation support for SystemVerilog (XM Verilog only)";
  echo " Note: Default is to not support SystemVerilog";
  echo "        -uvm : add compilation support for UVM (XM Verilog only)";
  echo " Note: Default is to not support UVM";
  echo "        -run : start running simulation immediately";
  echo " Note: Default is for simlator to wait for user input";
  echo "        -xl  : simulate using Verilog-XL";
  echo " Note: Default is to use XM Verilog";
  echo "        -c  : generate functional coverage report information";
  echo " Note: This can only be used with SystemVerilog or UVM";
  exit
endif



if ( $NCSIM == 1 ) then
  set SIM = "${NC} -clean -xmlibdirname ${WORKLIB}"
  set SAIF = " -input etc/dumpsaif.tcl "
  if ( $SV == 1 ) then
  endif
else
  set SIM = "${XL}"
endif

if ( $GUI == 1 ) then
  set RGUI = "+gui +xmlinedebug"
else
  set RGUI = ""
endif

if ( $RUN == 1 ) then
  if ( $NCSIM == 1 ) then
    set RSIM = "-run +xmrun"
  endif
else
  set RSIM = "-s"
endif

if ( $VEC == 1 ) then
  set RVEC = ".vec"
else
  set RVEC = ""
endif

if ( $NCSIM == 1 ) then
  if ( $UVM == 1 ) then
    set USV = ".uvm"
    set SIM = "${SIM} +UVM_NO_RELNOTES -uvm +sv -sysv +xmsvseed+random"
    if ( $COV == 1) then
      set SIM = "${SIM} -coverage all -covoverwrite -covworkdir ./cov_work +xmcovfile+etc/cov_cmd.tcl"
    endif
    setenv UVM_HOME `xmroot`/tools/methodology/UVM/CDNS-1.2/sv
  else
    if ( $SV == 1 ) then
      set USV = ".sv"
      set SIM = "${SIM} +sv -sysv +xmsvseed+random"
      if ( $COV == 1) then
        set SIM = "${SIM} -coverage all -covoverwrite -covworkdir ./cov_work +xmcovfile+etc/cov_cmd.tcl"
      endif
    else
      set USV = ""
    endif
  endif
endif


\rm -rf ${INCA}
\rm -rf ${WORKLIB}

mkdir -p ${WORKLIB}

if ( -e ${HOME}/cds.lib ) then
        mv ${HOME}/cds.lib ${HOME}/cds.lib.bak
endif

if ( $RTL == 1 ) then

  if ( ! -d ./saif ) then
    mkdir ./saif
  endif

  ${SIM} \
	${RGUI} ${RSIM} \
	-f etc/${DES}${RVEC}${USV}.rtl.f \
	${SAIF} \

endif

if ( $NET == 1 ) then

  ${SIM} \
	${RGUI} ${RSIM} \
	-f etc/${DES}${RVEC}${USV}.gate.f \

endif

#
# Generate coverage report
#
if ( $NCSIM == 1 ) then
  if (( $SV == 1 ) || ( $UVM == 1 )) then
    if ( $COV == 1) then
      ./cov_rpt.csh
    endif
  endif
endif
