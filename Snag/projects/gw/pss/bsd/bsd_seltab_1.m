function tab_out=bsd_seltab(tab,ii,varargin)
% bsd table selection
%
%   tab       master table
%   ii        selection indices 
%   varargin  couples of variables (item, values)

% Version 2.0 - November 2016 remake December 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

name=tab.name;
path=tab.path;
antenna=tab.antenna;
run=tab.run;
cal=tab.cal;
t_ini=tab.t_ini;
t_fin=tab.t_fin;
fr_ini=tab.fr_ini;
fr_fin=tab.fr_fin;
filMbyt=tab.filMbyt;

name=name(ii);
path=path(ii);
antenna=antenna(ii);
run=run(ii);
cal=cal(ii);
t_ini=t_ini(ii);
t_fin=t_fin(ii);
fr_ini=fr_ini(ii);
fr_fin=fr_fin(ii);
filMbyt=filMbyt(ii);

nn=length(varargin);

if nn > 0
    str='tab_out=table(name,path,antenna,run,cal,t_ini,t_fin,fr_ini,fr_fin,filMbyt';
    for i = 1:2:nn
        nam=varargin{i};
        eval([nam '=varargin{i+1};'])
        eval([nam '=' nam '(:)'])
        str=[str ',' nam];
    end
    str=[str ');']
    eval(str)
else
    tab_out=table(name,path,antenna,run,cal,t_ini,...
    t_fin,fr_ini,fr_fin,filMbyt);
end
