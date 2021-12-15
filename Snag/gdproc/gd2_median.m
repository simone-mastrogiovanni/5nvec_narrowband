function g1=gd2_median(g2,idim,iczero)
% gd2_median  median of a gd2 along one dimension
%
%    g1=gd2_median(g2,idim)
%
%   g2       input gd2
%   idim     =1 primary abscissa (median of data on primary)
%            =2 secondary abscissa (median of data on secondary)
%   iczero   =1 excluding zero values

% Version 2.0 - March 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

M=y_gd2(g2);
[n1 n2]=size(M);

if idim == 1
    g1=zeros(1,n2);
    for i = 1:n2
        y=M(:,i);
        if iczero == 1
            ii=find(y);
            y=y(ii);
        end
        if isempty(y)
            g1(i)=0;
        else
            g1(i)=median(y);
        end
    end
    
    g1=gd(g1);
    g1=edit_gd(g1,'ini',ini2_gd2(g2),'dx',dx2_gd2(g2));
else
    g1=zeros(1,n1);
    for i = 1:n1
        y=M(i,:);
        if iczero == 1
            ii=find(y);
            y=y(ii);
        end
        if isempty(y)
            g1(i)=0;
        else
            g1(i)=median(y);
        end
    end
    
    g1=gd(g1);
    g1=edit_gd(g1,'ini',ini_gd2(g2),'dx',dx_gd2(g2));
    if type_gd2(g2) == 2
        g1=edit_gd(g1,'x',x_gd2(g2));
    end
end
        