clear;

d = load("-ascii", "../hls_proj/solution1/csim/build/lfm.dat");
s_in  = d(:,1) + j*d(:,2);
s_out = d(:,3) + j*d(:,4);

%plot(abs(s_in));

subplot(2,1,1);
plot(real(s_in), '.-r');
hold on;
plot(imag(s_in), '.-b');
subplot(2,1,2);
plot(real(s_out), '.-r');
hold on;
plot(imag(s_out), '.-b');

