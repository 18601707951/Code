function [c,Bw,fc,i] = Find_wav_kurt(x,h,g,h1,h2,h3,nlevel,Sc,Fr,opt,Fs)
% [c,Bw,fc,i] = Find_wav_kurt(x,h,g,h1,h2,h3,nlevel,Sc,Fr,opt2)
% Sc = -log2(Bw)-1 with Bw the bandwidth of the filter
% Fr is in [0 .5]
%
% -------------------
% J. Antoni : 12/2004
% -------------------

if nargin < 11
   Fs = 1;
end

level = fix(Sc) + (rem(Sc,1)>=0.5)*(log2(3)-1);%�����˲������ڲ�
Bw = 2^(-level-1);%�˲�������
freq_w = (0:2^level-1)/(2^(level+1))+Bw/2;%�˲���ÿ������Ƶ��
[temp,J] = min(abs(freq_w-Fr));%��������ز�Ƶ�����������Ƶ��
fc = freq_w(J);%����Ƶ��λ��
i = round((fc/Bw-1/2));%�˲����ڲ㣨�Ͷ�ͼ�����ܲ㣩

if rem(level,1) == 0%���ֲ�
   acoeff = binary(i,level);%
   bcoeff = [];
   temp_level = level;
else%���ֲ�
   i2 = fix(i/3);
   temp_level = fix(level)-1;
   acoeff = binary(i2,temp_level);
   bcoeff = i-i2*3;
end
acoeff = acoeff(end:-1:1);

c = K_wpQ_filt(x,h,g,h1,h2,h3,acoeff,bcoeff,temp_level);

kx = kurt(c,opt);
sig = median(abs(c))/sqrt(pi/2);
threshold = sig*raylinv(.999,1);

spec = input('	Do you want to see the envelope spectrum (yes = 1 ; no = 0): ');
figure
t = (0:length(x)-1)/Fs;
tc = linspace(t(1),t(end),length(c));
subplot(2+spec,1,1),plot(t,x,'k'),title('Original signal')
%subplot(2+spec,1,2),plot(tc,real(c),'k'),hold on,plot(tc,threshold*ones(size(c)),':r'),plot(tc,-threshold*ones(size(c)),':r')
%title(['Complx envlp of the filtr sgl (real part), Bw=Fs/2^{',num2str(level+1),'}, fc=',num2str(Fs*fc),'Hz, Kurt=',num2str(fix(10*kx)/10),', \alpha=.1%'])
subplot(2+spec,1,2),plot(tc,abs(c),'k'),hold on,plot(tc,threshold*ones(size(c)),':r')
title(['Envlp of the filtr sgl, Bw=Fs/2^{',num2str(level+1),'}, fc=',num2str(Fs*fc),'Hz, Kurt=',num2str(fix(10*kx)/10),', \alpha=.1%'])
xlabel('time [s]')
if spec == 1
   nfft = 2^nextpow2(length(c));
   env = abs(c).^2;
   S = abs(fft((env(:)-mean(env)).*hanning(length(env))/length(env),nfft));
   f = linspace(0,.5*Fs/2^level,nfft/2);
   subplot(313),plot(f,S(1:nfft/2),'k'),title('Fourier transform magnitude of the squared envelope'),xlabel('frequency [Hz]')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
