function [sidpat,wsid,nsid]=multi_pss_sidpat_1(multisour,ant,Tfft)
% fictitious sid pattern for multi_sources
%     to be used with hough_MC_calib
%       SINGLE PATTERN
%
%   [sidpat,wsid,nsid]=multi_pss_sidpat(multisour,ant,n)
%
%   multisour   source structure with multiple parameters [min max]
%               parameters: d,eta,psi (full 0:90, 0:1, 0:90)
%   ant         antenna structure
%   Tfft        duration of the FFTs (s)

% Version 2.0 - March 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ndecl0=60;
npsi0=ndecl0;
neta0=round(npsi0/4);
nn=120;
iTfft=round(Tfft*nn/86400);
iTfft2=round(0.5*Tfft*nn/86400);

xdecl=0:1/(ndecl0-1):1;
decl0=asin(xdecl)*180/pi;
decl0=sort(decl0);
cosiota=0:1/(neta0-1):1;
eta0=2*cosiota./(1+cosiota.^2);
eta0=sort(eta0);
psi0=0:90/npsi0:90-1/npsi0;

if length(multisour.d) == 1
    decl=multisour.d;
    ndecl=1;
else
    [C,ii1]=min(abs(decl0-multisour.d(1)));
    [C,ii2]=min(abs(decl0-multisour.d(2)));
    decl=decl0(ii1:ii2);
    ndecl=length(decl);
end
if length(multisour.eta) == 1
    eta=multisour.eta;
    neta=1;
else
    [C,ii1]=min(abs(eta0-multisour.eta(1)));
    [C,ii2]=min(abs(eta0-multisour.eta(2)));
    eta=eta0(ii1:ii2);
    neta=length(eta);
end
if length(multisour.psi) == 1
    psi=multisour.psi;
    npsi=1;
else
    [C,ii1]=min(abs(psi0-multisour.psi(1)));
    [C,ii2]=min(abs(psi0-multisour.psi(2)));
    psi=psi0(ii1:ii2);
    npsi=length(psi);
end

sour=multisour;
N=ndecl*neta*npsi;
nsid=N*nn;
sidpat=zeros(1,nsid);
wsid=sidpat;
iii=1;

for i = 1:ndecl
    sour.d=decl(i);
    sour0=sour;
    sour0.eta=-1;
    sour0.psi=0;
    wsid1=y_gd(pss_sidpat(sour0,ant,nn));
    for j = 1:neta
        sour.eta=eta(j);
        for k = 1:npsi
            sour.psi=psi(k);
            sidpat1=y_gd(pss_sidpat(sour,ant,nn));
            sidpat1=circ_filter(ones(1,iTfft)/iTfft,1,sidpat1);
            sidpat1=rota(sidpat1,iTfft2);
            sidpat((0:nn-1)*N+iii)=sidpat1;
            wsid((0:nn-1)*N+iii)=wsid1;
            iii=iii+1;
        end
    end
end

figure,plot(sidpat,'.'),grid on,hold on,plot(wsid,'r.')

wsid=wsid/mean(wsid);