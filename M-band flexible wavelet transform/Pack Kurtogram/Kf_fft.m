function K = Kf_fft(x,Nfft,foverlap,opt)%ͨ����ʱ����Ҷ�任������ÿ��ÿ���Ͷ�

if rem(log2(Nfft),1)~=0%�������������������ʲô����
   error('Nfft should contain powers of two only !!')
end
if rem(foverlap,1)~=0 | foverlap ==0%���Ƶ�ʱ����Ƿ���������
   error('foverlap must be a non-zero integer !!')
end

N = length(Nfft);%�ֲܷ���
L = Nfft(N)*foverlap;%���һ�㳤��
K = zeros(N,L/2);%��ʼ���ͶȾ���

for i = 1:N
   Window = hanning(Nfft(i));		% bandwidth(3dB) ~ .6/N (small N) --> .7/N (large N)ÿһ��ĺ���������Ϊ�ò����ֶ���
   Nw = Nfft(i);%ÿ�㴰��
   Noverlap = fix(3*Nw/4); %ÿ�㴰�ص�����
   NFFT = 2^nextpow2(Nfft(i)*foverlap);%ÿ�㸵��Ҷ�任����
   temp = Kf_W(x,NFFT,Noverlap,Window,opt);%�Ӵ�����Ҷ�任���㵱ǰ���Ͷ�
   temp = temp(1:NFFT/2);%��ʱ��tempΪһ������
   temp = repmat(temp',L/2/length(temp),1);%
   K(i,:) = reshape(temp,L/2,1)';%��temp�е������һ�У���i����Ͷ�
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%