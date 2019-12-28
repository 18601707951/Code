
function D=WRSD(y,a0,n,fb,fc,fs,lf,num)
%%y-----original signal ԭʼ�ź�
%%a0-----initial scale ��ʼ�߶�
%%n----- extended length �ź����س���
%%lf----Low pass cutoff frequency of IF ˲ʱƵ�ʵ�ͨ�˲���ֹƵ��
%%%%fb,fc--------------------Parameters of Morlet wavelet MorletС��ʱ��������������Ƶ��
%%fs---sampling frequency ����Ƶ��
%%num---the  number of target components �ֽ��������
%%D-----decomposition result �ֽ���
% =========================================================================
%                          Written by Yi Qin
% =========================================================================

thr=0.005;
MAXITERATIONS=10;

for i=1:num
ey=symextend(y,n); %%�ź�����
[wra,as]=mywaveridge2(ey,fb,fc,thr,a0,MAXITERATIONS);
f1=fs./wra;
F=f1'/fs;
F=lpf(F,0.02);
[xi,Ai,phi]=synchdem(ey',2*pi*F,0.02);
x=deextend(xi,n);
y=y-x;
a0=a0*1.2;
D(i,:)=x;
end



function ex=symextend(x,n)
x=x(:);
N=length(x);
x1=fliplr(x(1:n));
x2=fliplr(x(N-n+1:N));
ex=[x1;x;x2];
ex=ex';

function x=deextend(ex,n)
ex=ex(:);
N=length(ex);
x=ex(n+1:N-n);
x=x';