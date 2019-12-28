
function wcoefs = myrmorletcwt(Sig,Scales,fc,fb,fws)
%============================================================%
%  Continuous Wavelet Transform using Morlet function                
%%%%%%%%%%%%%%%%%%%%%%%%����%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Sig: �����ź�                                          
%    Scales: ����ĳ߶����� 
%    fc: С������Ƶ��  ��Ĭ��Ϊ2�� 
%    fb: С���������   ��Ĭ��Ϊ2��
%    fws: С��������Ƶ��  ��Ĭ��Ϊ1�� 
%%%%%%%%%%%%%%%%%%%%%%%%���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    WT:  morletС���任������
%============================================================%
% =========================================================================
%                          Written by Yi Qin
% =========================================================================

if (nargin <= 1)
     error('At least 2 parameter required');
end;
if (nargin ==4)
     fws=1;
elseif (nargin==3) 
     fws=1;
     fb=2;
elseif (nargin==2) 
     fws=1;
     fb=2;  
     fc = 2;
end;

wavsupport=5;                           % Ĭ��morletС����֧����Ϊ[-8,8]
nLevel=length(Scales);                  % �߶ȵ���Ŀ
SigLen = length(Sig);                   % �źŵĳ���
%SigLen=120;
wcoefs = zeros(nLevel, SigLen);         % ����������Ĵ洢��Ԫ 

for m = 1:nLevel                        % ������߶��ϵ�С��ϵ��  
    a = Scales(m);                                   % ��ȡ�߶Ȳ���                              
    t = -round(a*wavsupport):1/fws:round(a*wavsupport);          % �ڳ߶�a����������С����֧�������Ϊ[-a*wavsup,a*wavsup]������Ƶ��Ϊ1Hz
    Morl = real(fliplr((pi*fb)^(-1/2)*exp(-i*2*pi*fc*t/a).*exp(-t.^2/(fb*a^2))));     % ���㵱ǰ�߶��µ�С������
    temp = conv(Sig,Morl) / sqrt(a);            % �����ź��뵱ǰ�߶���С�������ľ��   
    d=(length(temp)-SigLen)/2;                  % ���ھ���������ý���ĳ��ȿ���ԶԶ����ԭ�źţ�ֻ����ȡ��ԭ�źŵĳ��Ȼ�ȡ��ȡ�м䲿�ֵ�ϵ��
    first = floor(d)+1;                         % ��������
  %  first=floor(length(temp)/3);
    wcoefs(m,:)=temp(first:first+SigLen-1);   
  %  wcoefs(m,:)=temp(1:SigLen);   
end