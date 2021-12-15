function x=corr_numb(N,ro,typ)
% Creates correlated sequences
%
%   x=corr_numb(N,ro,typ)
%
%  N     length
%  ro    correlation coeff
%  typ   distribution (0 normal (def), 1 uniform)

% Version 2.0 - August 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('typ','var')
    typ=0;
end

switch typ
    case 0
%         disp('x normal')
        x=randn(N,2);
    case 1
%         disp('x1 uniform')
        x=rand(N,2);
end

A=ro;
B=sqrt(1-ro^2);
AB=sqrt(A^2+B^2);

x(:,2)=(x(:,1)*A+x(:,2)*B)/AB;
