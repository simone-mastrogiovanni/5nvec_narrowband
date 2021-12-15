function pathnew=cpath(pathold)
% correct the dirsep in the path

% Version 2.0 - October 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

ch0=dirsep();

ch1='\';
k1=strfind(pathold,ch1);

ch2='/';
k2=strfind(pathold,ch2);

pathnew=pathold;

pathnew(k1)=ch0;
pathnew(k2)=ch0;