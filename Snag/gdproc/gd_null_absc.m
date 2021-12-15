function gd_null_absc(typ,g,gdoutname)
%SEL_ABSC  abscissa selection (high precision)
%
% The input data can be a gd or array
% The output is a gd or array
%
%  typ         0 linear, 1 logx, 2 logy, 3 logx,y
%  g           ordinate or gd or array
%  gdoutname   name of the output gd
% 

% Version 2.0 - March 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

global x9399 y9399 typ9399 g9399 fid9399
typ9399=typ;

if isa(g,'gd')
    x=x_gd(g);
    y=y_gd(g);
else
    y=g;
    x=0:length(y)-1;
end
len=length(y);
x9399=x;
y9399=y; 
g9399=g;

tstr=snag_timestr(now);
fid9399=fopen([gdoutname '_gd_null_' tstr '.txt'],'w');

fprintf(fid9399,'Operating on %s gd or array\r\n',inputname(2));
fprintf(fid9399,'Producing %s gd or array\r\n\r\n',gdoutname);
fprintf(fid9399,'  tini  tfin -  iini ifin: \r\n\r\n');

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
   [gdoutname '=end_null_9399;']);

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

gout=g;