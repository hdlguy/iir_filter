clear; 
Nsos = 3; % number of second order sections
Wc_hp = 1/256; 
Wc_lp = 1/30;

coeff_int = 4;
coeff_width = 18;
coeff_frac = coeff_width-coeff_int;

%  iir filter

%[b, a] = butter(Nsos*2, Wc_hp, "high"); 
[b, a] = butter(Nsos*2, Wc_lp, "low"); 

% convert filter to second order sections
[sos, g] = tf2sos(b,a);
sos(:,1:3) = sos(:,1:3) * (g^(1/Nsos)); % scale just the b coefficients(1:3) by g.

% quantize coefficients
sos_q = round(sos*(2^coeff_frac));
sos_q_scaled = sos_q/(2^coeff_frac);

% check that we have enough integer bits for the coefficients
max_q_coeff_int = floor(max(max(abs(sos_q_scaled))));
if (max_q_coeff_int > (2^(coeff_int-2))) printf("ERROR: not enough integer bits.\n"); endif;

% look at the quantized filter coefficients
[b_q, a_q] = sos2tf(sos_q_scaled);
%zplane(b_q, a_q);

% simulate the filter.
Nsim = 1024;
s=zeros(1,Nsim); s(5) = 1; % impulse

% direct implementation
s_filt = filter(b,a,s);

% low level second order sections
s_filt3 = s;
for i=1:Nsos
    Xk0=0; Xk1=0; Xk2=0; Yk0=0; Yk1=0; Yk2=0;
    b0 = sos_q_scaled(i,1);
    b1 = sos_q_scaled(i,2);
    b2 = sos_q_scaled(i,3);
    a1 = sos_q_scaled(i,5);
    a2 = sos_q_scaled(i,6);
    for k=1:Nsim
        Xk0 = s_filt3(k);    
        Yk0 = b0*Xk0 + b1*Xk1 + b2*Xk2 - a1*Yk1 - a2*Yk2; % note - sign on a1, a2.
        Xk2=Xk1; Xk1=Xk0; Yk2=Yk1; Yk1=Yk0; 
        s_filt3(k) = Yk0;
    endfor
endfor

plot(s_filt, '*r-'); hold on; plot(s_filt3, 'ob-'); hold off;


% print out the coefficients in C++ table. 
printf("const int CoeffWordSize = %d;\n", coeff_width);
printf("const int CoeffIntSize = %d;\n", coeff_int);
printf("typedef ap_fixed<CoeffWordSize, CoeffIntSize, AP_RND, AP_SAT, 0> coeff_type;\n");
printf("const int Nsos = %d; // number of second order sections.\n", Nsos);
printf("const coeff_type coeff_array[Nsos][6] = {\n");
for i=1:Nsos
    printf("    { ");
    for j=1:6
        printf("%+3.12f", sos_q_scaled(i,j));
        if (j==6) printf(" "); else printf(", "); endif
    endfor
    if (i==Nsos) printf("}\n"); else printf("},\n"); endif
endfor
printf("};\n\n");


% print out the coeficients in Systemverilog table.
printf("\n");
printf("    localparam int  Ncint  = %d;\n", coeff_int);
printf("    localparam int  Ncfrac = %d;\n", coeff_width-coeff_int);
printf("    localparam int  Nsos = %d;\n", Nsos);
printf("    localparam real coeff[0:Nsos-1][0:5] =  {\n");
for i=1:Nsos
    printf("        '{ ");
    for j=1:6
        printf("%+3.12f", sos_q_scaled(i,j));
        if (j==6) printf(" "); else printf(", "); endif
    endfor
    if (i==Nsos) printf("}\n"); else printf("},\n"); endif
endfor
printf("    };\n\n");










