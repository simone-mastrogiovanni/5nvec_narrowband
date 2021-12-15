function gout=gd_nu_lowpass(gin,tau,iczero)
% gd_nu_lowpass  bilateral low-pass for non-uniformly sampled data
%
%       gout=gd_nu_lowpass(gin,tau,iczero)
%
%   iczero   =1 0 values mean holes

% Version 2.0 - March 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

x=x_gd(gin);
y=y_gd(gin);

if iczero == 1
    ii=find(y);
    y=y(ii);
    x=x(ii);
end

w=exp(-1/tau);
n=length(y);
S=0;
N=0;

for i = 2:n
    w1=w.^(x(i)-x(i-1));
    N=N*w1+1;
    S=S*w1+y(i);
    y(i)=S/N;
end

m=mean(y);
y=y-m;

S=0;
N=0;

for i = n-1:-1:1
    w1=w.^(x(i+1)-x(i));
    N=N*w1+1;
    S=S*w1+y(i);
    y(i)=S/N;
end

gout=edit_gd(gin,'x',x,'y',y+m,'capt',['nu_lowpass on ' capt_gd(gin)]);