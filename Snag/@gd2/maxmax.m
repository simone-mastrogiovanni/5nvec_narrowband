function [a,i,j]=maxmax(g2,icphys)
% max of a gd2
%
%     [a,i,j]=maxmax(g2,icphys)
%
%   g2       input gd2
%   icphys   =1 physical abscissa values (def), =0 indices

% Version 2.0 - September 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('icphys','var')
    icphys=1;
end
A=g2.y;

[aa,i1]=max(A);
[a,j]=max(aa);
i=i1(j);

if icphys == 1
    x=x_gd2(g2);
    i=x(i);
    x=x2_gd2(g2);
    j=x(j);
end