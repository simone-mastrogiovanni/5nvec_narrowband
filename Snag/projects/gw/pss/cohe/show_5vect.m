function v5n=show_5vect(v5,icnorm,col)
% SHOW_5VECT  shows a 5-vect
%
%    show_5vect(v5,icnorm,col)
%
%    v5       the 5-vect
%    icnorm   > 0 normalized
%    col      color string (def 'b')

% Version 2.0 - May 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('icnorm','var')
    icnorm=0;
end

v5n=v5/norm(v5);
if icnorm > 0
    v5=v5n;
end

if ~exist('col','var')
    col='b';
end

plot([0 real(v5(1))],[0 imag(v5(1))],col),hold on,grid on,text(real(v5(1)),imag(v5(1)),'-2')
plot([0 real(v5(2))],[0 imag(v5(2))],col),text(real(v5(2)),imag(v5(2)),'-1')
plot([0 real(v5(3))],[0 imag(v5(3))],[':' col],'LineWidth',2),text(real(v5(3)),imag(v5(3)),'0')
plot([0 real(v5(4))],[0 imag(v5(4))],col),text(real(v5(4)),imag(v5(4)),'+1')
plot([0 real(v5(5))],[0 imag(v5(5))],col),text(real(v5(5)),imag(v5(5)),'+2')
set(gca,'DataAspectRatio',[1.1 1.1 1],...
        'PlotBoxAspectRatio',[1 1 1])