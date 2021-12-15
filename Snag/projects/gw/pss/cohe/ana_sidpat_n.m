function out=ana_sidpat_n(ants,sidpats,direc)
% ana_sidpat for multiple antennas
%
%   ants    antennas cell array
%   sidts   sidpats cell array
%   direc   direction structure

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

nant=length(ants);
cols=['b';'r';'g'];
figure

for k = 1:nant
    ant=ants{k}; 
    sidpat=sidpats{k};
    if ~isnumeric(sidpat)
        sidpat=y_gd(sidpat); 
        sidpats{k}=sidpat;
    end
    n=length(sidpat); 
    dh=24/n;
    hour=(0:n-1)*dh;
    plot(hour,sidpat,cols(k)),hold on,grid on
    sidpat_base{k}=ana_sidpat_base(ant,direc);
end

for k = 1:nant
    out.ana{k}=ana_sidpat(sidpats{k},sidpat_base{k});
end