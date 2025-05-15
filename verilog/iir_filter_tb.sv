`timescale 1ns / 1ps

module iir_filter_tb ();

//    // coefficient specification
//    localparam int  Ncint  = 4;
//    localparam int  Ncfrac = 14;
//    localparam int  Nsos = 6;
//    localparam real coeff[0:Nsos-1][0:5] =  {
//        '{ +0.992126464844, -1.980163574219, +0.988037109375, +1.000000000000, -1.976501464844, +0.976684570312 },
//        '{ +0.992126464844, -1.988342285156, +0.996215820312, +1.000000000000, -1.982543945312, +0.982666015625 },
//        '{ +0.992126464844, -1.984252929688, +0.992126464844, +1.000000000000, -1.993530273438, +0.993713378906 },
//        '{ +0.002563476562, +0.005126953125, +0.002563476562, +1.000000000000, -1.806640625000, +0.816589355469 },
//        '{ +0.002563476562, +0.005126953125, +0.002563476562, +1.000000000000, -1.852172851562, +0.862365722656 },
//        '{ +0.002563476562, +0.005126953125, +0.002563476562, +1.000000000000, -1.936645507812, +0.947326660156 }        
//    };

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

    logic        dv_in;
    logic[17:0]  d_in;
    logic        dv_out;
    logic[17:0]  d_out;
    logic clk=0; localparam time clk_period = 10; always #(clk_period/2) clk=~clk;

    iir_filter #(.Ncint(Ncint), .Ncfrac(Ncfrac), .Nsos(Nsos), .coeff(coeff)) uut (.clk(clk), .dv_in(dv_in), .d_in(d_in), .dv_out(dv_out), .d_out(d_out));


    // impulse
    initial begin
    
        for (int i=0; i<500; i++) begin
            dv_in = 0;
            d_in = 0;
            #(clk_period*6);
            dv_in = 1;
            d_in = 0;
            #(clk_period*1);
        end 
                
        dv_in = 0;
        d_in = 0;
        #(clk_period*6);
        dv_in = 1;
        d_in = 100000;
        #(clk_period*1);
        
        forever begin
            dv_in = 0;
            d_in = 0;
            #(clk_period*6);
            dv_in = 1;
            d_in = 0;
            #(clk_period*1);
        end         
        
    end    
    
//    // linear FM chirp
//    real phase, freq, rate;
//    localparam real pi = 3.1419527;
//    localparam real chirprate = 2.0*pi/((2.0**22.0)-1.0);
//    initial begin
    
//        dv_in = 0;
//        d_in = 0;
//        phase = 0;
//        freq = -pi/64;
//        rate = chirprate;
//        #(clk_period*6);
        
//        forever begin
        
//            dv_in = 0;
//            #(clk_period*6);
//            dv_in = 1;
//            phase = phase + freq;
//            freq  = freq  + rate;
//            d_in = ((2.0**16.0)-1.0)*$sin(phase);
//            #(clk_period*1);            
            
//        end
        
//    end

endmodule

/*
*/
