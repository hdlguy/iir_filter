`timescale 1ns / 1ps

module iir_filter_tb ();

    // data word specification
    localparam int  Ndint = 3;
    localparam int  Ndfrac = 22;

    // coefficient specification
    localparam int  Ncint = 4;
    localparam int  Ncfrac = 14;
    localparam int  Nsos = 3;
    localparam real coeff[0:Nsos-1][0:5] =  {    
        '{ +0.9921264648, -1.9801635742, +0.9880371094, +1.0000000000, -1.9765014648, +0.9766845703 },
        '{ +0.9921264648, -1.9883422852, +0.9962158203, +1.0000000000, -1.9825439453, +0.9826660156 },
        '{ +0.9921264648, -1.9842529297, +0.9921264648, +1.0000000000, -1.9935302734, +0.9937133789 }
    };

    logic                   dv_in;
    logic[Ndint-1:-Ndfrac]  d_in;
    logic                   dv_out;
    logic[Ndint-1:-Ndfrac]  d_out;
    logic clk=0; localparam time clk_period = 10; always #(clk_period/2) clk=~clk;

    iir_filter #(.Ndint(Ndint), .Ndfrac(Ndfrac), .Ncint(Ncint), .Ncfrac(Ncfrac), .Nsos(Nsos), .coeff(coeff)) uut (.clk(clk), .dv_in(dv_in), .d_in(d_in), .dv_out(dv_out), .d_out(d_out));

    localparam int Gpulse = +2**Ndfrac;
    real phase, freq, rate;
    localparam real pi = 3.1419527;
    localparam real chirprate = 2.0*pi/((2.0**22.0)-1.0);
    initial begin
    
        dv_in = 0;
        d_in = 0;
        phase = 0;
        freq = -pi/64;
        rate = chirprate;
        #(clk_period*6);
        
        forever begin
        
            dv_in = 0;
            #(clk_period*6);
            dv_in = 1;
            phase = phase + freq;
            freq  = freq  + rate;
            d_in = (2.0**Ndfrac)*$sin(phase);
            #(clk_period*1);            
            
        end
        
    end

endmodule

/*
module iir_filter #(
    parameter int   Nsos = 1,
    parameter int   Ndint = 3,
    parameter int   Ndfrac = 22,
    parameter int   Ncint = 4,
    parameter int   Ncfrac = 14,
    parameter real  coeff[0:Nsos-1][0:5] =  {{97.631072937817507e-03, 195.262145875635014e-03, 97.631072937817507e-03, 1.000000000000000e+00, -942.809041582063173e-03, 333.333333333333258e-03}}
)(
    input   logic                   clk,
    input   logic                   dv_in,
    input   logic[Ndint-1:-Ndfrac]  d_in,
    output  logic                   dv_out,
    output  logic[Ndint-1:-Ndfrac]  d_out,
);
*/
