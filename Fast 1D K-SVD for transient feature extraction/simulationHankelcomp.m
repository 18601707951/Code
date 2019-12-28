% =========================================================================
%                          Written by Yi Qin
% =========================================================================
tic;
clc;
clear;
close all;


%% ��������

%�źų�ʼ����
fs = 2000;             %����Ƶ��
N = 2000;              %��������
T = 1/fs;               %����ʱ��
t = (0:N-1)*T;          %ʱ������
%����ӦOMP����
a=2;                    %���걸�ֵ����
c=5;                    %����Ӧϡ����о�
%Hankel����ֶβ���
l=500;                     %ÿ���źų���
m=100;                      %Hankel��������
n=401;                      %Hankel��������
%K-SVD�������(����K-SVD����)
param.K=300;                %ԭ�Ӹ���
param.numIteration = 10;    %��������
param.errorFlag = 1;        
param.errorGoal =0.3;       %errorGoal�ɵ�
param.preserveDCAtom =0;
param.displayProgress = 1;
param.InitializationMethod ='DataElements';

%% ���ɷ����ź�
s=simulation_signal(N,t);

%% ����OMPȥ��г���͵��Ʒ���  
D1=FourierDict(N,a);    %���帵��Ҷ�ֵ�
s1 = adapomp(D1,s,c);   %����ӦOMP
plot1(t,s1,21,1);         %����ȥ��г���͵��Ʒ�����ʱ��ͼ  

%% Hankel����ֶ�
S = Hankel_matrix(s1,l,m,n,N);

%% K-SVD����
for i=1:N/l
    [D{i},output]=KSVD(S(:,:,i),param);
    A2{i} = output.CoefMatrix;          %����CoefMatrix��ϡ��������Բ��ܹ���Nά����
    X2 = D{i} * A2{i};                  %outputCoefMatrix��Ҫ��������Ա�����ֵ����
    x2((i-1)*l+1:i*l) = ReHankel(X2);   %�ָ��ź�
end

%% ��ͼ
plot2(t,x2,fs,22,300,1);              
toc;