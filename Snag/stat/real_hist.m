function g=real_hist(dat,gr,circ,nofig)
%REAL_HIST  real histogram
%
%   dat    data array
%   gr     circ = 0 -> grid edge values
%          circ = 1 -> [period, number of bins, delay to add]
%   circ   = 1 circular domain
%   nofig  = 1 no figure
%
%   g      real histogram gd

% Version 2.0 - June 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('circ')
    circ=0;
end
if ~exist('nofig')
    nofig=0;
end

dat=dat(:);
N=length(dat);
del=0;

if circ == 1
    per=gr(1);
    n=gr(2);
    del=gr(3);
    dt=per/n;
    gr=(0:n)*dt;
else
    n=length(gr);
    gr(n+1)=2*gr(n)-gr(n-1);
end

g(1:n+1)=0;
[dum,ii]=histc(dat,gr);
NN=0;

for i = 1:N
    ii0=ii(i);
    if ii0 > 0
        d=(dat(i)-floor(dat(i)))/(gr(ii0+1)-gr(ii0));
        g(ii0)=g(ii0)+1-d;
        g(ii0+1)=g(ii0+1)+d;
    end
end

if circ == 1
    g(1)=g(1)+g(n+1);
end

g=g(1:n);

if nofig ~= 1
	figure
	gr=gr(1:n);
	stairs(gr,g);
	grid on
end

g=gd(g);
g=edit_gd(g,'x',gr,'capt','real histogram');