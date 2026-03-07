//
module top_tb ();

    localparam time clk_period = 10; logic clk=0; always #(clk_period/2) clk=~clk;

    top uut (.clk_in(clk));

endmodule
