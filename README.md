# hls_iir_filter

## Overview

This project implements an IIR digital filter in FPGA logic as a cascade of second order sections using Octave, Vivado HLS and C++.

## Files

./hls_build.tcl - Vitis HLS tcl script to convert the C++ filter design into a Vivado IP core.

./fpga/implement: - Contains Vivado tcl scripts to compile the filter into hardware.

./fpga/source: - Systemverilog source for hardware implementation.

./octave: - M script to generate the filter coefficients for the filter.

./src: - C++ source files for the IIR filter.

