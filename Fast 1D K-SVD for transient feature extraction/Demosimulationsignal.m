% =========================================================================
%                          Written by Yi Qin
% =========================================================================
tic;
clc;
clear;
close all;


%% parameter setting��������

%Parameters of signal �źų�ʼ����
fs = 2000;             %����Ƶ��
N = 2000;              %��������
T = 1/fs;               %����ʱ��
t = (0:N-1)*T;          %ʱ������
%Parameters of adaptive OMP����ӦOMP����
a=2;                    %Parameter of overcomplete dictionary ���걸�ֵ����
c=5;                    %Parameter for stopping criterion ����Ӧϡ����о�
%Parameters of segmentation �ֶβ���
l=50;                  %the number of points inone period ÿ�εĳ��ȣ������ڷֶΣ�
m=10;                  %the number of circulating shifts ѭ��ƽ����Ҫ�Ķ���
n=1;                   %the number of points in one circulating shift(it can be set as 1 or 2.) ÿ��ƽ�Ƶ���
%Parameters of adaptive K-SVD ����ӦK-SVD����(����K-SVD����)
param.K=300;
param.numIteration = 10;
param.errorFlag = 1;
param.errorGoal =0.3;                      %KSVD�Ĳ������ص���errorGoal
param.preserveDCAtom =0;
param.displayProgress = 1;
param.InitializationMethod ='GivenMatrix';
k=290;                                      %the number of atoms ԭ�ź���ȡ����Ϊ��ʼ�ֵ��ԭ�Ӹ���

%% simulation signal�����ź�
s = simulation_signal(N,t);
ss=s;
plot1(t,s,1,1);         %����ԭ�ź�ʱ��ͼ  

%% Remove harmonic components by OMP ����OMPȥ��г���͵��Ʒ���  
D1=FourierDict(N,a);    %���帵��Ҷ�ֵ�
s1 = adapomp(D1,ss,c);   %����ӦOMP

%% period segmentation and circulating shift ����ѭ��ƽ�ƽ��зֶ�
[s4,s6]=circshift_segment(s1,l,m,n,N);

%%1D K-SVD with adaptive transient dictionary����ӦK-SVD�㷨
d=randperm(size(s4,2));
y1=s4(:,d(1:k));
y=[y1,s6];
param.initialDictionary = y;   %�����ʼ�ֵ�

[D,output]=KSVD(s4,param);
X = D * output.CoefMatrix;             %KSVD���źž���

%% Signal recovery�ֶ��źŻ�ԭ
x=zeros(N,m);
x=reshape(X,N,m);

%% Perform hard thresholding on dictionary ���ֵ������ֵ����
 [A]=hard(D,0.25);              %���ֵ���Ӳ��ֵ����
 X2=A * output.CoefMatrix;
 x2=zeros(N,m);
 x2=reshape(X2,N,m);
 
 %% ��ͼ
 plot2(t,x2(:,1),fs,2,200,1);   
 toc;