function c = Fast_Kurtogram(x,nlevel,Fs,opt1,opt2)
% Fast_Kurtogram(x,nlevel,Fs)
% Computes the fast kurtogram of signal x up to level 'nlevel'
% Maximum number of decomposition levels is log2(length(x)), but it is 
% recommended to stay by a factor 1/8 below this.
% Fs = sampling frequency of signal x (default is Fs = 1)
% opt1 = 1: the kurtogram is computed via a fast decimated filterbank tree
% opt1 = 2: the kurtogram is computed via the short-time Fourier transform
% (if there is any difference in the kurtogram between the two measures, this is
% due to the presence of impulsive additive noise)
% opt2 = 1: classical kurtosis based on 4th order statistics 
% opt2 = 2: robust kurtosis based on 2nd order statistics of the envelope
% (option 1 is faster and has more flexibility than option 2 in the design of the
% analysis filter: a short filter in option 1 gives virtually the same results as option 2)
%
% -------------------
% J. Antoni : 02/2005
% -------------------

N = length(x);
N2 = log2(N) - 7;%�������ֽ��
if nlevel > N2%�ж�����ֽ���Ƿ�����������ֽ��
   error('Please enter a smaller number of decomposition levels');
end

if nargin < 5%�ж��������
   opt2 = input('Choose the kurtosis measure (classic = 1 ; robust = 2): ');
   if nargin < 4
      opt1  = input('Choose the algorithm (filterbank = 1 ; stft-based = 2): ');
      if nargin < 3
         Fs = 1;
      end
   end
 end

% Fast computation of the kurtogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if opt1 == 1
   % 1) Filterbank-based kurtogram
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Analytic generating filters
   N = 16;			fc = .4;					% a short filter is just good enough!
   h = fir1(N,fc).*exp(2i*pi*(0:N)*.125);%���ֶε�ͨ�˲���
   n = 2:N+1;
   g = h(1+mod(1-n,N)).*(-1).^(1-n);%���ֶθ�ͨ�˲���
   % 
   N = fix(3/2*N);
   h1 = fir1(N,2/3*fc).*exp(2i*pi*(0:N)*.25/3);%���ֶε�һ���˲���
   h2 = h1.*exp(2i*pi*(0:N)/6);%���ֶεڶ����˲���
   h3 = h1.*exp(2i*pi*(0:N)/3);%���ֶε������˲���  
   % 
   if opt2 == 1
      Kwav = K_wpQ(x,h,g,h1,h2,h3,nlevel,'kurt2');				% kurtosis of the complex envelope
   else
      Kwav = K_wpQ(x,h,g,h1,h2,h3,nlevel,'kurt1');				% variance of the envelope magnitude
   end
   Kwav = Kwav.*(Kwav>0);												% keep positive values only!
   
