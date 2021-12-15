function [yn,pars]=is_bsd(in)
% type of bsd 
%
%    yn=is_bsd(in)
%
%    in    gd 
%
%    yn = 0  no, simple gd
%       = 1  basic bsd
%       = 2  complete primary
%       = 3  complete secondary
%       = 4  complete oper present
%       = 5  complete decorated
%       =-1  not a gd

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S.D'Antonio and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

yn=0;
if ~isa(in,'gd')
    yn=-1;
    return
end
cont=cont_gd(in);
dt=dx_gd(in);
n=n_gd(in);
pars.dt=dt;
pars.n=n;
names=fieldnames(cont);

% basic

nam={'t0';'inifr';'bandw'};
c=intersect(nam,names);
if length(c) == 3
    yn=1;
else
    return
end

pars.tin=cont.t0;
pars.tfi=adds2mjd(pars.tin,(n-1)*dt);
pars.frin=cont.inifr;
pars.frfi=cont.inifr+cont.bandw;

% complete primary

nam={'v_eq';'p_eq';'ant';'cal'};
c=intersect(nam,names);
if length(c) == 4
    yn=2;
else
    return
end

pars.ant=cont.ant;
pars.run=cont.run;
pars.cal=cont.cal;

% complete oper

% nam={'oper'};
% c=intersect(nam,names);
% if length(c) == 1
%     yn=4;
% else
%     return
% end

% complete decorated and/or zeros

nam={'tfstr'};
c=intersect(nam,names);
if length(c) == 1
    yn=5
    
    if isfield(cont.tfstr,'zeros')
        pars.zeros=cont.tfstr.zeros;
    end
end

