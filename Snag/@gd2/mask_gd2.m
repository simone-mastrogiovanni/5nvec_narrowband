function gout2=mask_gd2(gin2,xs,ys,const)
% MASK_GD2  masks with constant value a sub-matrix
%
%   gin2   input gd
%   xs     [xmin xmax]; if absent, interactive x and y
%   ys     [ymin ymax]; absent if ix absent, otherwise if absent, interactive
%   const  constant (default 0)

% Version 2.0 - January 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('const','var')
    const=0;
end
    
[nx,ny]=size(gin2.y);
x=x_gd2(gin2);
x2=x2_gd2(gin2);

if ~exist('xs','var')
    answ=inputdlg({'init' 'end'},'x dim index',1,{num2str(min(x)) num2str(max(x))});
    xs(1)=eval(answ{1});
    xs(2)=eval(answ{2});
end

if ~exist('ys','var')
    answ=inputdlg({'init' 'end'},'y dim index',1,{num2str(min(x2)) num2str(max(x2))});
    ys(1)=eval(answ{1});
    ys(2)=eval(answ{2});
end

x=x_gd2(gin2);
nx=length(x);
ini2=ini2_gd2(gin2);
dx2=dx2_gd2(gin2);
n2=m_gd2(gin2);
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

M=y_gd2(gin2);

M(ix(1):ix(2),iy(1):iy(2))=const;ix,iy

gout2=edit_gd2(gin2,'y',M);