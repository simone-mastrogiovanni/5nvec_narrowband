function gout=denan_gd(gin,val)
% eliminates NaN values in gds
%
%      denan_gd(gin,val)
%
%   val     substitution value (def 0)

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('val','var')
    val=0;
end
ii=find(isnan(gin.y));
gout=gin;
gout.y(ii)=val;