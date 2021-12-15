function [gx gy]=genmean_gd2(gin2,typ)
% GENMEAN_GD2  computes general mean on each dimension
%
%    [gx gy]=genmean_gd2(gin2,typ)
%
%   typ    1 mean
%          2 standard deviation
%          3 log mean
%          4 harmonic mean
%
%   gx     mean along y
%   gy     mean along x

% Version 2.0 - April 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

switch typ 
    case 1
        gx=mean(gin2.y');
        gy=mean(gin2.y);
    case 2
        gx=std(gin2.y');
        gy=std(gin2.y);
    case 3
        gx=exp(mean(log(gin2.y')));
        gy=exp(mean(log(gin2.y)));
    case 4
        [nx ny]=size(gin2.y);
        gx=1./mean(1./gin2.y');
        gy=1./mean(1./gin2.y);
end

gx=gd(gx);
gx=edit_gd(gx,'ini',gin2.ini,'dx',gin2.dx,'capt',['x projection of ' gin2.capt]);
if gin2.type == 2
    gx=edit_gd(gx,'x',gin2.x);
end

gy=gd(gy);
gy=edit_gd(gy,'ini',gin2.ini2,'dx',gin2.dx2,'capt',['y projection of ' gin2.capt]);