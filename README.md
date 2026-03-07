# hls_iir_filter

## Overview

This project implements an IIR digital filter in FPGA logic as a cascade of second order sections using Octave, Vivado HLS C++ and Systemverilog.

HLS introduces complexity of the build process so a pure Systemverilog version of the filter is provided.

A 10th order IIR low-pass filter is demonstrated in Verilog and tested in hardware.

## Files

./hls_build.tcl - Vitis HLS tcl script to convert the C++ filter design into a Vivado IP core.

./fpga/implement - Contains Vivado tcl scripts to compile the filter into hardware.

./fpga/source - Systemverilog source for hardware implementation.

./octave - M script to generate the filter coefficients for the filter.

./cpp - C++ source files for the IIR filter.

./verilog - pure verilog version of the IIR filter.

