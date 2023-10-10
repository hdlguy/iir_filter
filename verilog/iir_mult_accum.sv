// multiplier for IIR Second Order Section.
// The idea is to have a single DSP48 reused sequentially for all five multiply-accumulate operations.
module iir_mult_accum #(
    parameter int Wa = 18,
    parameter int Wb = 25
)(
    input   logic           clk,
    input   logic           en,
    input   logic           ld,
    input   logic[Wa-1:0]   a,
    input   logic[Wb-1:0]   b,
    output  logic[47:0]     c
);

    logic[47:0] prod;
    assign prod = $signed(a) * $signed(b);

    always_ff @(posedge clk) begin
        if (en) begin
            if (ld) begin
                c <= prod;
            end else begin
                c <= $signed(c) + prod;
            end
        end
    end

endmodule
    
