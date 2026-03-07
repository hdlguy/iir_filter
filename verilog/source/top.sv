module top(
    input clk_in
);

    logic clk;
    assign clk = clk_in;

    // coefficient specification
    localparam int  Ncint  = 3;
    localparam int  Ncwidth = 18;
    localparam int  Ncfrac = Ncwidth - Ncint;
    localparam int  Nsos = 5;
    localparam real coeff[0:Nsos-1][0:5] =  '{
        '{ +0.002563476562, +0.005401611328, +0.002838134766, +1.000000000000, -1.803985595703, +0.813781738281 },
        '{ +0.002563476562, +0.005279541016, +0.002716064453, +1.000000000000, -1.818359375000, +0.828460693359 },
        '{ +0.002563476562, +0.005126953125, +0.002563476562, +1.000000000000, -1.852111816406, +0.862365722656 },
        '{ +0.002563476562, +0.004974365234, +0.002410888672, +1.000000000000, -1.899139404297, +0.909576416016 },
        '{ +0.002563476562, +0.004882812500, +0.002319335938, +1.000000000000, -1.957031250000, +0.967803955078 }
    };

    logic ap_start;
    
    logic[2:0] start_count=6;
    logic[47:0] freq=48'hff00_0000_0000, phase=0;
    localparam real pi = 3.1415927;
    localparam logic[47:0] rate = (2.0**27) - 1.0;
    always_ff @(posedge clk) begin
    
        // heartbeat
        if (start_count == 0) begin
            start_count <= 6;
            ap_start <= 1;
        end else begin
            start_count <= start_count - 1;
            ap_start <= 0;
        end
        
        // phase generator
        if (ap_start) begin
            freq  <= $signed(freq)  + $signed(rate);
            phase <= $signed(phase) + $signed(freq);            
        end    
                         
    end

        
    // sine rom
    logic m_axis_data_tvalid;
    logic [47 : 0] m_axis_data_tdata;
    sinrom sinrom_inst (
        .aclk(clk),                              
        .s_axis_phase_tvalid(ap_start),
        .s_axis_phase_tdata(phase[47 -: 16]),  
        .m_axis_data_tvalid(m_axis_data_tvalid),  
        .m_axis_data_tdata(m_axis_data_tdata)     
    );    
    logic [17:0] x_real, x_imag, y_real, y_imag;  
    assign x_imag = m_axis_data_tdata[41:24];
    assign x_real = m_axis_data_tdata[17: 0];

    // filters    
    logic dv_in, dv_out_real, dv_out_imag;
    assign dv_in = m_axis_data_tvalid;
    iir_filter #(.Ncint(Ncint), .Ncfrac(Ncfrac), .Nsos(Nsos), .coeff(coeff)) uut_real (.clk(clk), .dv_in(dv_in), .d_in(x_real), .dv_out(dv_out_real), .d_out(y_real));
    iir_filter #(.Ncint(Ncint), .Ncfrac(Ncfrac), .Nsos(Nsos), .coeff(coeff)) uut_imag (.clk(clk), .dv_in(dv_in), .d_in(x_imag), .dv_out(dv_out_imag), .d_out(y_imag));
    
    // debug   
    iir_ila iir_ila_inst (.clk(clk), .probe0({freq[47:40], dv_in, dv_out_real, x_real, y_real})); // 46

endmodule
    
/*

*/    
