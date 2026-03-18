// Second Order Section (SOS) of an IIR filter
// Direct Form I
// Five multiply-accummulate cycles are needed per sample.
//
// https://github.com/hdlguy/hls_iir_filter.git
// MIT License
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
    logic[2:1][Ndint-1:-Ndfrac]  y=0;
    logic[Ndint-1:-Ndfrac]  acc_sat;

    // the accumulator needs room for the five multiply accumulation cycles
    logic[Ndint+Ncint+3-1:-(Ndfrac+Ncfrac)] acc=0;

    logic[5:0] dv_pipe=0;
    always_ff @(posedge clk) begin
    
        dv_out <= dv_in;

        // input sample shifter
        if (dv_in) begin
            x[0] <= d_in;
            x[1] <= x[0];
            x[2] <= x[1];
            y[1] <= acc_sat;
            y[2] <= y[1];
        end
        
        // simple shift register to track processing stage
        dv_pipe <= {dv_pipe[4:0], dv_in};
        
        // processing steps - can be done with 1 multiplier
        case (dv_pipe)
        
            6'b00_0001: begin
                acc <=                $signed(b0) * $signed(x[0]);
            end
            
            6'b00_0010: begin
                acc <= $signed(acc) + $signed(b1) * $signed(x[1]);
            end
            
            6'b00_0100: begin
                acc <= $signed(acc) + $signed(b2) * $signed(x[2]);
            end
            
            6'b00_1000: begin
                acc <= $signed(acc) - $signed(a1) * $signed(y[1]); // note the subtraction
            end
            
            6'b01_0000: begin
                acc <= $signed(acc) - $signed(a2) * $signed(y[2]);
            end
            
            6'b10_0000: begin
            end
            
            default: begin
            end
            
        endcase
        
    end
    
    // round and saturate the 48-bit accumulator word into the data word.
    round_n_sat #(.Win($bits(acc)), .Nround(Ncfrac), .Nsat(Ncint+3)) sat_inst (.din(acc), .dout(acc_sat));
    
    assign d_out = y[1];

endmodule

/*
module round_n_sat  #(
    parameter Win  = 16,      // input width
    parameter Nround = 3, // number of LSB's to remove.
    parameter Nsat = 4    // number of MSB's to remove.
)(
    input  logic [Win-1:0]                      din,
    output logic [Win-Nsat-Nround-1:0]  dout
);
*/
