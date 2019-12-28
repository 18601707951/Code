function [A]=OMP(D,X,L)
%=============================================
% Sparse coding of a group of signals based on a given 
% dictionary and specified number of atoms to use. 
% input arguments: 
%       D - the dictionary (its columns MUST be normalized).
%       X - the signals to represent
%       L - the max. number of coefficients for each signal.
% output arguments: 
%       A - sparse coefficient matrix.
%=============================================
[n,P]=size(X);
[n,K]=size(D);
for k=1:1:P
    a=[];
    x=X(:,k);               %�ֱ�����źŵ�ÿһ��
    residual=x;             %��ʼ��x����Ϊ�в�
    indx=zeros(L,1);        %����������������Ϊϡ���ΪL����������ΪL
    for j=1:1:L
        proj=D'*residual;   %���ֵ�ת�ó��Բв�൱����ÿ���ֵ�ԭ�����ź����ڻ���
        [maxVal,pos]=max(abs(proj));    %��ȡ�������ڻ�����ԭ�ӵ��к�
        pos=pos(1);                     %���ж���ڻ���ͬ��ȡ����һ����ֵ��pos
        indx(j)=pos;                    %��pos��ֵ����j�ε�����������
        a=pinv(D(:,indx(1:j)))*x;       %����ȡ������ԭ����α�棬�����ź���˵õ���Ӧ��ϵ��
        residual=x-D(:,indx(1:j))*a;    %
        if sum(residual.^2) < 1e-6
            break;
        end
    end
    temp=zeros(K,1);
    temp(indx(1:j))=a;
    A(:,k)=sparse(temp);
end
return;
