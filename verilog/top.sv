module top(
    input clk_in
);

    logic clk;
    assign clk = clk_in;

    localparam int      Nsos = 1;
    localparam int      Ndint = 3;
    localparam int      Ndfrac = 22;
    localparam int      Ncint = 4;
    localparam int      Ncfrac = 14;
    localparam real     coeff[0:5] =  {97.631072937817507e-03, 195.262145875635014e-03, 97.631072937817507e-03, 1.000000000000000e+00, -942.809041582063173e-03, 333.333333333333258e-03};

    logic ap_start, ap_done, ap_idle, ap_ready;
    
    logic[2:0] start_count;
    logic[47:0] freq, phase;
    localparam real pi = 3.1415927;
    localparam logic[47:0] rate = (2.0**35) - 1.0;
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
    logic [17:0] x_real, x_imag;  
    assign x_imag = m_axis_data_tdata[41:24];
    assign x_real = m_axis_data_tdata[17: 0];

    // filters    
    logic dv_in, dv_out_real, dv_out_imag;
    logic[Ndint-1:-Ndfrac]  d_in_real, d_in_imag, d_out_real, d_out_imag;
    assign dv_in = m_axis_data_tvalid;
    assign d_in_real = {{(Ndint-1){x_real[17]}}, x_real, 5'b00000};
    assign d_in_imag = {{(Ndint-1){x_imag[17]}}, x_imag, 5'b00000};
    iir_sos #(.Ndint(Ndint), .Ndfrac(Ndfrac), .Ncint(Ncint), .Ncfrac(Ncfrac), .coeff(coeff)) uut_real (.clk(clk), .dv_in(dv_in), .d_in(d_in_real), .dv_out(dv_out_real), .d_out(d_out_real));
    iir_sos #(.Ndint(Ndint), .Ndfrac(Ndfrac), .Ncint(Ncint), .Ncfrac(Ncfrac), .coeff(coeff)) uut_imag (.clk(clk), .dv_in(dv_in), .d_in(d_in_imag), .dv_out(dv_out_imag), .d_out(d_out_imag));

    
    // round and saturate from 25 bits down to 18
    logic[17:0] dout_real, dout_imag, y_real, y_imag;
    round_n_sat #(.Win(Ndint+Ndfrac), .Nround(Ndfrac-17), .Nsat(Ndint-1)) real_sat_inst (.din(d_out_real), .dout(dout_real));
    round_n_sat #(.Win(Ndint+Ndfrac), .Nround(Ndfrac-17), .Nsat(Ndint-1)) imag_sat_inst (.din(d_out_imag), .dout(dout_imag));
    always_ff @(posedge clk) begin    
        y_real <= dout_real;
        y_imag <= dout_imag;                
    end

    // debug   
    logic ila_trigger;
    assign ila_trigger = freq[47]; 
    iir_ila iir_ila_inst (.clk(clk), .probe0({ila_trigger, dv_in, dv_out_real, dv_out_imag, x_real, x_imag, y_real, y_imag})); // 76

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
