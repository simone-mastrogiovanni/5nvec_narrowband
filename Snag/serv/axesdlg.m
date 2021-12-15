function axesdlg(h)
%AXESDLG  interactively sets limits on axes with handle h 

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

promptcg={'x min','x max','y min','ymax'};
xlimits=get(h,'Xlim');
ylimits=get(h,'Ylim');
x1=sprintf('%d',xlimits(1));
x2=sprintf('%d',xlimits(2));
y1=sprintf('%d',ylimits(1));
y2=sprintf('%d',ylimits(2));
defacg={x1,x2,y1,y2};
answcg=inputdlg(promptcg,'x,y limits',1,defacg);
xx=[str2num(answcg{1}),str2num(answcg{2})];
yy=[str2num(answcg{3}),str2num(answcg{4})];
set(h,'Xlim',xx,'Ylim',yy);
