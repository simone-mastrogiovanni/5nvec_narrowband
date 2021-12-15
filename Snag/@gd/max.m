function [gout,xout]=max(g1,g2)
% MAX  maximum for two gds or max value of a gd
%  
%     gout=max(g1,g2)  or  [m,x]=max(g1)
% 

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

xout=0;

if exist('g2')
    if g1.n ~= g2.n
        disp(' *** Error: Not equal length gds !')
        gout=0;
        return
    end

    gout=g1;

    gout.capt=['maximum of ' g1.capt ' and ' g2.capt];

    gout.y=max(g1.y,g2.y);
else
    [gout,i]=max(g1.y);
    x=x_gd(g1);
    xout=x(i);
end