# This script sets up a Vivado project with all ip references resolved.
# vivado -mode batch -source setup.tcl
# vivado -mode batch -source compile.tcl
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs

create_project -force proj 
set_property part xc7a35ticsg324-1L [current_project]
set_property target_language verilog [current_project]
set_property default_lib work [current_project]
load_features ipintegrator
tclapp::install ultrafast -quiet

set_property  ip_repo_paths  ../../hls_proj/solution1/impl/ip/ [current_project]
#set_property  ip_repo_paths  /home/pedro/git/hls_test/iir_test/hls_proj/solution1/impl/ip [current_project]
update_ip_catalog

#read_ip ../../source/artix_vio/artix_vio.xci
upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]

#read_verilog -sv [glob ../../source/arty_top.v]

#read_xdc ../../source/arty_top.xdc

close_project


