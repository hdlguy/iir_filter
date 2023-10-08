module round_n_sat_tb ();

    localparam Win = 16;
    localparam Nsat = 1;
    localparam Nround = 5;
    logic [Win-1:0]  din;
    logic [Win-Nsat-Nround-1:0] dout;

    round_n_sat #(.Win(Win), .Nsat(Nsat), .Nround(Nround)) uut (.*);

    localparam clk_period = 10;
    logic clk = 0;
    always #(clk_period/2) clk = ~clk;

    initial begin
        reset = 1;
        #(clk_period*10);
        reset = 0;
    end

    logic reset;
    real pi = 3.14;
    real ph;
    real fr = 2.0*pi/511.555555;
    always_ff @(posedge clk) begin
        if (reset) begin
            ph <= 0;
        end else begin
            ph <= ph + fr;
        end
    end
    assign din = (0.55)*((2.0**(Win-1))-1.0)*$sin(ph);

endmodule



