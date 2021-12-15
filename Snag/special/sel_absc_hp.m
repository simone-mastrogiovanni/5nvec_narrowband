function sel_absc_hp(typ,y,x)
%SEL_ABSC  abscissa selection (high precision)
%
% The input data can be two arrays (x,y) or a gd
% The output is a (n,2) array containing n couples of beginning-end abscissa
%
%  typ    0 linear, 1 logx, 2 logy, 3 logx,y
%   y     ordinate or gd or mp
%   x     abscissa if y is ordinate, or 0
% 
% The output is in the global variables ini9399 and end9399 and in the file
%  fil9399

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

global x9399 y9399 typ9399
typ9399=typ;

if exist('x')
    if length(x) == 1
        x=x_gd(y);
        y=y_gd(y);
    end
else
    x=x_gd(y);
    y=y_gd(y);
end
x9399=x;
y9399=y;
len=length(x9399);

h0 = figure('Color',[1 1 0.7], ...
   'Name','gd Plot',...
	'Position',[232 288 560 420]);
h1axgdpl = axes('Parent',h0, ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);

msgbox({'Data Selection Menu procedure:' ' ' ...
        ' - select "Start period" and choose the starting point' ...
        ' - select "Stop period" and choose the stop point' ...
        ' - iterate the first two step for all periods' ...
        ' - select End selection' ' ' ...
        'If a start is followed by another start, it is cancelled' ...
        'If a stop is followed by another stop, it is cancelled' ...
        'If one begins with a stop, the first start is the very beginning' ...
        'If one ends the selection with a start, the last stop is the end of data' ...
        'You can zoom at will between steps.'}) 

global ini9399 end9399 n9399 nend9399;
ini9399(1:100)=x(1);
end9399(1:100)=x(len);
n9399=0;
nend9399=0;

contmenuh=uimenu(h0,'label','Data Selection');

uimenu(contmenuh,'label','Start period','callback',...
   'start_sel_9399;');
uimenu(contmenuh,'label','Stop period','callback',...
   'stop_sel_9399;');
uimenu(contmenuh,'label','End selection','callback',...
   'end_sel_9399;');

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
