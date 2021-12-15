function [lam,ini]=semicirc(b0,cosfi,bet,graph)
%SEMICIRC   draws a semicirconference 
%
%      [lam,ini]=semicirc(b0,cosfi,bet,graph)
%
% the input angles are in radiants, also bet
%
%    lam          the lambdas of the circles (degrees)
%    ini          the first index of the betas
%
%    l0=0,b0,fi   are the center and the radius of the circle
%    bet          are the beta values
%    graph > 0 plots pausing graph sec, graph < 0 plots only at the end

pi2=pi/2;
pi22=2*pi;
eps=0.000001;
rad2deg=180/pi;

fi=acos(cosfi);

d1=b0-fi;
if d1 < -pi2 
   d1=-pi2+eps;
end

d2=b0+fi;
if d2 > pi2 
   d2=pi2-eps;
end

dmax=max(d1,d2);
dmin=min(d1,d2);

len1=0;
ini1=1;
d=zeros(1,length(bet));

for i = 1:length(bet)
    if bet(i) < dmin
        ini1=ini1+1;
    end
    if bet(i) >= dmin & bet(i) <= dmax
        len1=len1+1;
        d(len1)=bet(i);
    end
end

if len1 == 0
   k=discr1(bet,(dmax+dmin)/2);
   len1=1;
   d=bet(k);
   disp('zero kength !');
end

d=d(1:len1);
y=(cosfi-sin(d).*sin(b0))./(cos(d).*cos(b0));

ii=0;
testini=0;

for i = 1:len1
   if abs(y(i)) <= 1 
      ii=ii+1;
      lam(ii)=acos(y(i))*rad2deg;
      if lam(ii) < 0
         lam(ii)=lam(ii)+360;
      end
      if lam(ii) > 360
         lam(ii)=lam(ii)-360;
      end
      beta(ii)=d(i)*rad2deg;
      if testini == 0 
          ini=ini1+i-1;
          testini=1;
      end
  else
      sprintf('per i = %d abs(y) > 1 !',i);
   end
end

len=ii;

if ii == 0
   lam=-1000;delt=-1000;
end

if graph > 0
   plot(lam,beta,'b+'); hold on
   plot(-lam+360,beta,'g+'); hold on
   pause(graph)
elseif graph < 0     
   plot(lam,beta,'b+'); hold on
end
