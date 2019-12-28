function [a,d] = DBFB(x,h,g)%��ͨ�˲������������źŴ洢��a�У���ͨ�˲������������źŴ洢��d��
% Double-band filter-bank.�����˲�����
%   [a,d] = DBFB(x,h,g) computes the approximation
%   coefficients vector a and detail coefficients vector d,�����Լϵ��a��ϸ��ϵ��d
%   obtained by passing signal x though a two-band analysis
%   filter-bank.ͨ���źŵĶ��ִ�ͨ�˲����õ�
%   h is the decomposition low-pass filter and��ͨ�˲���
%   g is the decomposition high-pass filter.�����˲���

N = length(x);
La = length(h);
Ld = length(g);

% lowpass filter
a = filter(h,1,x);%��ͨ�˲�
a = a(2:2:N);%������
a = a(:);

% highpass filter
d = filter(g,1,x);%��ͨ�˲�
d = d(2:2:N);%������
d = d(:);%������

% ------------------------------------------------------------------------