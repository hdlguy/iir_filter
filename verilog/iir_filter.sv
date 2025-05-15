// This is an iir filter built from cascaded second order sections.
// The characteristics of the filter are controlled by parameters.
//
// https://github.com/hdlguy/hls_iir_filter.git
// MIT License
//
module iir_filter #(
    parameter int  Ncint  = 4,  // number of coefficient integer bits
    parameter int  Ncfrac = 14, // number of coefficient fraction bits.
    parameter int  Nsos = 3,    // number of second order sections
    parameter real coeff[0:Nsos-1][0:5] =  {
        '{ +0.0025634766, +0.0051269531, +0.0025634766, +1.0000000000, -1.8066406250, +0.8165893555 },
        '{ +0.0025634766, +0.0051269531, +0.0025634766, +1.0000000000, -1.8521728516, +0.8623657227 },
        '{ +0.0025634766, +0.0051269531, +0.0025634766, +1.0000000000, -1.9366455078, +0.9473266602 }
    }
)(
    input   logic        clk,
    input   logic        dv_in,
    input   logic[17:0]  d_in,
    output  logic        dv_out,
    output  logic[17:0]  d_out
);

    localparam int Ndint = 3;   // number of integer bits in sample data word.
    localparam int Ndfrac = 22; // number of fraction bits in sample data word.
    
    logic dv[Nsos:0]; // data valid signals between SOS stages.
    logic[Ndint-1:-Ndfrac] data[Nsos:0];  // data between SOS stages.
    assign dv[0] = dv_in;
    assign data[0] = {{(Ndint-1){d_in[17]}}, d_in, 5'b00000}; // sign extend and zero pad 18 bit input to 25 bit filter word.
    

    // Second Order Sections
    generate for(genvar i=0; i<Nsos; i++) begin
        //iir_sos #(.Ndint(Ndint), .Ndfrac(Ndfrac), .Ncint(Ncint), .Ncfrac(Ncfrac), .coeff(coeff[i])) uut_real (.clk(clk), .dv_in(dv[i]), .d_in(data[i]), .dv_out(dv[i+1]), .d_out(data[i+1]));
        iir_sos_dsp48 #(.Ndint(Ndint), .Ndfrac(Ndfrac), .Ncint(Ncint), .Ncfrac(Ncfrac), .coeff(coeff[i])) uut_real (.clk(clk), .dv_in(dv[i]), .d_in(data[i]), .dv_out(dv[i+1]), .d_out(data[i+1]));
    end endgenerate
    

    // round and saturate from 25 bits down to 18 bit output word
    logic[17:0] dout_sat=0;
    round_n_sat #(.Win(Ndint+Ndfrac), .Nround(Ndfrac-17), .Nsat(Ndint-1)) sat_inst (.din(data[Nsos]), .dout(dout_sat));
    always_ff @(posedge clk) begin
        dv_out <= dv[Nsos];
        d_out  <= dout_sat;
    end

endmodule

/*
*/
