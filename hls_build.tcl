# This script sets up and compiles an HLS project.
#
# vivado_hls hls_build.tcl
# cd csynth
# vivado_hls vivado_hls.app

open_project -reset csynth
set_top viterbi_decoder_top
add_files source/viterbi_decoder.h
add_files source/viterbi_decoder.cpp
add_files -tb source/viterbi_decoder_tb.cpp

open_solution -reset "solution1"
set_part {xczu3eg-sfva625-1-i} -tool vivado
create_clock -period 10 -name default

set_directive_pipeline -II 10 "viterbi_decoder_top"
set_directive_interface -mode ap_ctrl_hs "viterbi_decoder_top"
set_directive_interface -mode ap_hs "viterbi_decoder_top" inputData
set_directive_interface -mode ap_hs "viterbi_decoder_top" outputData

csynth_design
export_design -rtl verilog -format ip_catalog -description "HLS Viterbi Decoder." -vendor "precisionplanting" -display_name "viterbi_decoder"

exit

