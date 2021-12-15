function [sidpat,ftsp,v]=pss_sidpats(sour,ant,n,etas,psis,culm)
% sidereal power pattern (Greenwich Sidereal Time) for all eta and psi
%
%     radpat=pss_sidpat(source,antenna,n)
%
%  sour,ant   source and antenna structures
%  n          number of points in the sidereal day (def 240, negative plots)
%  etas       default 0:0.01:1
%  psis       default 0:90
%  culm       =1 culmination 5-vect (or basic 5-vect; def 1) 

% Version 2.0 - October 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('n','var')
    n=240;
end
icplot=0;
if n < 0
    n=-n;
    icplot=1;
end
hour=(0:n-1)*24/n;
if ~exist('etas','var')
    etas=0:0.01:1;
end
if ~exist('psi','var')
    psis=0:89;
end
if ~exist('culm','var')
    culm=1;
end

if icplot == 1
    figure
end
for i = 1:length(etas)
    sour.eta=etas(i);
    for j = 1:length(psis)
        sour.psi=psis(j);
        [L0 L45 CL CR vv Hp Hc]=sour_ant_2_5vec(sour,ant,culm);
        v{i,j}=vv;

        st=(0:n-1)*2*pi/n;

        lf=0;
        for k = 1:5
            lf=lf+vv(k)*exp(1j*(k-3)*st);
        end

        sidpat{i,j}=abs(lf).^2;
        ftsp1=fft(sidpat{i,j});
        fnorm=sqrt(sum(abs(ftsp1).^2));
        ftsp{i,j}=ftsp1/fnorm;
        if icplot == 1
            plot(hour,sidpat{i,j}),grid on,xlim([0 24]),ylim([0 1])
            title(sprintf('eta = %f,  psi = %f',etas(i),psis(j)))
            pause(0.1)
        end
    end
end