function [xx ii]=sel_absc(typ,y,x,onecho)
%SEL_ABSC  interactive abscissa selection
%
% The input data can be two arrays (x,y) or a gd
% The output is a (n,2) array containing n couples of beginning-end abscissa
%
%  typ     0 linear, 1 logx, 2 logy, 3 logx,y
%   y      ordinate or gd or mp
%   x      abscissa if y is ordinate, or 0
%  onecho  > 0 -> single choice

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if exist('x')
    if length(x) == 1
        x=x_gd(y);
        y=y_gd(y);
    end
else
    x=x_gd(y);
    y=y_gd(y);
end

if ~exist('onecho','var')
    onecho=0;
end

n=0;
figure
switch typ
    case 0
        plot(x,y), hold on, grid on
    case 1
        semilogx(x,y), hold on, grid on
    case 2
        semilogy(x,y), hold on, grid on
    case 3
        loglog(x,y), hold on, grid on
end
cont=1;

while cont==1
	x2=ginput(2);
	n=n+1;
	xx(n,1)=x2(1,1);
	xx(n,2)=x2(2,1);
	i1=indexofarr(x,xx(n,1));
	i2=indexofarr(x,xx(n,2));
    ii(n,1)=i1;
    ii(n,2)=i2;
switch typ
    case 0
        plot(x(i1:i2),y(i1:i2),'r')
    case 1
        semilogx(x(i1:i2),y(i1:i2),'r')
    case 2
        semilogy(x(i1:i2),y(i1:i2),'r')
    case 3
        loglog(x(i1:i2),y(i1:i2),'r')
end
    cont=0;
    if onecho <= 0
        button=questdlg('Do you want to choose a period ?');
        if strcmp(button,'Yes')
            cont=1;
        end
    end
end

