function [A] = plot1(t,s,l,k)
% =========================================================================
%                          Written by Yi Qin
% =========================================================================
%������ͼƬ��s��ʾ�źţ�t��ʾʱ�����У�l��ʾͼ��
hl=figure(l);         %��������г���͵��Ʒ����ź�ͼ
p_vect=[700 400 660 200];
set(hl,'Position',p_vect);
plot(t,s,'linewidth',2);
set(gca,'fontsize',15)
xlabel('\fontsize{15}\fontname{Times New Roman}\itt\rm\bf / \rms');
ylabel('\fontsize{15}\fontname{Times New Roman}\it A');
xlim([0 k]);
