module top(
    input clk_in
);

    logic clk;
    assign clk = clk_in;

    logic ap_start, ap_done, ap_idle, ap_ready;
    logic [24:0] return_real, return_imag; // 3.22 format
    
    logic[2:0] start_count;
    logic[47:0] freq, phase;
    localparam real pi = 3.1415927;
    localparam logic[47:0] rate = (2.0**48.0)/(2.0**21) - 1.0;
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
            freq <= freq + rate;
            phase <= phase + freq;            
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
    logic [17:0] x_real, x_imag;  
    assign x_imag = m_axis_data_tdata[41:24];
    assign x_real = m_axis_data_tdata[17: 0];

    // filters    
    iir_filter_core uut_real (.ap_clk(clk), .ap_rst(0), .ap_start(m_axis_data_tvalid), .ap_ready(ap_ready), .ap_done(ap_done), .ap_idle(ap_idle), .ap_return(return_real), .x({{2{x_real[17]}}, x_real, 5'b00000}));
    iir_filter_core uut_imag (.ap_clk(clk), .ap_rst(0), .ap_start(m_axis_data_tvalid), .ap_ready(        ), .ap_done(       ), .ap_idle(       ), .ap_return(return_imag), .x({{2{x_imag[17]}}, x_imag, 5'b00000}));
    
    // saturate
    logic[17:0] dout_real, dout_imag;
    always_ff @(posedge clk) begin
    
        if ((return_real[24:22]==3'b000) || (return_real[24:22]==3'b111)) begin
            dout_real <= return_real[22 -: 18];
        end else begin
            if (return_real[24] == 1) begin
                dout_real <= -131072;
            end else begin
                dout_real <= +131071;
            end
        end     
           
        if ((return_imag[24:22]==3'b000) || (return_imag[24:22]==3'b111)) begin
            dout_imag <= return_imag[22 -: 18];
        end else begin
            if (return_imag[24] == 1) begin
                dout_imag <= -131072;
            end else begin
                dout_imag <= +131071;
            end
        end     
                   
    end

    // debug   
    logic ila_trigger;
    assign ila_trigger = freq[47]; 
    iir_ila iir_ila_inst (.clk(clk), .probe0({ila_trigger, ap_start, ap_done, ap_idle, ap_ready, x_real, x_imag, dout_real, dout_imag})); // 77

endmodule
    
/*
sinrom your_instance_name (
  .aclk(aclk),                                // input wire aclk
  .s_axis_phase_tvalid(s_axis_phase_tvalid),  // input wire s_axis_phase_tvalid
  .s_axis_phase_tdata(s_axis_phase_tdata),    // input wire [15 : 0] s_axis_phase_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid),    // output wire m_axis_data_tvalid
  .m_axis_data_tdata(m_axis_data_tdata)      // output wire [47 : 0] m_axis_data_tdata
);

iir_filter_core your_instance_name (
  .ap_clk(ap_clk),        // input wire ap_clk
  .ap_rst(ap_rst),        // input wire ap_rst
  .ap_start(ap_start),    // input wire ap_start
  .ap_done(ap_done),      // output wire ap_done
  .ap_idle(ap_idle),      // output wire ap_idle
  .ap_ready(ap_ready),    // output wire ap_ready
  .ap_return(ap_return),  // output wire [24 : 0] ap_return
  .x(x)                  // input wire [24 : 0] x
);
*/    