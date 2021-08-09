# This script sets up and compiles an HLS project.
#
# vitis_hls hls_build.tcl
# vitis_hls -p hls_proj/hls.app

open_project -reset hls_proj
add_files cpp/iir.hpp
add_files cpp/iir.cpp
add_files -tb cpp/iir_tb.cpp

open_solution -reset "solution1"
#set_part {xczu3eg-sfva625-1-i}
set_part {xc7a35ticsg324-1L}
create_clock -period 10 -name default

#set_directive_pipeline -II 10 "inv_4x4"
#set_directive_interface -mode ap_ctrl_hs "inv_4x4"
#set_directive_interface -mode ap_hs "inv_4x4" inputData
#set_directive_interface -mode ap_hs "inv_4x4" outputData

set_top iir::iir
csynth_design
export_design -rtl verilog -format ip_catalog -description "IIR Filter." -vendor "hdlguy" -display_name "IIR"
#export_design -rtl verilog -format ip_catalog -description IIR Filter. -vendor hdlguy -display_name HLS_IIR

exit

