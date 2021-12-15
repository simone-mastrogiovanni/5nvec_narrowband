function sp=peakmap_spec(pm,fr)
% 
%    sp=peakmap_spec(pm,fr)
%
%   pm   peakmap structure 
%         .PM  (nt nf) sparse matrix
%         .t   times of the FFTs
%         .f   frequencies of the FFTs
%   fr   [frmin frmax res] or frequencies

% Version 2.0 - September 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

t=pm.t;
nt=length(t);
f=pm.f;
nf=length(f);

T=t(nt)-t(1);
dfr=1/(T*fr(3));
if length(fr) == 3
    fr=fr(1):dfr:fr(2);
end
