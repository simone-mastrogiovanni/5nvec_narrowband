function gout2=cut_gd2(gin2,ix,iy,icphys)
% CUT_GD2  extract a sub-gd2 or gd
%
%   gin2    input gd
%   ix      [ixmin ixmax]; if absent, interactive x and y
%   iy      [iymin iymax]; absent if ix absent, otherwise if absent, interactive
%   icphys  =1 x and y physical, not indices; def 0

% Version 2.0 - April 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[nx,ny]=size(gin2.y);

if ~exist('ix','var')
    answ=inputdlg({'init' 'end'},'x dim index',1,{num2str(1) num2str(nx)});
    ix(1)=eval(answ{1});
    ix(2)=eval(answ{2});
end

if ~exist('iy','var')
    answ=inputdlg({'init' 'end'},'y dim index',1,{num2str(1) num2str(ny)});
    iy(1)=eval(answ{1});
    iy(2)=eval(answ{2});
end

if ~exist('icphys','var')
    icphys=0;
end

icgd=0;
if ix(1) == ix(2) | iy(1) == iy(2)
    icgd=1;
end

if icphys == 1
    x=x_gd2(gin2);
    nx=length(x);
    ini2=ini2_gd2(gin2);
    dx2=dx2_gd2(gin2);
    n2=m_gd2(gin2);
    xs=ix;
    ys=iy;
    ix(1)=1;
    for i = 1:nx-1
        if xs(1) >= x(i) && xs(1) < x(i+1)
            ix(1)=i;
        end
        if xs(2) >= x(i) && xs(2) < x(i+1)
            ix(2)=i;
        end
    end
    if xs(1) >= x(nx)
        ix(1)=nx;
    end
    if xs(2) >= x(nx)
        ix(2)=nx;
    end

    iy(1)=round((ys(1)-ini2)/dx2)+1;
    iy(2)=round((ys(2)-ini2)/dx2)+1;
    if iy(1) < 1
        iy(1)=1;
    end
    if iy(1) > n2
        iy(1)=1;
    end
    if iy(2) < 1
        iy(2)=1;
    end
    if iy(2) > n2
        iy(2)=n2;
    end
end

if icgd == 0
    gout2=gin2;
    gout2.y=gin2.y(ix(1):ix(2),iy(1):iy(2));
    gout2.n=(ix(2)-ix(1)+1)*(iy(2)-iy(1)+1);
    gout2.m=(iy(2)-iy(1)+1);
    x=x_gd2(gin2);
    gout2.ini=x(ix(1));
    if gin2.type == 2
        gout2.x=gin2.x(ix(1):ix(2));
    end
    gout2.ini2=gin2.ini2+(iy(1)-1)*gin2.dx2;
    gout2.capt=['extracted from ' gin2.capt];
else
    y=gin2.y(ix(1):ix(2),iy(1):iy(2));
    y=y(:);
    gout2=gd(y);
    if iy(1) == iy(2)
        x=x_gd2(gin2);
        gout2=edit_gd(gout2,'type',gin2.type,'ini',x(ix(1)),'dx',gin2.dx);
        if gin2.type == 2
            gout2=edit_gd(gout2,'x',gin2.x(ix(1):ix(2)));
        end
    else
        gout2=edit_gd(gout2,'ini',gin2.ini2+(iy(1)-1)*gin2.dx2,'dx',gin2.dx2);
    end
    gout2=edit_gd(gout2,'capt',['extracted from ' gin2.capt]);
end
