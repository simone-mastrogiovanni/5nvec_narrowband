function par=scatter_color(x,y,zs,zc,par)
% color scatter plot
%
%  x,y  coordinates
%  zs   first amplitude (size; =0 no size)
%  zc   second amplitude (color; =0 no color)
%  par  parameters (see default)

% Snag Version 2.0 - September 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni - ornella.juliana.piccinni@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('par','var')
    par.foreground=1;
    par.size=100;
    par.minsize=1;
    par.cm=cool;
    par.holdon=0;
    par.marker='o';
end
if ~isfield(par,'foreground')
    par.foreground=1;
end
if ~isfield(par,'size')
    par.size=100;
end
if ~isfield(par,'minsize')
    par.minsize=1;
end
if ~isfield(par,'cm')
    par.cm=cool;
end
if ~isfield(par,'holdon')
    par.holdon=0;
end
if ~isfield(par,'marker')
    par.marker='o';
end

if length(zs) == 1
    if zs > 0
        par.size=zs;
    end
    if par.holdon == 0
        figure
    else
        hold on
    end
    scatter(x,y,par.size,zc,par.marker,'filled'),grid on
    if par.holdon == 0
        colorbar
    end
    colormap(par.cm);
    return
end
if length(zc) == 1
    if par.holdon == 0
        figure
    else
        hold on
    end
    scatter(x,y,zs,par.marker,'filled'),grid on
    if par.holdon == 0
        colorbar
    end
    colormap(par.cm);
    return
end

if par.foreground == 1
    [zs,i]=sort(zs,'descend');
end
x=x(i);
y=y(i);
zc=zc(i);
zs=par.size*(zs-min(zs))/(max(zs)-min(zs))+1;

if par.holdon == 0
    figure
else
    hold on
    disp('holdon')
end
scatter(x,y,zs,zc,par.marker,'filled')
if par.holdon == 0
    colorbar
end
colormap(par.cm);
grid on