else 
   % 2) STFT-based kurtogram
   %%%%%%%%%%%%%%%%%%%%%%%%%
   Nfft = 2.^[3:nlevel+2];				% level 1 of wav_kurt roughly corresponds to a 4-sample hanning window with stft_kurt
   %											  or a 8-sample flattop	��һ���8��	
   temp = [3*Nfft(1)/2 3*Nfft(1:end-2);Nfft(2:end)];%��һ��Ϊ���ֲ�������ڶ���Ϊ���ֲ����
   Nfft = [Nfft(1) temp(:)'];%�þ�����������ѭ����ֵ�ķ��������зֲ����
   if opt2 == 1
      Kstft = Kf_fft(x,Nfft,1,'kurt2');							% kurtosis of the complex envelope
      Kx = kurt(x,'kurt2');%δ�ֲ�ǰ���ź��Ͷ�
   else
      Kstft = Kf_fft(x,Nfft,1,'kurt1');							% variance of the envelope magnitude
      Kx = kurt(x,'kurt1');
   end
   Kstft = [Kx*ones(1,size(Kstft,2));Kstft];%�����ͶȻ���
   Kstft = Kstft.*(Kstft>0);%ֻȡ�Ͷȴ�����Ĳ��֣��Ͷ�С����Ĳ�����Ϊ��		% keep positive values only!
   
end

% Graphical results
%%%%%%%%%%%%%%%%%%%
figure
if opt1 == 1%�ֲ����˲����
   Level_w = 1:nlevel;	Level_w = [Level_w;Level_w+log2(3)-1];	Level_w = Level_w(:); Level_w = [0 Level_w(1:2*nlevel-1)'];%ͼ��������
   freq_w = Fs*((0:3*2^nlevel-1)/(3*2^(nlevel+1)) + 1/(3*2^(2+nlevel)));%ͼ�κ�����Fs/2*((0:3*2^nlevel)+0.5)/(3*2^nlevel)
   imagesc(freq_w,1:2*nlevel,Kwav),colorbar,[I,J,M] = max_IJ(Kwav);%��ͼ�������ֵ
   xlabel('frequency [Hz]'),set(gca,'ytick',1:2*nlevel,'yticklabel',round(Level_w*10)/10),ylabel('level k')%��ע����
   fi = (J-1)/3/2^(nlevel+1);   fi = fi + 2^(-2-Level_w(I));%����Ƶ��
   if opt2 == 1
      title(['fb-kurt.2 - K_{max}=',num2str(round(10*M)/10),' @ level ',num2str(fix(10*Level_w(I))/10),', Bw= ',num2str(Fs*2^-(Level_w(I)+1)),'Hz, f_c=',num2str(Fs*fi),'Hz'])
   else
      title(['fb-kurt.1 - K_{max}=',num2str(round(10*M)/10),' @ level ',num2str(fix(10*Level_w(I))/10),', Bw= ',num2str(Fs*2^-(Level_w(I)+1)),'Hz, f_c=',num2str(Fs*fi),'Hz'])
   end
else%��ʱ����Ҷ�任���
   LNw_stft = [0 log2(Nfft)];%������			
   freq_stft = Fs*((0:Nfft(end)/2-1)/Nfft(end) + 1/Nfft(end)/2);%������
   %freq_stft = Fs*(0:Nfft(end)/2-1)/Nfft(end);
   imagesc(freq_stft,1:2*nlevel,Kstft),colorbar,[I,J,M] = max_IJ(Kstft);	
   fi = (J-1)/Nfft(end);	
   xlabel('frequency [Hz]'),set(gca,'ytick',1:2*nlevel,'yticklabel',round(LNw_stft*10)/10),ylabel('level: log2(Nw)')
   if opt2 == 1
      title(['stft-kurt.2 - K_{max}=',num2str(round(10*M)/10),' @ Nw=2^{',num2str(fix(10*LNw_stft(I))/10),'}, fc=',num2str(Fs*fi),'Hz'])
   else
      title(['stft-kurt.1 - K_{max}=',num2str(round(10*M)/10),' @ Nw=2^{',num2str(fix(10*LNw_stft(I))/10),'}, fc=',num2str(Fs*fi),'Hz'])
   end
end

% Signal filtering
%%%%%%%%%%%%%%%%%%
c = [];
test = input('Do you want to filter out transient signals from the kurtogram (yes = 1 ; no = 0): ');
while test == 1
   fi = input(['	Enter the optimal carrier frequency (btw 0 and ',num2str(Fs/2),') where to filter the signal: ']);
   fi = fi/Fs;
   if opt1 == 1
      lev = input(['	Enter the optimal level (btw 0 and ',num2str(nlevel),') where to filter the signal: ']);
      if opt2 == 1
         [c,Bw,fc] = Find_wav_kurt(x,h,g,h1,h2,h3,nlevel,lev,fi,'kurt2',Fs);
      else
         [c,Bw,fc] = Find_wav_kurt(x,h,g,h1,h2,h3,nlevel,lev,fi,'kurt1',Fs);
      end
   else
      lev = input(['	Enter the optimal level (btw 0 and ',num2str(nlevel+2),') where to filter the signal: ']);
      if opt2 == 1
         [c,Nw,fc] = Find_stft_kurt(x,nlevel,lev,fi,'kurt2',Fs);
      else
         [c,Nw,fc] = Find_stft_kurt(x,nlevel,lev,fi,'kurt1',Fs);
      end
   end
   test = input('Do you want to keep on filtering out transients (yes = 1 ; no = 0): ');%ѡ���Ƿ��˳�ѭ��
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%