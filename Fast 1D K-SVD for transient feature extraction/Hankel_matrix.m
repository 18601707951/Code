function [S] = Hankel_matrix(s3,l,m,n,N)
%����Hankel���� Generate Hankel matrix
% =========================================================================
%                          Written by Yi Qin
% =========================================================================
s4=reshape(s3,l,N/l);                                   %���źŽ��зֶ�

%S = zeros(m,n);
for k=1:N/l
    for i=1:m
        for j=1:n
            S(i,j,k)=s4(i+j-1,k);                        %����Hankel����
        end
    end
end
