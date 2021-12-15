function [g signs lamns pulamp]=gd_nonstat(N,dt,gaus,puls)
% GD_NONSTAT  creates 0-mean non-stationary gaussian noise with non-stationary
%             Poisson-Laplace pulses
%
%       [g signs lamns pulamp]=gd_nonstat(N,dt,gaus,puls);
%
%   N,dt         number of data, sampling time  (ex: 100000,1)
%   gaus         n-s gaussian parameters
%       .amp     mean sigma  (ex: 1) 
%       .filt    filter structure (if present: filter.a, filter.b)
%       .nstau   non-stationarity tau (in the same unit of dt)  (ex: 20000)
%   puls         n-s pulse process
%       .lambda  poisson mean lambda  (ex: 0.001)
%       .taulam  n-s tau for lambda  (ex: 20000)
%       .amp     mean amplitude  (ex: 200)
%       .tauamp  tau amp   (ex: 20000)

% Version 2.0 - December 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

rg1=randn(N,1)*gaus.amp;
rg2=(randn(N,1)+1i*randn(N,1))*sqrt(2/pi);

if isfield(gaus,'filt')
    a=gaus.filter.a;
    b=gaus.filter.b;
    rg1=filter(b,a,rg1);
end

% rg2=ar_lowpass(rg2,gaus.nstau/dt);
rg2=ar_lowpass_freq(rg2,1/(pi*gaus.nstau/dt),1);
signs=abs(rg2);

g=rg1.*signs;

if exist('puls','var')
    rg1=rand(N,1);
    rg2=(randn(N,1)+1i*randn(N,1))*sqrt(2/pi);
%     rg2=ar_lowpass(rg2,puls.taulam/dt,1);
    rg2=ar_lowpass(rg2,1/(pi*puls.taulam/dt),1);
    rp3=laplrnd(puls.amp,N,1);
    rp4=(randn(N,1)+1i*randn(N,1))*sqrt(2/pi);
%     rp4=ar_lowpass(rp4,puls.tauamp/dt,1);
    rp4=ar_lowpass(rp4,1/(pi*puls.tauamp/dt),1);
    
    lamns=puls.lambda*abs(rg2);
    [i2 i1]=find(rg1 < lamns);
    pulamp=abs(rp4(i2));
    g(i2)=rp3(i2).*pulamp;
end
    
g=gd(g);
g=edit_gd(g,'dx',dt,'capt','Non-stationary disturbed process');
signs=edit_gd(g,'dy',signs,'capt','Non-stationary sigma');
lamns=edit_gd(g,'dy',lamns,'capt','Non-stationary lambda');
pulamp=edit_gd(g,'dy',pulamp,'capt','Non-stationary pulse amplitude');