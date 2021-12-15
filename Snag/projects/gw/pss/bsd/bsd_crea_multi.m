function [bsds,pars]=bsd_crea_multi(bsdsstr,band,icpar)
% assemble bsds for more antennas
%
%   [bsds,pars]=bsd_crea_multi(bsdsstr,band,icpar)
%
%   bsdsstr  bsd search structure array (with addr,ant,runame  as for bsd_lego)
%   band     band
%   icpar    =1 force parallelization (def 0)

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('icpar','var')
    icpar=0;
end

n=length(bsdsstr);

for k = 1:n
    kk=num2str(k);
    addr=bsdsstr(k).addr;
    ant=bsdsstr(k).ant;
    runame=bsdsstr(k).runame;
    eval(['bsds{' kk '}=bsd_lego(addr,ant,runame,1,band,1);'])
end

for k = 1:n
    [~,pars1]=is_bsd(bsds{k});
    if k == 1
        tin=pars1.tin;
        tfi=pars1.tfi;
    else
        tin=min(tin,pars1.tin);
        tfi=max(tfi,pars1.tfi);
    end
    pars.ant{k}=pars1.ant;
end

pars.tin=tin;
pars.tfi=tfi;
pars.epoch=floor((tin+tfi)/2);

if icpar > 0
    for k = 1:n
        bsds{k}=cut_bsd(bsds{k},[tin,tfi],1);
    end
end