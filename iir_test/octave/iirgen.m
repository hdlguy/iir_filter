clear; 
Nsos = 4; % number of second order sections
Wc=1/16; 

coeff_int = 2;
coeff_frac = 12;
coeff_width = coeff_int + coeff_frac;

%  iir filter

%[b, a] = butter(Nsos*2,Wc); 
%[b, a] = besself(Nsos*2,Wc); 
%Rp = 5; Rs = 20; [b, a] = ellip (Nsos*2, Rp, Rs, Wc);
Rp=5; [b, a]=cheby1(Nsos*2, Rp, Wc);

%freqz(b,a,4096);

% convert filter to second order sections
[sos, g] = tf2sos(b,a);
sos(:,1:3) = sos(:,1:3) * (g^(1/Nsos)); % scale the b coefficients by g.

%sec = 4; zplane(sos(sec,1:3), sos(sec,4:6)); 


% quantize coefficients
sos_q = round(sos*(2^coeff_frac));
sos_q_scaled = sos_q/(2^coeff_frac);
max_q_coeff_int = floor(max(max(abs(sos_q_scaled))));
if (max_q_coeff_int > (2^(coeff_int-2))) printf("ERROR: not enough integer bits.\n"); endif;

% look at the quantized filter coefficients
[b_q, a_q] = sos2tf(sos_q_scaled);
%zplane(b_q, a_q);
%freqz(b_q, a_q, 4096);

% simulate the filter.
Nsim = 1024;
s=zeros(1,Nsim); s(5) = 1; % impulse

% direct implementation
s_filt = filter(b_q,a_q,s);

% cascaded SOS
s_filt2 = s;
for i=1:Nsos
    b_sos = sos_q_scaled(i,1:3);
    a_sos = sos_q_scaled(i,4:6);
    s_filt2 = filter(b_sos, a_sos, s_filt2);
endfor

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
printf("    const int Nsos = %d; // number of second order sections.\n", Nsos);
printf("    const coeff_type coeff_array[Nsos][6] = {\n");
for i=1:Nsos
    printf("        { ");
    for j=1:6
        printf("%+3.10f", sos_q_scaled(i,j));
        if (j==6) printf(" "); else printf(", "); endif
    endfor
    if (i==Nsos) printf("}\n"); else printf("},\n"); endif
endfor
printf("    };\n");


