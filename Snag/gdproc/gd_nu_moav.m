function gout=gd_nu_moav(gin,twin,iczero)
% gd_nu_lowpass  uniform moving average for non-uniformly sampled data
%
%       gout=gd_nu_moav(gin,twin,iczero)
%
%   twin     length of semi-window (in time)  
%   iczero   =1 -> 0 values mean holes

% Version 2.0 - March 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

x=x_gd(gin);
dx=min(diff(x));
kwin=ceil(twin/dx);
y=y_gd(gin);

if iczero == 1
    ii=find(y);
    y=y(ii);
    x=x(ii);
end

n=length(ii);
gout=ii*0;

for i = 1:n
    j1=max(1,i-kwin);
    j2=min(n,i+kwin);
    xx=x(j1:j2);
    yy=y(j1:j2);
    ii=find(abs(x(i)-xx) < twin);
    gout(i)=mean(yy(ii));
end

gout=edit_gd(gin,'x',x,'y',gout,'capt',['nu_moav on ' capt_gd(gin)]);