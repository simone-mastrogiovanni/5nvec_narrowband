function a=rect2astro(r)
% ASTRO2RECT  conversion from astronomical to rectangular coordinates
%
%   r(n,3)    cartesian coordinate array (of the astronomical reference)
%
%   a(n,2)    astronomical coordinates [ra dec distance] [deg deg x]

[i1 i2]=size(r);
if i2 < 3
    r=r';
end
a=zeros(i1,i2);
a(:,1)=atan2(r(:,2),r(:,1))*180/pi;
aa=sqrt(r(:,1).^2+r(:,2).^2+r(:,3).^2);
a(:,2)=90*r(:,3)./aa;
a(:,3)=aa;