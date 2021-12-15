function gdstr=gd2struct(gin)
% par_gd  extracts basic parameters

% Version 2.0 - January 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

gdstr.n=gin.n;
gdstr.ini=gin.ini;
gdstr.dx=gin.dx;
gdstr.type=gin.type;
gdstr.capt=gin.capt;
gdstr.cont=gin.cont;

gdstr.y=gin.y;
if gin.type == 2
    gdstr.x=gin.x;
end