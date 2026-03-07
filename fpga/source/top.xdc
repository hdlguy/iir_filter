set_property PACKAGE_PIN E3 [get_ports clk_in]
set_property IOSTANDARD LVCMOS33 [get_ports clk_in]

create_clock -period 10.000 -name clk_in -waveform {0.000 5.000} [get_ports clk_in]