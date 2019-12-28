%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [K,KQ] = K_wpQ_local(x,h,g,h1,h2,h3,nlevel,opt,level)%����ÿ����Ͷȣ����ֲ��Ͷȴ洢��K�У����ֲ��Ͷȴ洢��KQ��,level=nlevelʱ�����һ�㣬Ȼ�󰴲���-1��level��С����������

[a,d] = DBFB(x,h,g);                    % perform one analysis level into the analysis tree�����˲�����������ĵ�Ƶ�ź�a���Ƶ�ź�d

N = length(a);                       
d = d.*(-1).^(1:N)';%��ͨ�ź�*��-j��^n

K1 = kurt(a(length(h):end),opt);%??
K2 = kurt(d(length(g):end),opt);

if level > 2%����������ǰ�������ֶ�
   [a1,a2,a3] = TBFB(a,h1,h2,h3);%����һ��ĵ�Ƶ����Ϊ��׼�������˲�
   [d1,d2,d3] = TBFB(d,h1,h2,h3);%����һ��ĸ�Ƶ����Ϊ��׼�������˲�
   %���ֶκ���Ͷ�
   Ka1 = kurt(a1(length(h):end),opt);
   Ka2 = kurt(a2(length(h):end),opt);
   Ka3 = kurt(a3(length(h):end),opt);
   Kd1 = kurt(d1(length(h):end),opt);
   Kd2 = kurt(d2(length(h):end),opt);
   Kd3 = kurt(d3(length(h):end),opt);
else%������һ���㲻�������ֶ��Ͷȣ���0ֵ����
   Ka1 = 0;
   Ka2 = 0;
   Ka3 = 0;
   Kd1 = 0;
   Kd2 = 0;
   Kd3 = 0;
end

if level == 1
   K =[K1*ones(1,3),K2*ones(1,3)];%������һ����ֶ��Ͷȴ洢��ÿ����������Ԫ���
   KQ = [Ka1 Ka2 Ka3 Kd1 Kd2 Kd3];%������һ�����ֶ��Ͷ�ֵ�洢��KQ�У�ʵ��ֵΪ�㣬ÿ�γ���Ϊһ����Ԫ
end

if level > 1
   [Ka,KaQ] = K_wpQ_local(a,h,g,h1,h2,h3,nlevel,opt,level-1);%ѭ������ÿ���Ƶ���ַ�Ϊ���μ����ε��Ͷ�,�൱��level=level-1������Ƕ��ѭ��
   [Kd,KdQ] = K_wpQ_local(d,h,g,h1,h2,h3,nlevel,opt,level-1);%ѭ������ÿ���Ƶ���ַ�Ϊ���μ����ε��Ͷ�
   
   K1 = K1*ones(1,length(Ka));
   K2 = K2*ones(1,length(Kd));
   K = [K1 K2; Ka Kd];
   
   Long = 2/6*length(KaQ);
   Ka1 = Ka1*ones(1,Long);
   Ka2 = Ka2*ones(1,Long);
   Ka3 = Ka3*ones(1,Long);
   Kd1 = Kd1*ones(1,Long);
   Kd2 = Kd2*ones(1,Long);
   Kd3 = Kd3*ones(1,Long);
   KQ = [Ka1 Ka2 Ka3 Kd1 Kd2 Kd3; KaQ KdQ];
end

if level == nlevel
   K1 = kurt(x,opt);
   K = [ K1*ones(1,length(K));K];%δ�ֽ�ǰ��ԭʼ�źŵ��Ͷȴ洢��K�е�һ��
   
   [a1,a2,a3] = TBFB(x,h1,h2,h3);%ԭʼ�ź����ֶ��˲�
   Ka1 = kurt(a1(length(h):end),opt);
   Ka2 = kurt(a2(length(h):end),opt);
   Ka3 = kurt(a3(length(h):end),opt);
   Long = 1/3*length(KQ);
   Ka1 = Ka1*ones(1,Long);
   Ka2 = Ka2*ones(1,Long);
   Ka3 = Ka3*ones(1,Long);   
   KQ = [Ka1 Ka2 Ka3; KQ(1:end-2,:)];
end

% --------------------------------------------------------------------