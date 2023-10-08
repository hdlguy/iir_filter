// Second Order Section (SOS) of an IIR filter
// Five multiply-accummulate cycles are needed per sample.
//
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

    // the fixed point coefficients. negative indexes are the fractional
    const logic[Ncint-1:-Ncfrac] b0 = Ncfrac*coeff[0];
    const logic[Ncint-1:-Ncfrac] b1 = Ncfrac*coeff[1];
    const logic[Ncint-1:-Ncfrac] b2 = Ncfrac*coeff[2];
    const logic[Ncint-1:-Ncfrac] a0 = Ncfrac*coeff[3];
    const logic[Ncint-1:-Ncfrac] a1 = Ncfrac*coeff[4];
    const logic[Ncint-1:-Ncfrac] a2 = Ncfrac*coeff[5];

    // the shift register for data and feedback.
    logic[2:0][Ndint-1:-Ndfrac]  x=0;
    logic[2:0][Ndint-1:-Ndfrac]  y=0;

    always_ff @(posedge clk) begin

        if (dv_in) begin
            x[0] <= d_in;
            x[1] <= x[0];
            x[2] <= x[1];
        end
        
    end

endmodule

