function [sidpat,aftsp]=pss_sidpat_psi(sour,ant,n,dpsi)
% sidereal power pattern for varying psi (Greenwich Sidereal Time)
%
%     [sidpat,aftsp]=pss_sidpat_psi(sour,ant,n,dpsi)
%
%  sour,ant   source and antenna structures
%  n          number of points in the sidereal day (def 240)
%  dpsi       step for psi; if 0, circular polarization

% Version 2.0 - October 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('n','var')
    n=240;
end
if ~exist('dpsi','var')
    dpsi=5;
end

if dpsi > 0
    sour.eta=0;
    m=floor(90/dpsi);
    sidpat=zeros(m,n);
    aftsp=zeros(m,6);

    for i = 1:m
        sour.psi=(i-1)*dpsi;
        [L0 L45 CL CR v Hp Hc]=sour_ant_2_5vec(sour,ant);

        st=(0:n-1)*2*pi/n;

        lf=0;
        for j = 1:5
            lf=lf+v(j)*exp(1j*(j-3)*st);
        end

        sidpat(i,:)=abs(lf).^2;
        ft=fft(sidpat(i,:));
        aftsp(i,:)=abs(ft(1:6));
    end

    sidpat=gd2(sidpat');
    sidpat=edit_gd2(sidpat,'dx',24/n,'dx2',dpsi);
else
    sour.eta=1;
    [L0 L45 CL CR v Hp Hc]=sour_ant_2_5vec(sour,ant);

    st=(0:n-1)*2*pi/n;

    lf=0;
    for j = 1:5
        lf=lf+v(j)*exp(1j*(j-3)*st);
    end

    sidpat=abs(lf).^2;
    ft=fft(sidpat);
    aftsp=abs(ft(1:6));
    sidpat=gd(sidpat);
    sidpat=edit_gd(sidpat,'dx',24/n);
end