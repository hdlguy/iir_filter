clear; 
N=8; 
Wc=0.25; %0.02; 

coeff_int = 2;
coeff_frac = 12;
coeff_width = coeff_int + coeff_frac;

%  iir filter

%[b, a] = butter(N,Wc); 
%[b, a] = besself(N,Wc); 
Rp = 5; Rs = 5; [b, a] = ellip (N, Rp, Rs, Wc);

%freqz(b,a,4096);

% convert filter to second order sections
[sos, g] = tf2sos(b,a);
sos(:,1:3) = sos(:,1:3) * (g^(1/4)); % scale the b coefficients by g.

%sec = 4; zplane(sos(sec,1:3), sos(sec,4:6)); 


% quantize coefficients
sos_q = round(sos*(2^coeff_frac));
sos_q_scaled = sos_q/(2^coeff_frac);
max_q_coeff_int = floor(max(max(abs(sos_q_scaled))));
if (max_q_coeff_int > (2^(coeff_int-2))) printf("ERROR: not enough integer bits.\n"); endif;

% look at the quantized filter
[b_q, a_q] = sos2tf(sos_q_scaled);
%zplane(b_q, a_q);
%freqz(b_q, a_q);

% simulate the filter.

% print out the coefficients in C++ table. 
printf("    const int Nsos = %d; // number of second order sections.\n", N/2);
printf("    static data_type sig_array[Nsoc];\n");
printf("    const coeff_type coeff_array[Nsoc][6] = {\n");
for i=1:N/2
    printf("        { ");
    for j=1:6
        printf("%+3.10f", sos_q_scaled(i,j));
        if (j==6) printf(" "); else printf(", "); endif
    endfor
    if (i==N/2) printf("}\n"); else printf("},\n"); endif
endfor
printf("    };\n");


