function c=gd_conv(g1,g2)
% GD_CONV  2 gds convolution
%
%     c=gd_conv(g1,g2)
%
%  checks for equal sampling

% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

yg1=y_gd(g1);
ig1=ini_gd(g1);
dg1=dx_gd(g1);

yg2=y_gd(g2);
ig2=ini_gd(g2);
dg2=dx_gd(g2);

if dg1 ~= dg2
    disp(' *** not equal sampling')
    return
end

c=conv(yg1,yg2)*dg1;
ini=ig1+ig2;
c=gd(c);
c=edit_gd(c,'ini',ini,'dx',dg1);