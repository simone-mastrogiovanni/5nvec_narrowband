function [n ini dx m ini2 dx2 type capt]=par_gd2(gin2)
% par_gd  extracts basic parameters

% Version 2.0 - January 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n=gin2.n;
ini=gin2.ini;
dx=gin2.dx;

m=gin2.m;
ini2=gin2.ini2;
dx2=gin2.dx2;

type=gin2.type;
capt=gin2.capt;