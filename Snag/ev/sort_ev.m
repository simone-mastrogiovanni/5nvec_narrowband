function eo=sort_ev(ei)
%SORT_EV  sorts events (ev or ew) on starting time

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isfield(ei,'nev')
    t=ei.t;
	[t,t]=sort(t);
    
    eo.t=ei.t(t);
    eo.tm=ei.t(t);
    eo.a=ei.a(t);
    eo.cr=ei.cr(t);
    eo.a2=ei.a2(t);
    eo.l=ei.l(t);
    eo.fl=ei.fl(t);
    eo.ch=ei.ch(t);
    eo.ci=ei.ci(t);
    
    eo.nev=ei.nev;
else
	for i = 1:length(ei)
        t(i)=ei(i).t;
	end
	[t,t]=sort(t);
	eo=ei(t);
end
