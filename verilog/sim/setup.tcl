# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj 
set_property part xc7a35ticsg324-1L [current_project]
set_property target_language verilog [current_project]
set_property default_lib work [current_project]

read_ip ../iir_ila/iir_ila.xci
read_ip ../sinrom/sinrom.xci

reset_target all [get_files *.xci]
upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]


read_verilog -sv ../round_n_sat.sv
read_verilog -sv ../iir_mult_accum.sv
read_verilog -sv ../iir_sos_dsp48.sv
read_verilog -sv ../iir_filter.sv
read_verilog -sv ../top.sv
read_verilog -sv ../top_tb.sv
#read_verilog -sv ../iir_filter_tb.sv

#add_files -fileset sim_1 -norecurse ./iir_filter_tb_behav.wcfg
add_files -fileset sim_1 -norecurse ./top_tb_behav.wcfg

close_project


