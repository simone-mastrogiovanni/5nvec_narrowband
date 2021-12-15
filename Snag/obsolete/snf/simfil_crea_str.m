function sfil=simfil_crea_str(filnam,type,access,init,samtim,nx,ny,capt)
% crea_simfil_str  creates a "simple file" structure
%
%    sfil=simfil_crea_str(filnam,type,access,init,samtim,nx,ny,capt)
%
%   sfil     "simple file" structure
%
%   filnam   file name
%   type     1 = text, 2 = bin 
%   access   r = read, w = write 
%   init     initial abscissa
%   samtim   sample time
%   nx
%   ny       = 0, not defined
%   caption  80 characters
%
%   fil      file id (output)

% Version 1.0 - September 2000
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 2000  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sfil.filnam=filnam;
sfil.type=type;
sfil.access=access;
sfil.init=init;
sfil.samtim=samtim;
sfil.nx=nx;
sfil.ny=ny;
sfil.caption=char(zeros(1,80));
sfil.caption(1:length(capt))=capt;
sfil.fil=0;