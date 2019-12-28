function [s4,s6] = circshift_segment(s1,l,m,n,N)
%����ѭ��ƽ�ƽ��зֶ�;s1��ʾʣ���źţ�l��ʾÿ�γ��ȣ�m��ʾѭ��ƽ�ƶ�����N��ʾ�źų���
%l: the number of points inone period
%m: the number of circulating shifts
%n: the number of points in one circulating shift(it can be set as 1 or 2.) 
%N: data length 
% =========================================================================
%                          Written by Yi Qin
% =========================================================================
s1=s1(1:N);
s3=zeros(N,m);
for i=1:m
    s3(:,i)=circshift(s1,i*n);        %ѭ��ƽ��
end


s4=[];
for i=1:m
    s5=reshape(s3(:,i),l,N/l);      %�ֶκ����һ������
    s4=[s4,s5];
    s6(:,i)=sum(s5,2)/(N/l);
end