`timescale 1ns / 1ps

module iir_sos_tb ();

    localparam int      Ndint = 3;
    localparam int      Ndfrac = 22;
    localparam int      Ncint = 4;
    localparam int      Ncfrac = 14;
    localparam real     coeff[0:5] =  {97.631072937817507e-03, 195.262145875635014e-03, 97.631072937817507e-03, 1.000000000000000e+00, -942.809041582063173e-03, 333.333333333333258e-03};

    logic                   dv_in;
    logic[Ndint-1:-Ndfrac]  d_in;
    logic                   dv_out;
    logic[Ndint-1:-Ndfrac]  d_out;
    logic clk=0; localparam time clk_period = 10; always #(clk_period/2) clk=~clk;

    iir_sos #(.Ndint(Ndint), .Ndfrac(Ndfrac), .Ncint(Ncint), .Ncfrac(Ncfrac), .coeff(coeff)) uut (.*);

    localparam int Gpulse = +2**Ndfrac;
    real phase, freq, rate;
    localparam real pi = 3.1419527;
    localparam real chirprate = 2.0*pi/((2.0**16.0)-1.0);
    initial begin
    
        dv_in = 0;
        d_in = 0;
        phase = 0;
        freq = 0;
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

//    localparam int Npulse = 500;
//    localparam int Gpulse = +2**Ndfrac;
//    initial begin
    
//        dv_in = 0;
//        d_in = 0;
//        #(clk_period*6);
        
//        forever begin
        
//            for (int i=0; i<Npulse; i++) begin
//                dv_in = 0;
//                #(clk_period*6);
//                dv_in = 1;
//                d_in = 0;
//                #(clk_period*1);
//            end
            
//            for (int i=0; i<Npulse; i++) begin
//                dv_in = 0;
//                #(clk_period*6);
//                dv_in = 1;
//                d_in = +Gpulse;
//                #(clk_period*1);
//            end
            
//        end
        
//    end


/*
module iir_sos #(
    parameter int       Ndint = 3,
    parameter int       Ndfrac = 22,
    parameter int       Ncint = 4,
    parameter int       Ncfrac = 14,
    // for example, [b, a] = butter(2, 0.25, "low"); [b a]
    parameter real[0:5] coeff =  {97.631072937817507e-03, 195.262145875635014e-03, 97.631072937817507e-03, 1.000000000000000e+00, -942.809041582063173e-03, 333.333333333333258e-03}
)(
    input   logic                   clk,
    input   logic                   dv_in,
    input   logic[Ndint-1:-Ndfrac]  d_in,
    output  logic                   dv_out,
    output  logic[Ndint-1:-Ndfrac]  d_out,
)
*/
