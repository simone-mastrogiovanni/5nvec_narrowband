function g1=gd2_to_gd(g2,absc,i1,i2)
% gd2_to_gd  extracts data from a gd2 to a gd
%
%      g1=gd2_to_gd(g2,absc,i1,i2)
%
%    g2     input gd2
%    absc   1 primary abscissa, 2 secondary abscissa
%    i1     [min,max] primary ascissa choice or mean (0 no choice or mean)
%    i2     [min,max] secondary ascissa choice or mean (0 no choice or mean)

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

M=g2.y;
typ=g2.type;

[n1 n2]=size(M);
if length(i1) == 1
    if i1 == 0
        i1=[1 n1];
    else
        i1=[i1 i1];
    end
end
if length(i2) == 1
    if i2 == 0
        i2=[1 n2];
    else
        i2=[i2 i2];
    end
end
M=M(i1(1):i1(2),i2(1):i2(2));
[n1 n2]=size(M);

switch absc
    case 1
        if n2 > 1
            g1=mean(M');
        else
            g1=M;
        end
        g1=gd(g1);
        if typ == 2
            g1=edit_gd(g1,'x',g2.x(i1(1):i1(2)));
        else
            g1=edit_gd(g1,'dx',g2.dx,'ini',g2.ini+(i1(1)-1)*g2.dx);
        end
    case 2
        if n1 > 1
            g1=mean(M);
        else
            g1=M;
        end
        g1=gd(g1);
        g1=edit_gd(g1,'dx',g2.dx2,'ini',g2.ini2+(i2(1)-1)*g2.dx2);
end