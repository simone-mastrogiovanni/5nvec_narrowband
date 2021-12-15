function graph_5vec(v,ic,lintyp)
% plot 5vect
%
%   v    5-vect
%   ic   1 normalized, 2 log amplitude

% vion 2.0 - August 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza Univity - Rome

if ~exist('ic','var')
    ic=1;
end
if ~exist('lintyp','var')
    lintyp='';
end

switch ic
    case 1
        v=v./abs(v);
    case 2
        lv=log10(abs(v));
        lv=lv-min(lv)+1;
        v=lv.*v./abs(v);
end

plot([0,real(v(1))],[0,imag(v(1))],['r',lintyp]),hold on
plot([0,real(v(2))],[0,imag(v(2))],['b',lintyp])
plot([0,real(v(3))],[0,imag(v(3))],['k',lintyp])
plot([0,real(v(4))],[0,imag(v(4))],['c',lintyp])
plot([0,real(v(5))],[0,imag(v(5))],['m',lintyp]),grid on
x=cos(0:0.1:2*pi);
y=sin(0:0.1:2*pi);
plot(x,y,'g'),title('5-vect angles (-2 r, -1 b, 0 k, 1 c, 2 m)')