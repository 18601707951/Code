function [A] = plot2(t,s,fs,l,m,k)
%��2*1��ͼƬ��s��ʾ�źţ�t��ʾʱ�����У�l��ʾͼ�ţ�m��ʾ������x������;k��ʾʱ��ͼx������
% =========================================================================
%                          Written by Yi Qin
% =========================================================================
hl=figure(l);
p_vect=[700 400 660 400];
% set(gca,'Position',p_vect,'fontsize',20);

subplot(211);
plot(t,s,'linewidth',2);
xlabel('\fontsize{15}\fontname{Times New Roman}\itt\rm\bf / \rms');
ylabel('\fontsize{15}\fontname{Times New Roman}\it A');
set(gca,'fontsize',15);
xlim([0,k]);

subplot(212)
EnvelSpec(s,fs,m);
xlabel('\fontsize{15}\fontname{Times New Roman}\itf\rm\bf / \rmHz');
ylabel('\fontsize{15}\fontname{Times New Roman}\it A');
set(gca,'fontsize',15);
