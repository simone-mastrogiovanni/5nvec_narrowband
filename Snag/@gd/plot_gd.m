function handl=plot_gd(pstr,varargin)
%PLOT_GD plots a gd
%
%  handl=plot_gd(pstr,varargin)
%
%  pstr             plot structure (or simply 0,1,2,3 for plot,semilogx,semilogy,loglog)
%      .typ         0,1,2,3 for 'normal','logx','logy','logxy'
%      .xlim        [minx,maxx]
%      .ylim        [miny,maxy]
%      .title
%      .xlabel
%      .ylabel
%      .color(N,3)  color triplets (0->1)
%      .marker(N)   '.','o','x','+',...' ' -> no
%  varargin         input gds (N gds)
%
%  handl            figure handle

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

N=length(varargin);

tcol=zeros(N,3);
for i = 1:N
    tcol(i,:)=rotcol(i);
    marker(i)=' ';
end
title0=0;
xlabel0=0;
ylabel0=0;
xlim0=0;
ylim0=0;

typ=pstr;
if isstruct(pstr)
    typ=0;
    if isfield(pstr,'typ')
        typ=pstr.typ;
    end
    if isfield(pstr,'color')
        tcol=pstr.color;
    end
    if isfield(pstr,'marker')
        marker=pstr.marker;
    end
    if isfield(pstr,'label')
        title0=pstr.title;
    end
    if isfield(pstr,'xlabel')
        xlabel0=pstr.xlabel;
    end
    if isfield(pstr,'ylabel')
        ylabel0=pstr.ylabel;
    end
    if isfield(pstr,'xlim')
        xlim0=pstr.xlim;
    end
    if isfield(pstr,'ylim')
        ylim0=pstr.ylim;
    end
end

handl=figure;

for i =1:N
    g=varargin{i};
    n(i)=g.n;
    switch typ
        case 0
            plot(x_gd(g),g.y,marker,'color',tcol(i,:));
        case 1
            semilogx(x_gd(g),g.y,marker,'color',tcol(i,:));
        case 2
            semilogy(x_gd(g),g.y,marker,'color',tcol(i,:));
        case 3
            loglog(x_gd(g),g.y,marker,'color',tcol(i,:));
    end
    hold on
end

if length(xlim0) > 1
    xlim(xlim0);
end
if length(ylim0) > 1
    ylim(ylim0);
end
if ischar(title0)
    title(title0);
end
if ischar(xlabel0)
    xlabel(xlabel0);
end
if ischar(ylabel0)
    ylabel(ylabel0);
end

zoom on, grid on