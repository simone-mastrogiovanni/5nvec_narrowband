function mp_multiplot(varargin)
% MP_MULTIIPLOT  plots more mps
%
%   mp_multiplot(mp1,'r',mp2,'g--',...)

% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

figure,hold on

for i = 1:2:nargin
    m=varargin{i};
    typ=varargin{i+1};
    for j = 1:m.nch
        plot(m.ch(j).x,m.ch(j).y,typ)
    end
end

grid on