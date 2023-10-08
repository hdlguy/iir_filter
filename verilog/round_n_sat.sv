module round_n_sat  #(
    parameter Win  = 16,      // input width
    parameter Nround = 3, // number of LSB's to remove.
    parameter Nsat = 4    // number of MSB's to remove.
)(
    input  logic [Win-1:0]                      din,
    output logic [Win-Nsat-Nround-1:0]  dout
);

    // Create the number to add onto din to affect rounding. It has a '1' in the bit below the least significant bit that we are going to keep.
    logic[Win-1:0] rounder = { {(Win-Nround){1'b0}}, 1'b1, {(Nround-1){1'b0}} } ;  

    logic[Win:0] round_val;                             // 1 bit longer to take possible overflow due to rounding operation.
    assign round_val = $signed(rounder) + $signed(din); // $signed() causes sign extension.

    logic[Nsat+1:0] sat_check;
    assign sat_check = round_val[Win:Win-Nsat-1];  // part of round_val we want to saturate off plus one more bit which is the MSB we want to keep.

    logic sat_detect; // debug signal
    always_comb begin
        // check if discarded bits all equal the MS retained bit.  
        if ( (sat_check == {(Nsat+2){1'b1}}) || (sat_check == {(Nsat+2){1'b0}}) ) begin
            dout = round_val[Win-Nsat-1:Nround]; // no saturation
            sat_detect = 0;            
        end else begin
            sat_detect = 1;
            // saturate to most positive or most negative
            if(1==din[Win-1])
                dout = {1'b1, {(Win-Nsat-Nround-1){1'b0}}};  // most negative value
            else
                dout = {1'b0, {(Win-Nsat-Nround-1){1'b1}}};  // most positive value
        end
    end
   
endmodule


