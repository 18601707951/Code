function [Kf,M4,M2,k] = Kf_W(x,Nfft,Noverlap,Window,opt)
% [Kf,M4,M2] = Kf_W(x,Nfft,Noverlap,Window) 
% Welch's estimate of :       
%       1) the freq.-conditionned Kurtosis :  Kf(f) = M4(f)/M2(f)^2 - 2 
%       2) the 4th-order moment spectrum :   M4(f) = E{|X(f)|^4}
%       3) the 2nd-order moment spectrum :   M2(f) = E{|X(f)|^2}
%
% Caution : this version applies to stationary signals only !!�˽Ǳ�ֻ������ƽ���ź�
%
% x and y are divided into overlapping sections (Noverlap taps), each of which is
% detrended, windowed and zero-padded to length Nfft. 
% Note : use analytic signal to avoid correlation between + and -
% frequencies�����źű���������Ƶ�ʵĹ�ϵ
% -----
%
% --------------------------
% Author: J. Antoni, 11-2003
% --------------------------

Window = Window(:)/norm(Window);		% Window Normalization��һ����
n = length(x);								% Number of data points
nwind = length(Window); 				% length of window
if nwind<=Noverlap,
   error('nwind must be > Noverlap');%������������ص�����
end
x = x(:);		
k = fix((n-Noverlap)/(nwind-Noverlap));	% Number of windowsÿ��ֶ���

% 1) Moment-based spectrum
% -------------------------
index = 1:nwind;
f = (0:Nfft-1)/Nfft;
t = (0:n-1)';
M4 = 0;
M2 = 0;

for i=1:k
   xw = Window.*x(index);%���������봰���
   Xw = fft(xw,Nfft);%���εĸ���Ҷ�任	
   if strcmp(opt,'kurt2')
      M4 = abs(Xw).^4 + M4;%�����Ĵ�ͳ�����ۼ�   
      M2 = abs(Xw).^2 + M2;%���ζ���ͳ�����ۼ�
   else
      M4 = abs(Xw).^2 + M4;   
      M2 = abs(Xw) + M2;
   end
   index = index + (nwind - Noverlap);%��һ�������ݵ��±�
end

% normalize
M4 = M4/k;%�Ĵ�ͳ����ƽ��   
M2 = M2/k;%����ͳ�����ۼ� 
Kf = M4./M2.^2;%����ֶ��Ͷ�����

if strcmp(opt,'kurt2')
   Kf = Kf - 2;
   b = 1;
else
   Kf = Kf - 1.27;
   b = .3;
end

% reduce biais near f = 0 mod(1/2)
W = abs(fft(Window.^2,Nfft)).^2;
Wb = zeros(Nfft,1);
for i = 0:Nfft-1,
   Wb(1+i) = W(1+mod(2*i,Nfft))/W(1);%�±�Ϊ�����ĳ���W��1��
end;
Kf = Kf - b*Wb;
