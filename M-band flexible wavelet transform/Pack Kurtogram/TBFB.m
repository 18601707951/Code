function [a1,a2,a3] = TBFB(x,h1,h2,h3)
% Trible-band filter-bank.�����˲�����
%   [a1,a2,a3] = TBFB(x,h1,h2,h3) 

N = length(x);
La1 = length(h1);
La2 = length(h2);
La3 = length(h3);

% lowpass filter
a1 = filter(h1,1,x);%��ͨ�˲�
a1 = a1(3:3:N);%������
a1 = a1(:);

% passband filter
a2 = filter(h2,1,x);%��ͨ�˲�
a2 = a2(3:3:N);%������
a2 = a2(:);

% highpass filter
a3 = filter(h3,1,x);%��ͨ�˲�
a3 = a3(3:3:N);%������
a3 = a3(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%