function d=distprod(d1,d2)
% DISTPROD  distribution of the product of two random variables
%
%      d=distprod(d1,d2)
%
%   d1   type 1 gd with the first distribution
%   d2   type 1 gd with the second distribution

% Version 2.0 - March 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ini1=ini_gd(d1);
dx1=dx_gd(d1);
ini2=ini_gd(d2);
dx2=dx_gd(d2);
dx=min(dx1,dx2);
n1=n_gd(d1);
n2=n_gd(d2);
fin1=ini1+dx1*n1;
fin2=ini2+dx2*n2;
y1=y_gd(d1);
x1=x_gd(d1);
y2=y_gd(d2);
x2=x_gd(d2);

a11=ini1*ini2;
a12=ini1*fin2;
a21=fin1*ini2;
a22=fin1*fin2;

ini=min([a11,a12,a21,a22]);
fin=max([a11,a12,a21,a22]);
max1=max(abs(max(x1)),abs(max(x2)));

for i = 1:n1
    ini=min([ini x1(i)*x2.']);
    fin=max([fin x1(i)*x2.'])+dx*max1;
end

ini=ini-dx*max1;
fin=fin+dx*max1;

n=round((fin-ini)/dx)+1;ini1,ini2,ini,fin1,fin2
d=zeros(1,n+50);

for i = 1:n1
    for j = 1:n2
        b11=(x1(i)-dx1/2)*(x2(j)-dx2/2);
        b12=(x1(i)-dx1/2)*(x2(j)+dx2/2);
        b21=(x1(i)+dx1/2)*(x2(j)-dx2/2);
        b22=(x1(i)+dx1/2)*(x2(j)+dx2/2);
        xini=min([b11,b12,b21,b22]);
        xfin=max([b11,b12,b21,b22]);
        i1=round((xini-ini)/dx)+21;
        i2=round((xfin-ini)/dx)+21;%disp([i j i1 i2])
        tot=y1(i)*y2(j);
        dtot=tot/(i2-i1+1);
        d(i1:i2)=d(i1:i2)+dtot;
    end
end

d=d/(sum(d)*dx);
d=gd(d);
d=edit_gd(d,'ini',ini,'dx',dx);