function plot_unc(g,nonew,styl)
% PLOT_UNC  uncertainty plot
%
%      plot_unc(g,styl)
%
%  g      input gd
%  nonew  = 1 -> no new figure
%  styl   style

% Version 2.0 - July 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('nonew','var')
    nonew=0;
end
if ~exist('styl','var')
    styl=1;
end
ampmark=12;
amplin=2;
red='r';
if styl == 2
    ampmark=6;
    amplin=1;
    red='k';
end

x=x_gd(g);
y=y_gd(g);
unc=unc_gd(g);
uncx=uncx_gd(g);
n=n_gd(g);

if nonew ~= 1
    figure
end

plot(x,y,[red '.'],'MarkerSize',ampmark), hold on, grid on

for i = 1:n
    plot([x(i) x(i)],[y(i)-unc(i) y(i)+unc(i)],'LineWidth',amplin);
    plot([x(i)-uncx(i) x(i)+uncx(i)],[y(i) y(i)],'LineWidth',amplin);
end

plot(x,y,[red '.'],'MarkerSize',ampmark), hold on
