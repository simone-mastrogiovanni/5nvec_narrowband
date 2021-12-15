function a=power_gd(b,pow)
%GD/POWER_GD   power
%
%      a=power_gd(b,pow)
%       or
%      a=power_gd(b)

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=b;

if ~exist('pow')
   answ1=inputdlg({'Power'},'Power of a gd',1,{'0.5'});
   
   pow=eval(answ1{1});
end

a.y=b.y.^pow;