function a=atan3(c)
%ANALYSIS\ATAN3  computes atan3 (in number of turns; 1 turn = 360 degrees)
%
%    a=atan3(c)
%
%  c   a complex vector (or gd)
%

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

igd=0;
if isa(c,'gd')
    c1=c;
    c=y_gd(c);
    igd=1;
end

pi2=2*pi;
n=length(c);

b=angle(c)/pi2;
dif=diff(b);
dif(n)=0;
dif=rota(dif,1);
s=rota(b,-1);
s(1)=0;
s=sign(s);

cdif=thresh(abs(dif),0.5,2);
cdif=-cdif.*s+dif;

cdif1=rota(cdif,1);
cdif2=rota(cdif,-1);
i= cdif1.*cdif2 > 0 & cdif1.*cdif < 0;
cdif(i)=(cdif1(i)+cdif2(i))/2;

a=cumsum(cdif);

if igd == 1
    capt=capt_gd(c1);
    a=edit_gd(c1,'y',a,'capt',['atan3 of' capt]);
end
   