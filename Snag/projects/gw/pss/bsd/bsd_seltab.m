function tab_out=bsd_seltab(tab,ii,varargin)
% bsd table selection
%
%   tab       master table
%   ii        selection indices 
%   varargin  couples of variables (item, values)

% Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if isstruct(tab)
    n=length(tab);
    
    for i = 1:n
        name{i}=tab(i).name;
        path{i}=tab(i).path;
        antenna{i}=tab(i).antenna;
        run{i}=tab(i).run;
        cal{i}=tab(i).cal;
        t_ini(i)=tab(i).t_ini;
        t_fin(i)=tab(i).t_fin;
        fr_ini(i)=tab(i).fr_ini;
        fr_fin(i)=tab(i).fr_fin;
        filMbyt(i)=tab(i).filMbyt;
    end

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
    
    tab_out=struct('name',name,'path',path,'antenna',antenna,'run',run,'cal',cal);
    ltab=length(t_ini);
    for i = 1:ltab
        tab_out(i).t_ini=t_ini(i);
        tab_out(i).t_fin=t_fin(i);
        tab_out(i).fr_ini=fr_ini(i);
        tab_out(i).fr_fin=fr_fin(i);
        tab_out(i).filMbyt=filMbyt(i);
    end

    nn=length(varargin);

    if nn > 0
        for i = 1:2:nn
            nam=varargin{i};
            val=varargin{i+1};
            for j = 1:length(val)
                eval(['tab_out(' num2str(j) ').' nam '=val(j);'])
            end
        end
    end
else
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
end