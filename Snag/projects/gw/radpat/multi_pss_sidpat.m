function [sidpat,wsid,ndecl,neta,npsi,nsid]=multi_pss_sidpat(multisour,ant,Tfft)
% sid patterns for multi_sources
%     to be used with hough_MC_calib
%
%   [sidpat,wsid,ndecl,neta,npsi,nsid]=multi_pss_sidpat(multisour,ant,n)
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
nsid=120;
iTfft=round(Tfft*nsid/86400);
iTfft2=round(0.5*Tfft*nsid/86400);

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

% figure,plot(eta,'.')
% figure,plot(psi,'.')
sour=multisour;
Npol=neta*npsi;
sidpat=zeros(ndecl,Npol,nsid);
wsid=zeros(ndecl,nsid);

for i = 1:ndecl
    sour.d=decl(i);
    sour0=sour;
    sour0.eta=-1;
    sour0.psi=0;
    wsid(i,:)=y_gd(pss_sidpat(sour0,ant,nsid));
    wsid(i,:)=wsid(i,:)/mean(wsid(i,:));
    for j = 1:neta
        sour.eta=eta(j);
        for k = 1:npsi
            sour.psi=psi(k);
            sidpat1=y_gd(pss_sidpat(sour,ant,nsid));
            sidpat1=circ_filter(ones(1,iTfft)/iTfft,1,sidpat1);
            sidpat1=rota(sidpat1,iTfft2);
            kpol=(j-1)*npsi+k;
            sidpat(i,kpol,:)=sidpat1;
        end
    end
end

