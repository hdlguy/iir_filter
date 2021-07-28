module top(
    input clk_in
);

    logic clk;
    clk_wiz clk_wiz_inst (.clk_out1(clk), .locked(), .clk_in1(clk_in));   // reduce clock from 100MHz to 50MHz

    logic ap_start, ap_done, ap_idle, ap_ready;
    logic [19:0] x = 20'h1_0000;
    logic [19:0] ap_return;
    
    assign ap_start = 1;

    iir_hls_core uut (
       .ap_clk      (clk),          // input wire ap_clk
       .ap_rst      (0),            // input wire ap_rst
       .ap_start    (ap_start),     // input wire ap_start
       .ap_done     (ap_done),      // output wire ap_done
       .ap_idle     (ap_idle),      // output wire ap_idle
       .ap_ready    (ap_ready),     // output wire ap_ready
       .ap_return   (ap_return),    // output wire [19 : 0] ap_return
       .x           (x)             // input wire [19 : 0] x
    );
    
    logic [9:0] samp_count = 8'h3_ff;
    always_ff @(posedge clk) begin
        samp_count <= samp_count - 1;
        if (0 == samp_count) x <= 20'h1_0000; else x <= 0;
        //if (0 == samp_count) x <= -x;
    end
    
    iir_ila iir_ila_inst (.clk(clk), .probe0({ap_start, ap_done, ap_idle, ap_ready, x, ap_return})); // 44

endmodule
    