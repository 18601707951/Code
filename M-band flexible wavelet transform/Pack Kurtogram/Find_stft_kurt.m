%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xf,Nw,fc] = Find_stft_kurt(x,nlevel,LNw,Fr,opt,Fs)
% [xf,Nw,fc] = Find_stft_kurt(x,nlevel,LNw,Fr,opt2)
% LNw = log2(Nw) with Nw the analysis window of the stft
% Fr is in [0 .5]
%
% -------------------
% J. Antoni : 12/2004
% -------------------

if nargin < 6
   Fs = 1;
end

Nfft = 2.^[3:nlevel+2];%ÿ��ֶ�����ֻ�������ֲ�					
temp = [3*Nfft(1)/2 3*Nfft(1:end-2);Nfft(2:end)];
Nfft = [Nfft(1) temp(:)'];%ÿ��ֶ������������ֲ�
LNw_stft = [0 log2(Nfft)];%ÿ��������꣬����δ�ֽ�ǰ�ź�			
[temp,I] = min(abs(LNw_stft-LNw));%�ҵ��˲��㼰��������
Nw = 2^LNw_stft(I);%�˲���ֶ���

NFFT = 2^nextpow2(Nw);%�˲���ĸ���Ҷ�任����
freq_stft = (0:NFFT/2-1)/NFFT;%����Ҷ�任���Ƶ�ʲ�����
[temp,J] = min(abs(freq_stft-Fr+1/NFFT/4));%������ӽ��ز�Ƶ�ʵ�Ƶ��λ��
fc = freq_stft(J);%�˲�������Ƶ��λ��

if LNw > 0
   b = hanning(Nw)';%�˲��㴰
   b = b/sum(b);%��һ��
   b = b.*exp(2i*pi*(0:Nw-1)*fc);%�˲���
   xf = fftfilt(b,x);%�˲�
   xf = xf(fix(Nw/2)+1:end);
   dt = fix(Nw/4);					% downsample by at least 4 samples per window (this corresponds to 75% overlap)
else
   xf = x;
   Nw = 0;
   dt = 1;
end

b = hanning(Nw)';%�˲��㴰
   b = b/sum(b);%��һ��
   b = b.*exp(2i*pi*(0:Nw-1)*fc);%�˲���
   xf = fftfilt(b,x);%�˲�
   xf = xf(fix(Nw/2)+1:end);
   dt = fix(Nw/4);


env = abs(xf(dt:dt:end)).^2;%�˲����źŰ���ƽ��

%temp = xf.*exp(-2i*pi*(0:length(xf)-1)'*fc);
%figure,subplot(211),plot(real(temp))
%subplot(212),plot(real(temp(dt:dt:end)))
kx = kurt(xf(dt:dt:end),opt);%�˲����ź��Ͷ�
sig = median(abs(xf(dt:dt:end)))/sqrt(pi/2);%medianȡ��ֵsqrt��ƽ����
threshold = sig*raylinv(.999,1);%��ֵ

spec = input('	Do you want to see the envelope spectrum (yes = 1 ; no = 0): ');
figure
t = (0:length(x)-1)/Fs;%ԭʼ�źŲ���ʱ���
tf = t(fix(Nw/2)+1:end);%�˲��źŲ�����
subplot(2+spec,1,1),plot(t,x,'k'),title('Original signal')%ԭʼ�ź�ʱ����ͼ
subplot(2+spec,1,2),plot(tf,real(xf),'k'),hold on,plot(tf,threshold*ones(size(xf)),':r'),plot(tf,-threshold*ones(size(xf)),':r'),%plot(abs(xf),'r'),
title(['Filtered signal, Nw=2^{',num2str(LNw_stft(I)),'}, fc=',num2str(Fs*fc),'Hz, Kurt=',num2str(fix(10*kx)/10),', \alpha=.1%'])
xlabel('time [s]')
if spec == 1
   nfft = 2^nextpow2(length(env));
   S = abs(fft((env(:)-mean(env)).*hanning(length(env)),nfft)/length(env));
   f = linspace(0,.5*Fs/dt,nfft/2);
   subplot(3,1,3),plot(f,S(1:nfft/2),'k'),title('Fourier transform magnitude of the squared filtered signal'),xlabel('frequency [Hz]')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%