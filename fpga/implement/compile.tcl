# Script to compile the FPGA with zynq processor system all the way to bit file.

close_project -quiet

open_project proj.xpr
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1

open_run impl_1
report_timing_summary   -file  ./results/timing.rpt
report_utilization      -file  ./results/utilization.rpt

write_debug_probes      -force ./results/top.ltx
write_bitstream         -force ./results/top.bit

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [get_designs impl_1]
write_bitstream         -force ./results/top_x4.bit
write_cfgmem -force -format mcs -size 16 -interface SPIx4 -loadbit {up 0x00000000 "./results/top_x4.bit" } -file "./results/top.mcs"

close_project


