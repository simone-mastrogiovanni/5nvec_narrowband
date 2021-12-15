function cand1=new_cand(cand0,epoch0,epoch1)
% raw epoch update for cands
%
%    cand0    original cands
%    epoch0   original epoch
%    epoch1   new epoch

% Snag Version 2.0 - March 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

cand1=cand0;
DT=diff_mjd(epoch0,epoch1);

cand1(1,:)=cand1(1,:)+cand1(4,:)*DT;