function [G M]=pss_sky_resp(antenna,sour,noplot)
% pss_sky_resp
%
%    G=pss_sky_resp(antenna,sour)
%
%    antenna
%    sour      if present, fixes the polarization parameters,
%              otherwise the computation is done for circular polarization
%              if sour is a (N,3) array, given sources (N,[decl eta psi]) (for montecarlos)
%    noplot    =1 no plots

% Version 2.0 - March 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('noplot','var')
    noplot=0;
end
N=2000;
dd=90/(N-1);
d=(0:N-1)*dd;

G=zeros(1,N);
icsour=1;
M=0;

if ~exist('sour','var')
    sour.psi=0;
    sour.eta=0;
    sour.a=0;
    icsour=0;
end

if isstruct(sour)
    for i = 1:N
        sour.d=d(i);
        [L0 L45 CL CR A Hp Hc]=sour_ant_2_5vec(sour,antenna);
        if icsour == 0
            G(i)=sqrt((norm(L0)^2+norm(L45)^2)/2);
        else
            G(i)=sqrt(norm(Hp*L0)^2+norm(Hc*L45)^2);
        end
    end

    w=cos(d*pi/180);
    meanG=sum(G.*w)/sum(w)
    meanGG=sqrt(sum((G.^2).*w)/sum(w))

    G=gd(G);
    G=edit_gd(G,'dx',dd);

    if noplot == 0
        figure,plot(G),grid on,title('Amplitude seen in the antenna'),xlabel('Source declination (abs value)')
        hold on,plot([0 90],[meanGG meanGG],'r')
        figure,plot(1./G),grid on,title('Loss factor (in h)'),xlabel('Source declination (abs value)')
        hold on,plot([0 90],[1/meanGG 1/meanGG],'r')
    end

    if icsour == 0
        M=zeros(200,91);
        dd=90/199;
        d=(0:199)*dd;
        for i = 1:200
            sour.d=d(i);
            for j = 1:91
                sour.psi=(j-1)/2;
                [L0 L45 CL CR A Hp Hc]=sour_ant_2_5vec(sour,antenna);
                M(i,j)=norm(A);
            end
        end
        M=gd2(M);
        M=edit_gd2(M,'dx',dd,'dx2',0.5)
        image_gd2(M),xlabel('Declination'),ylabel('Polarization angle')
        title('Amplitude seen in the antenna')
    end
else
    [N N1]=size(sour);
    
    G=zeros(1,N);
    sour1.a=0;
    
    for i = 1:N
        sour1.d=sour(i,1);
        sour1.eta=sour(i,2);
        sour1.psi=sour(i,3);
        [L0 L45 CL CR A Hp Hc]=sour_ant_2_5vec(sour1,antenna);
        G(i)=sqrt(norm(Hp*L0)^2+norm(Hc*L45)^2);
    end
    
    [M xM]=hist(1./G,200);
    fprintf('mean loss factor %f  St.dev. %f \n',mean(1./G),std(1./G))
    
    figure,stairs(xM,M),grid on
end
        