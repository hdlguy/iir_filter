module top(
    input clk_in
);

    logic clk;
    assign clk = clk_in;

    // coefficient specification
    localparam int  Ncint  = 4;
    localparam int  Ncfrac = 14;
    localparam int  Nsos = 6;
    localparam real coeff[0:Nsos-1][0:5] =  {
        '{ +0.992126464844, -1.980163574219, +0.988037109375, +1.000000000000, -1.976501464844, +0.976684570312 },
        '{ +0.992126464844, -1.988342285156, +0.996215820312, +1.000000000000, -1.982543945312, +0.982666015625 },
        '{ +0.992126464844, -1.984252929688, +0.992126464844, +1.000000000000, -1.993530273438, +0.993713378906 },
        '{ +0.002563476562, +0.005126953125, +0.002563476562, +1.000000000000, -1.806640625000, +0.816589355469 },
        '{ +0.002563476562, +0.005126953125, +0.002563476562, +1.000000000000, -1.852172851562, +0.862365722656 },
        '{ +0.002563476562, +0.005126953125, +0.002563476562, +1.000000000000, -1.936645507812, +0.947326660156 }        
    };

    logic ap_start;
    
    logic[2:0] start_count=6;
    logic[47:0] freq=48'hff00_0000_0000, phase=0;
    localparam real pi = 3.1415927;
    localparam logic[47:0] rate = (2.0**28) - 1.0;
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
    iir_ila iir_ila_inst (.clk(clk), .probe0({freq[47:40], dv_in, dv_out_real, dv_out_imag, x_real, x_imag, y_real, y_imag})); // 83

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

*/    
