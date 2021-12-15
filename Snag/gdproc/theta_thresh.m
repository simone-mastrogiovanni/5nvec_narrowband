function y=theta_thresh(x,x0,k)
% normalized threshold theta function
%
%
%
%    x    input data (array or gd)
%    x0   input scale parameter (any real positive)
%    k    exponent parameter (any real positive, def 1)

% Version 2.0 - August 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('k','var')
    k=1;
end
isgd=0;
if isa(x,'gd')
    isgd=1;
    x1=x;
    x=y_gd(x);
end

y=1./(1+(x/x0).^-k);

if isgd == 1
    y=edit_gd(x1,'y',y);
end