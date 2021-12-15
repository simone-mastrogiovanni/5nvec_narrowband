function [eta amp]=iota2eta(iota,graph)
% IOTA2ETA  conversion from iota to epsilon for the periodic gw
%
%   iota   angle of the rotation axis respect the visual line (degrees)
%   graph  number of repetition: graphical
%
%   eta    the ratio between the axes of the polarization ellipse
%   amp    amplitude gain with iota
%
%   ATTENTION : the amplitude of the wave changes with iota !

% Version 2.0 - June 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

eta=2*cos(iota*pi/180)./(1+(cos(iota*pi/180)).^2);

amp=sqrt(((1+cos(iota*pi/180).^2)/2).^2+cos(iota*pi/180).^2);

if exist('graph','var')
    if graph <= 0
        return
    end
    alf=(0:360)*pi/180;
    eta1=2*cos(iota*pi/180)./(1+(cos(iota*pi/180)).^2);
    
    figure
    
    for i = 0:2:360*graph
        plot([0 cos(i*pi/180)],[0 sin(i*pi/180)],'r'),hold on
        a=(1+(cos(i*pi/180)).^2)/2;
        b=cos(i*pi/180);
        plot(a*cos(alf)+2.8,b*sin(alf)),hold off;
        xlim([-1.2 4])
        ylim([-1.2 1.2])
        grid on
        pause(0.1)
    end
end