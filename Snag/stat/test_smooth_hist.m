function h=test_real_hist(ni,ndat,par)
%TEST_REAL_HIST  real histogram test
%
%   ni     number of iterations
%   ndat   data array dimension
%   par    parameters:  [bin number, delta, initial value, final value, type]
%                       type = 1 (triangle), 2 (cos+1)/2, 3 exp(||)
%
%   g      real histogram gd

% Version 2.0 - June 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=par(1);
delt=par(2);
ini=par(3);
fin=par(4);
D=fin-ini;
nn=ndat*delt/D;
nh=ceil(sqrt(nn)*10+1)*10;
h(1:nh)=0;
x=(0:nh-1)*0.1;

m=0;v=0;

for i = 1:ni
    dat=rand(ndat,1)*D+ini;
    g=smooth_hist(dat,par,1);
    y=y_gd(g);
    m=m+mean(y);
    v=v+var(y);
    h0=histc(y,x);
    h=h+h0';
end

m=m/ni
devst=sqrt(v/ni)

figure
stairs(x,h);grid on
figure
semilogy(x,h);grid on