%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function c = K_wpQ_filt(x,h,g,h1,h2,h3,acoeff,bcoeff,level)
% c = K_wpQ_filt(x,h,g,h1,h2,h3,acoeff,bcoeff,level)
% Calculates the kurtosis K of the complete quinte wavelet packet transform
% w of signal x, �������С�����ֽ���Ͷ�
% up to nlevel, using the lowpass and highpass filters h and g,
% respectively. ֱ�����һ�㣬�ֱ��õ�ͨ���ͨ�˲���
% The WP coefficients are sorted according to the frequency
% decomposition.С����ϵ������Ƶ�ʷֽ����
% This version handles both real and analytical filters, but does not yiels WP coefficients
% suitable for signal synthesis.����Ǳ�����ʵ�ź�������ź��˲������������ںϳ��źŵ�С����ϵ��
%
% -----------------------
% J�r�me Antoni : 12/2004 
% -----------------------   

nlevel = length(acoeff);
L = floor(log2(length(x)));
if nargin == 8
   if nlevel >= L
      error('nlevel must be smaller !!');
   end
   level = nlevel;
end
x = x(:);										 % shapes the signal as column vector if necessary

if nlevel == 0
   if isempty(bcoeff)
      c = x;
   else
      [c1,c2,c3] = TBFB(x,h1,h2,h3);
      if bcoeff == 0;
         c = c1(length(h1):end);
      elseif bcoeff == 1;
         c = c2(length(h2):end);
      elseif bcoeff == 2;
         c = c3(length(h3):end);
      end
   end
else
   c = K_wpQ_filt_local(x,h,g,h1,h2,h3,acoeff,bcoeff,level);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
