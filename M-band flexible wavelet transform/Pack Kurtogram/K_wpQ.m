function K = K_wpQ(x,h,g,h1,h2,h3,nlevel,opt,level)
% K = K_wpQ(x,h,g,h1,h2,h3,nlevel)
% Calculates the kurtosis K of the complete quinte wavelet packet transform
% w of signal x, �����ź�x�����С�����任�Ͷ�
% up to nlevel, using the lowpass and highpass filters h and g, respectively.���ϵ���Ͳ�ֱ��õ�ͨ��ͨ�˲��� 
% The WP coefficients are sorted according to the frequency
% decomposition.ϵ������Ƶ�ʷֽ����
% This version handles both real and analytical filters, but does not yiels WP coefficients
% suitable for signal synthesis.�˽Ǳ�������ʵ�źż������źŵ��˲����������ںϳ��ź�
%
% -----------------------
% J�r�me Antoni : 12/2004 
% -----------------------   

L = floor(log2(length(x)));
if nargin == 8
   if nlevel >= L%�жϷֽ���Ƿ񳬳���������
      error('nlevel must be smaller !!');
   end
   level = nlevel;
end
x = x(:);										 % shapes the signal as column vector if necessary

[KD,KQ] = K_wpQ_local(x,h,g,h1,h2,h3,nlevel,opt,level);%����ÿ���Ͷȣ���ʼ�ź�����ֲ��Ͷȴ洢��KD�����ֲ��Ͷȴ洢��KQ��

K = zeros(2*nlevel,3*2^nlevel);%�趨�Ͷȵ�����������Ͳ��ÿһ�������й��ɣ�����Ϊ�ֽ�����Ķ���
K(1,:) = KD(1,:);%δ�ֽ�ǰ���Ͷ�
for i = 1:nlevel-1
   K(2*i,:) = KD(i+1,:);%���ֶβ���Ͷ�
   K(2*i+1,:) = KQ(i,:);%���ֶβ���Ͷ�
end
K(2*nlevel,:) = KD(nlevel+1,:);%���һ����Ͷȣ�����)
