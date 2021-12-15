function evch=crea_evch(chstr,evstr)
%CREA_EVCH  creates the evch structure

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if isfield(evstr,'nev')
	evch.ch=chstr;
	evch.ew=evstr;
	evch.n=evstr.nev;
else
	evch.ch=chstr;
	evch.ev=evstr;
	evch.n=length(evstr);
end