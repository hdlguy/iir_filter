# This script sets up and compiles an HLS project.
#
# vitis_hls hls_build.tcl
# vitis_hls -p proj/hls.app

open_project -reset hls_proj
set_top iir
add_files src/iir.hpp
add_files src/iir.cpp
add_files src/sos.cpp
add_files -tb src/iir_tb.cpp

open_solution -reset "solution1"
set_part {xczu3eg-sfva625-1-i}
create_clock -period 10 -name default

#set_directive_pipeline -II 10 "inv_4x4"
#set_directive_interface -mode ap_ctrl_hs "inv_4x4"
#set_directive_interface -mode ap_hs "inv_4x4" inputData
#set_directive_interface -mode ap_hs "inv_4x4" outputData

csynth_design
export_design -rtl verilog -format ip_catalog -description "IIR Filter." -vendor "hdlguy" -display_name "IIR"
#export_design -rtl verilog -format ip_catalog -description IIR Filter. -vendor hdlguy -display_name HLS_IIR

exit

