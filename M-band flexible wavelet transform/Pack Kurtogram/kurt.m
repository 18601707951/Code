function K = kurt(x,opt)%�����ź�x���Ͷ�
if strcmp(opt,'kurt2')%�ж�opt�Ƿ�Ϊkurt2
   if all(x == 0), K = 0; E = 0;return;end
   x = x - mean(x);
   E = mean(abs(x).^2);
   if E < eps, K = 0; return;end
   K = mean(abs(x).^4)/E^2;
   if all(isreal(x))
      K = K - 3;								% real signal
   else
      K = K - 2;
   end
elseif strcmp(opt,'kurt1')
   if all(x == 0), K = 0; E = 0;return;end
   x = x - mean(x);
   E = mean(abs(x));
   if E < eps, K = 0; return;end
   K = mean(abs(x).^2)/E^2;
   if all(isreal(x))
      K = K - 1.57;							% real signal
   else
      K = K - 1.27;
   end
end

% ------------------------------------------------------------------------
