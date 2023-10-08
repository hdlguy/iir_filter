// Second Order Section (SOS) of an IIR filter
// Direct Form I
// Five multiply-accummulate cycles are needed per sample.
//
module iir_sos #(
    parameter int   Ndint = 3,
    parameter int   Ndfrac = 22,
    parameter int   Ncint = 4,
    parameter int   Ncfrac = 14,
    // for example, [b, a] = butter(2, 0.25, "low"); [b a]
    parameter real  coeff[0:5] =  {97.631072937817507e-03, 195.262145875635014e-03, 97.631072937817507e-03, 1.000000000000000e+00, -942.809041582063173e-03, 333.333333333333258e-03}
)(
    input   logic                   clk,
    input   logic                   dv_in,
    input   logic[Ndint-1:-Ndfrac]  d_in,
    output  logic                   dv_out,
    output  logic[Ndint-1:-Ndfrac]  d_out
);

    // the fixed point coefficients. negative indexes are the fractional
    localparam logic[Ncint-1:-Ncfrac] b0 = (2**Ncfrac)*coeff[0];
    localparam logic[Ncint-1:-Ncfrac] b1 = (2**Ncfrac)*coeff[1];
    localparam logic[Ncint-1:-Ncfrac] b2 = (2**Ncfrac)*coeff[2];
    localparam logic[Ncint-1:-Ncfrac] a0 = (2**Ncfrac)*coeff[3];
    localparam logic[Ncint-1:-Ncfrac] a1 = (2**Ncfrac)*coeff[4];
    localparam logic[Ncint-1:-Ncfrac] a2 = (2**Ncfrac)*coeff[5];

    // the shift register for data and feedback.
    logic[2:0][Ndint-1:-Ndfrac]  x=0;
    logic[2:0][Ndint-1:-Ndfrac]  y=0;

    // the accumulator needs room for the five multiply accumulation cycles
    logic[Ndint+Ncint+3-1:Ndfrac+Ncfrac] acc=0;

    always_ff @(posedge clk) begin

        if (dv_in) begin
            x[0] <= d_in;
            x[1] <= x[0];
            x[2] <= x[1];
        end
        
    end

endmodule
