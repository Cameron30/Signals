%Variables
Tp=5e-7;
B=1e9;
w=1;
n=1;
min=1000;
max=1100;
R=1100;
 
%speed of light
c=299792458;
 
%20 GSPS rate
t=0:(1/(20e9)):Tp;
 
%Sinusoid amplitude
A=(sqrt(2*w));
 
%Chirp rate
y=(B/Tp);
 
%Intermediate-frequency waveform according to (1)
at = rectangularPulse(A*(t-.5*Tp)/Tp);
 
%Starting Frequency
xif = at.*cos(2*pi*(1e9-.5*B).*t+pi*y.*t.^2);
 
%correctly scaled frequency values
fx=0:2e6:2e10;
 
figure(1);
plot(t,xif);
title("Starting Signal");
xlabel("Time");
ylabel("Amplitude");
 
figure(2);
plot(fx,abs(fft(xif)));
title("Frequency Domain of Starting Signal");
xlabel("Frequency");
ylabel("Amplitude");
 
%7 GHz signal to upscale 
scaler=at.*cos(2*pi*7e9.*t);
 
%multiplication of the signals
combo=xif.*scaler;
 
%interpolation stops duplicates casued by aliasing (this has no effect on the signal).
fftCombo=interp1(fx,fft(combo),0:2e6:1e10);
 
%new frequency values
fx=0:2e6:1e10;
 
%plot of our fft combination signal showing 6 and 8 GHz
figure(3)
plot(fx, abs(fftCombo));
title("Frequency Domain of Combination Signal");
xlabel("Frequency");
ylabel("Amplitude");
 
%Creation of the impulse;
%rect in frequency = sinc in time
fftsinc = rectangularPulse(1*((0:5000)-4000)/1000);
 
%bpf function
bpf = ifft(fftsinc);
 
%Convolution of bpf and 8Ghz signal is mult. in fourier
con=ifft(fftsinc.*fftCombo);
 
 
figure(4)
plot(fx,abs(fft(con)));
title("Frequency Domain of Bandpassed Signal");
xlabel("Frequency");
ylabel("Amplitude");
 
con=[con zeros([1 5000])];
 
%Td is the uncorrected delay through bandpass filter
Td = 4e-7;
 
%New time array
tnew = (2*min/c:1/20e9:(2*max/c+Tp+Td));
 
tau = 2*R/c;
 
%signal after delay of tau
received=interp1(t+tau,con,tnew,'nearest',0);
 
%Received waveform that bounced back from 1000m
figure(5)
plot(tnew,real(received));
title("Received signal in Time Domain");
xlabel("time");
ylabel("Amplitude");
 
%cos and sin signals at 8GHz
sine=sin(2*pi*8e9.*tnew);
cosine=cos(2*pi*8e9.*tnew);
 
%multiplication by cosine
receivedReal=real(received.*cosine);
 
%low pass filter (cos)
receivedReal=ifft(fft(receivedReal).*rectangularPulse(1*((0:31342))/20000));
receivedReal=real(receivedReal);
 
%multiplication by sine
receivedImag=real(received.*sine);
 
%low pass filter (sin)
receivedImag=ifft(fft(receivedImag).*rectangularPulse(1*((0:31342))/19548));
receivedImag=real(receivedImag);
 
%New frequency x-axis
fx=(0:31342)*1.6e5;
 
%plot(abs(fft(receivedImag)))
figure(6)
plot(fx,abs(fft(receivedReal)));
title("Frequency after multiplication by sine or cosine");
xlabel("Frequency");
ylabel("Amplitude");
 
%Final combination of the cosine and sine
receivedFinal=receivedReal+1j*receivedImag;
 
figure(7)
plot(fx,abs(fft(receivedFinal)));
title("Frequency of Combination of Sine and Cosine");
xlabel("Frequency");
ylabel("Amplitude");
 
%Noise generating function
Pn=.5;
noise=sqrt(Pn/2)*(randn(length(receivedFinal),1)+1j*randn(length(receivedFinal),1));
noise=transpose(noise);
 
%adding noise after fixing the amplitude
receivedFinal=receivedFinal*10*A;
receivedFinal=noise+receivedFinal;
 
figure(8)
plot(tnew,real(receivedFinal));
title("Downconverted signal after Noise");
xlabel("Time");
ylabel("Amplitude");
 
figure(9)
plot(fx,abs(fft(receivedFinal)));
title("Downconverted signal after Noise");
xlabel("Frequency");
ylabel("Amplitude");
 
xbar = A*exp(1j*2*pi*(.5*B).*-t+1j.*-t.^2*pi*y);
matchedFilter = conj(xbar);
matchedCon=conv(receivedFinal,matchedFilter);
 
 
tnewer=0:1/20e9:1.75465e-6;
matchedCon=[matchedCon zeros(1)];

figure(10)
plot(tnewer,real(matchedCon));
title("Signal after Matching Filter");
xlabel("Time");
ylabel("Amplitude");

figure(11)
plot(fx,abs(fftl(matchedCon)));
title("Signal after Matching Filter");
xlabel("Frequency");
ylabel("Amplitude");
