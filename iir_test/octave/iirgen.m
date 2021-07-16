clear; 
N=8; 
Wc=0.25; 
Rp = 5;
Rs = 5;

%[b, a] = butter(N,Wc); 
%[b, a] = besself(N,Wc); 
[b, a] = ellip (N, Rp, Rs, Wc);

freqz(b,a);

[sos, g] = tf2sos(b,a);

%zplane(b, a);
%sec = 4; zplane(sos(sec,1:3), sos(sec,4:6)); 
