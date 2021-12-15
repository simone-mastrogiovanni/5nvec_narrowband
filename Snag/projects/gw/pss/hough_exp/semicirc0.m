function [alf,delt]=semicirc0(d0,cosfi,dd,graph)
%SEMICIRC   draws a semicirconference 
%
%      [alf,delt]=semicirc(d0,cosfi,dd,graph)
%
% the angles are in radiants, also dd
% a0=0,d0,fi are the center and the radius of the circle
% dd are the declination values
% graph > 0 plots pausing graph sec, graph < 0 plots only at the end

pi2=pi/2;
pi22=2*pi;
eps=0.0001;
a0=0;

fi=acos(cosfi);

d1=d0-fi;
if d1 < -pi2 
   d1=-pi2+eps;
end

d2=d0+fi;
if d2 > pi2 
   d2=pi2-eps;
end

dmax=max(d1,d2);
dmin=min(d1,d2);

n=0;

for i = 1:length(dd)
   if dd(i) >= dmin & dd(i) <= dmax
      n=n+1;
      d(n)=dd(i);
   end
end

if n == 0
   k=discr1(dd,(dmax+dmin)/2);
   n=1;
   d=dd(k);
end

y=(cosfi-sin(d).*sin(d0))./(cos(d).*cos(d0));

ii=0;

for i = 1:n
   if abs(y(i)) <= 1 
      ii=ii+1;
      alf(ii)=acos(y(i))+a0;
      if alf(ii) < 0
         alf(ii)=alf(ii)+pi22;
      end
      if alf(ii) > pi22
         alf(ii)=alf(ii)-pi22;
      end
      delt(ii)=d(i);
   end
end


if ii == 0
   alf=-100;delt=-100;
end

if graph > 0
   plot(alf,delt,'b+'); hold on
   pause(graph)
elseif graph < 0     
   plot(alf,delt,'b'); hold on
end