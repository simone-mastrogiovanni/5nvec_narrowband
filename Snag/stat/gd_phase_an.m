function g=gd_phase_an(gin,per,n)
% GD_PHASE_AN  phase analysis
%
%    g=gd_phase_an(gin,per,n)
%
%   gin    input gd
%   per    period to analyze
%   n      number of bins in the phase diagram
%
%   g      phase diagram

% Version 2.0 - May 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nin=n_gd(gin);
if ~exist('n','var')
    n=ceil(nin/10);
end

y=y_gd(gin);
x=x_gd(gin);
x=x-x(1);

dt=per/n;
pd=zeros(1,n);
npd=pd;
i=floor(n*mod(x,per)/per)+1;
ii=find(i>n);
i(ii)=n;

for k = 1:nin
    pd(i(k))=pd(i(k))+y(k);
    npd(i(k))=npd(i(k))+1;
end

ii=find(pd);
pd(ii)=pd(ii)./npd(ii);

figure,plot((0:n-1)*dt,pd),grid on

g=gd(pd);
g=edit_gd(g,'dx',dt,'capt','Phase diagram');