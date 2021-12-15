function h=test_real_hist(ni,ndat,gr)
%TEST_REAL_HIST  real histogram test
%
%   ni     number of iterations
%   ndat   data array dimension
%   gr     [period, number of bins, delay to add]
%
%   h      real histogram gd

% Version 2.0 - June 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

per=gr(1);
n=gr(2);
del=gr(3);
dt=per/n;
nn=ndat/n;
nh=ceil(sqrt(nn)*10+1)*10;
h(1:nh)=0;
x=(0:nh-1)*0.1;
m=0;v=0;

for i = 1:ni
    dat=rand(ndat,1)*per;
    g=real_hist(dat,gr,1,1);
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