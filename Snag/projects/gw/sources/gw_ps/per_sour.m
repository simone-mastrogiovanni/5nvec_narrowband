function ps=per_sour(fr,pos,pol,epoch)
% periodic source structure
%
%    ps=per_sour(fr,pos,pol)
%
%    fr     frequency and derivatives
%    pos    [a,d,v_a,v_d]
%    pol    [eta psi]
%    epoch  [pepoch,fepoch] (def 57388)
%
%  if one of fr, pos or pol is a ps structure, use those par and the other
%  two can change. Note that h is not explicity set. 
%  Angles are in deg.

% Snag version 2.0 - December 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('epoch','var')
    epoch=[57388,57388];
end
if length(pos) == 2
    pos(3)=0;
    pos(4)=0;
end
ps.name='generic';
if isstruct(fr)
    ps=fr;
    ps.a=pos(1);
    ps.d=pos(2);
    ps.v_a=pos(3);
    ps.v_d=pos(4);
    ps.pepoch=epoch(1);
    ps.eta=pol(1);
    ps.psi=pol(2);
elseif isstruct(pos)
    ps=pos;
    ps.f0=fr;
    ps.fepoch=epoch(2);
    ps.eta=pol(1);
    ps.psi=pol(2);
elseif isstruct(pol)
    ps=pol;
    ps.a=pos(1);
    ps.d=pos(2);
    ps.v_a=pos(3);
    ps.v_d=pos(4);
    ps.pepoch=epoch(1);
    ps.f0=fr;
    ps.fepoch=epoch(2);
else
    ps.a=pos(1);
    ps.d=pos(2);
    ps.v_a=pos(3);
    ps.v_d=pos(4);
    ps.pepoch=epoch(1);
    ps.f0=fr;
    ps.fepoch=epoch(2);
    ps.eta=pol(1);
    ps.psi=pol(2);
end

if ~isfield(ps,'h')
    ps.h=1;
end