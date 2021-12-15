function gout=oper_2_gd2(g1,g2,oper)
% synchronized operation on 2 gd2
%
%    g1,g2    the 2 gd2
%    oper     operation: '+','*','/'

% Snag Version 2.0 - May 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if g1.dx ~= g2.dx
    fprintf('different dx: 1 -> %f  2 -> %f \n',g1.dx,g2.dx)
    return
end

if g1.dx2 ~= g2.dx2
    fprintf('different dx2: 1 -> %f  2 -> %f \n',g1.dx2,g2.dx2)
    return
end

gout=g1;

y1=g1.y;
y2=g2.y;

inix=round((g2.ini-g1.ini)/g1.dx);
iniy=round((g2.ini2-g1.ini2)/g1.dx2);

fin1a=inix+g1.n/g1.m;
fin1b=inix+g2.n/g2.m;
fin2a=iniy+g1.m;
fin2b=iniy+g2.m;

lunx=min(fin1a,fin1b);
if lunx < 0
    disp('no x intersection')
    return
end
luny=min(fin2a,fin2b);
if luny < 0
    disp('no y intersection')
    return
end

if inix < 0
    y1=g1.y(-inix+1:lunx,:);
    y2=g2.y;
    gout.ini=g2.ini;
elseif inix > 0
    y2=g1.y(inix+1:lunx,:);
    y1=g1.y;
else
    y1=g1.y;
    y2=g2.y;
end

if iniy < 0
    y1=g1.y(:,-iniy+1:luny);
    y2=g2.y;
    gout.ini2=g2.ini2;
elseif iniy > 0
    y2=g1.y(:,iniy+1:luny);
    y1=g1.y;
else
    y1=g1.y;
    y2=g2.y;
end

switch oper
    case '+'
        y1=y1+y2;
    case '*'
        y1=y1.*y2;
    case '/'
        y1=y1./y2;
end

gout.y=y1;