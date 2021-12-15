function spfilt=crea_spec_filter(sour,ant)
% computes the mean spectral filter
%
%  out=spec_filter(sour,ant)

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

spfilt=zeros(1,5);
n=0;
for cosiota = -1:0.1:1
    sour.eta=-2*cosiota/(1+cosiota^2);
    for psi = 0:5:45
        sour.psi=psi;
        [L0, L45, CL, CR, v, Hp, Hc]=sour_ant_2_5vec(sour,ant); 
        spfilt=spfilt+abs(v).^2;
        n=n+1;
    end
end

spfilt=spfilt/n;