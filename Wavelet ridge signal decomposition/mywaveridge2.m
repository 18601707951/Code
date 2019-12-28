function [wra,as]=mywaveridge2(y,fb,fc,thr,a0,MAXITERATIONS)
%%%%%%%%%%%%%%%%%%%%%%%%%%�������˵��
%%%%y------------------------�������ź�
%%%%fb,fc--------------------MorletС��ʱ��������������Ƶ��
%%%%thr----------------------ֹͣ��ֵ
%%%%a0-----------------------��ֵ
%%%%MAXITERATIONS------------����������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%�������˵��
%%%%wra------------------------С������
%%%%as-------------------------�����ֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================
%                          Written by Yi Qin
% =========================================================================

N=length(y);
e=thr;

l=floor(N/50);
a=a0;
y1=[y(1:l) y y(N-l+1:N)];

ll=ceil(N/90);
% ll=0;
%for b=1:N-1
for b=1:ll
    item=0;
    tmin=inf; %Realmax;
    while 1
%         c=cwt(y,a,wname);
        if(a>1000*fc)
            a=round(1000*fc);
        end
        c=mymorletcwt(y,a,fb,fc,1);
        item=item+1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%ǰ���ֹ�ʽ(�Ա�����)
        wph(1)=angle(c(b));
        wph(2)=angle(c(b+1));
        if wph(2)-wph(1)>=pi
            wph(2)=wph(2)-2*pi;
        elseif wph(2)-wph(1)<=-pi
            wph(2)=wph(2)+2*pi;
        end
        Db=abs(wph(2)-wph(1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        w0=2*pi*fc;   %��������Ƶ��
        ar=w0*1/Db;
       
        tr=abs((ar-a)/a);
        if tr<tmin
            tmin=tr;
            minarb=a;
        end
        if tr<e
            wra(b)=a;
            as(b)=2*abs(c(b))/sqrt(wra(b));    %%%%%%%%�����ֵ
            a=ar;
            break;
        else
            a=ar;
        end
        
         if item>MAXITERATIONS       %%%%%%%%%%%%%%%%%%��ɢʱ�Ĵ���
%             disp(num2str(item));

%             disp(num2str(b));
%             disp(num2str(tmin));
            wra(b)=minarb;
            as(b)=2*abs(c(b))/sqrt(wra(b));   %%%%%%%%�����ֵ

            a=ar;
            break;
         end
        
    end
end

for b=l+1+ll:N-1+l-ll
    item=0;
    tmin=inf; %Realmax;
    while 1
%              c=cwt(y1(b-l:b+l),a,wname); 
        if(a>1000*fc)
            a=round(1000*fc);
        end
        c=mymorletcwt(y1(b-l:b+l),a,fb,fc,1);
%             c=cwt(y(b:N),a,wname);

%         c=cwt(y,a,wname);   
        item=item+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%ǰ���ֹ�ʽ(�Ա�����)
%        wph(1)=angle(c(b));
%        wph(2)=angle(c(b+1));
         wph(1)=angle(c(l+1));
         wph(2)=angle(c(l+2));
        if wph(2)-wph(1)>=pi
            wph(2)=wph(2)-2*pi;
        elseif wph(2)-wph(1)<=-pi
            wph(2)=wph(2)+2*pi;
        end
        Db=abs(wph(2)-wph(1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        w0=2*pi*fc;
        ar=w0*1/Db;
       
        tr=abs((ar-a)/a);
        if tr<tmin
            tmin=tr;
            minarb=a;
        end
        if tr<e
            wra(b-l)=a;
            %as(b)=2*abs(c(b))/sqrt(wra(b));    %%%%%%%%�����ֵ
            as(b-l)=2*abs(c(l+1))/sqrt(wra(b-l));    %%%%%%%%�����ֵ
            a=ar;
            break;
        else
            a=ar;
        end
        
         if item>MAXITERATIONS       %%%%%%%%%%%%%%%%%%��ɢʱ�Ĵ���
%             disp(num2str(item));

%             disp(num2str(b));
%             disp(num2str(tmin));
            wra(b-l)=minarb;
  %           as(b)=2*abs(c(b))/sqrt(wra(b));   %%%%%%%%�����ֵ
            as(b-l)=2*abs(c(l+1))/sqrt(wra(b-l));    %%%%%%%%�����ֵ
            a=ar;
            break;
         end        
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
for b=N-ll:N
    item=0;
    tmin=inf; %Realmax;
    while 1
%         c=cwt(y,a,wname);
        if(a>1000*fc)
            a=round(1000*fc);
        end
        c=mymorletcwt(y,a,fb,fc,1);
        item=item+1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%ǰ���ֹ�ʽ(�Ա�����)
        wph(1)=angle(c(b));
        if b==N
             wph(2)=angle(c(1));
        else
            wph(2)=angle(c(b+1));
        end
        if wph(2)-wph(1)>=pi
            wph(2)=wph(2)-2*pi;
        elseif wph(2)-wph(1)<=-pi
            wph(2)=wph(2)+2*pi;
        end
        Db=abs(wph(2)-wph(1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        w0=2*pi*fc;
        ar=w0*1/Db;
       
        tr=abs((ar-a)/a);
        if tr<tmin
            tmin=tr;
            minarb=a;
        end
        if tr<e
            wra(b)=a;
            as(b)=2*abs(c(b))/sqrt(wra(b));    %%%%%%%%�����ֵ
            a=ar;
            break;
        else
            a=ar;
        end
        
         if item>MAXITERATIONS       %%%%%%%%%%%%%%%%%%��ɢʱ�Ĵ���
%           disp(num2str(item));

%             disp(num2str(b));
%             disp(num2str(tmin));
            wra(b)=minarb;
            as(b)=2*abs(c(b))/sqrt(wra(b));   %%%%%%%%�����ֵ
            a=ar;
            break;
         end
        
    end
end