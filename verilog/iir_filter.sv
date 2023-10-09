//
module iir_filter #(
    parameter int   Ndint = 3,
    parameter int   Ndfrac = 22,
    parameter int  Ncint  = 4,
    parameter int  Ncfrac = 14,
    parameter int  Nsos = 3,
    parameter real coeff[0:Nsos-1][0:5] =  {
        '{ +0.0025634766, +0.0051269531, +0.0025634766, +1.0000000000, -1.8066406250, +0.8165893555 },
        '{ +0.0025634766, +0.0051269531, +0.0025634766, +1.0000000000, -1.8521728516, +0.8623657227 },
        '{ +0.0025634766, +0.0051269531, +0.0025634766, +1.0000000000, -1.9366455078, +0.9473266602 }
    }
)(
    input   logic                   clk,
    input   logic                   dv_in,
    input   logic[Ndint-1:-Ndfrac]  d_in,
    output  logic                   dv_out,
    output  logic[Ndint-1:-Ndfrac]  d_out
);

    logic   dv[Nsos:0]; // data valid signals between SOS stages.
    logic[Ndint-1:-Ndfrac] data[Nsos:0];  // data between SOS stages.
    assign dv[0] = dv_in;
    assign data[0] = d_in;

    // Second Order Sections
    generate for(genvar i=0; i<Nsos; i++) begin
        iir_sos #(.Ndint(Ndint), .Ndfrac(Ndfrac), .Ncint(Ncint), .Ncfrac(Ncfrac), .coeff(coeff[i])) uut_real (.clk(clk), .dv_in(dv[i]), .d_in(data[i]), .dv_out(dv[i+1]), .d_out(data[i+1]));
    end endgenerate

    assign dv_out = dv[Nsos];
    assign d_out  = data[Nsos];

endmodule

/*
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
*/
