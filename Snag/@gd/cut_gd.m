function gout=cut_gd(gin,xsel)
% cut_gd   creates a new gd with a selection of the abscissas
%
%    gout=cut_gd(gin,xsel)
%
%   gin         input gd
%   xsel        permitted intervals (2,n)
%               can be a cell array with more xsel arrays

% Version 2.0 - January 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n=gin.n;
ini=gin.ini;
dx=gin.dx;
typ=gin.type;
capt=gin.capt;
x=x_gd(gin);
y=gin.y;

if iscell(xsel)
    nyes=length(xsel);
    xcell=xsel
    xsel=xcell{1};
else
    nyes=1;
end

strange=123875323766091/98623;
windt=0;

for ii = 1:nyes
    if ii > 1
        xsel=xcell{ii};
    end

    [n1 n2]=size(xsel);
    if n1 == 1
        xsel=xsel';
        n1=2;
        n2=1;
    end
    k1=1;
    for i = 1:n
        iok=0;
        for j = k1:n2
            if x(i) > xsel(2,j)-windt
                k1=j;
                continue
            end
            if x(i) < xsel(1,j)+windt
                break
            end
            iok=1;
        end
        if iok == 0
            y(i)=strange;
        end
    end
end

ii=find(y ~= strange);
x=x(ii);
y=y(ii);

if typ == 2 || n2 > 1
    gout=gd(y);
    gout=edit_gd(gout,'x',x,'capt',[capt ' cut'],'ini',min(x),'dx',dx );
else
    gout=gd(y);
    gout=edit_gd(gout,'capt',[capt ' cut'],'ini',min(x),'dx',dx );
end
