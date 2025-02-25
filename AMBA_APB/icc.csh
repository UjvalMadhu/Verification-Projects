#!/bin/csh -f

if (-e /tools/rhel6/env/synopsys_env.csh) then
        source /tools/rhel6/env/synopsys_env.csh
endif 

set base = icc
set scr = cmp
set NGUI = 0 ;
set GUI = 0 ;

set i = 1 ;

#
# collect arguments
#
while ( $i <= $#argv )
  switch ( ${argv[${i}]} )
    case "-n":
      set NGUI = 1 ;
      breaksw
    case "-g":
      set GUI = 1 ;
      breaksw
    default:
      breaksw
  endsw
  @ i = $i + 1 ;
end

#
# check if any arguments are passed, and at least 2 arguments are passed
#
if (( $NGUI == 0 ) && ( $GUI == 0 )) then
  echo "USAGE : $0 [-n] [-g]"
  echo "        -n   : no GUI";
  echo "        -g   : launch GUI";
  exit
endif

if ( $NGUI == 1 ) then
	${base}_shell -shared_license -no_gui < ${base}/${scr}_${base}.tcl |& tee ${base}_shell_${scr}.log
endif

if ( $GUI == 1 ) then
	${base}_shell -shared_license -gui -f ${base}/${scr}_${base}.tcl |& tee ${base}_shell_${scr}.log
endif
