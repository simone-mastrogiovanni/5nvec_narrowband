function out=bsd_largerband(list,tin,tfi,addr,outdt)
% synthetic signal from more BSDs
%
%    out=bsd_largerband(list,tin,tfi,outdt)
%
%   list    bsd table or file with bds files list (NO SPACES)
%           (if a row of the list begins with *, it is not considered)
%   tin     initial time (mjd)
%   tfi     final time
%   addr    (used in case of table) path without dirsep; otherwise ''
%   outdt   (if present) output file sampling time

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[ok,ictab]=istable1(list);

if ok
    file=file_tab_bsd(addr,list);
    nfiles=length(file)';
    nofiles=0;
    chtab=check_bsd_table(list);
    frange=chtab.frange;
    trange=chtab.trange;
else
    fidlist=fopen(list,'r');
    nfiles=0;
    nofiles=0;
    frange=[0 1/dx_gd(in)];

    while (feof(fidlist) ~= 1)
        str=fgetl(fidlist);
        str1=str(1);
        if strcmp(str1,'*')
            nofiles=nofiles+1;
            fprintf('  %s  NOT CONSIDERED \n',str);
            continue
        else
            nfiles=nfiles+1;
            file{nfiles}=str;
            fprintf('  %s \n',str);
        end
    end
end
    
nfiles,nofiles

for i = nfiles:-1:1
    file{i}=cpath(file{i});
    [pathstr,name,ext]=fileparts(file{i});
    load(file{i});
    eval(['cont=cont_gd(' name ');']);
    t0=cont.t0;
    fmin=cont.inifr;
    fmax=cont.inifr+cont.bandw
    if i == nfiles
        outdt0=1/fmax;
        if exist('outdt','var')
            if outdt > outdt0
                fprintf(' outdt > %f min sampling; CHANGED \n')
                outdt=outdt0;
            end
        else
            outdt=outdt0;
        end
        eval(['cont=cont_gd(' name ');']);
        eval(['dt=dx_gd(' name ');']);
        Nband=round(dt/outdt);
        Dt=(tin-t0)*86400;
        k1=floor(Dt/dt)+1;
        ll=ceil((tfi-tin)*86400/dt);
        ll=round(ll/4)*4;
        k2=k1+ll-1;
        LL=ll*Nband;
        AA=zeros(1,LL);
        fprintf('taken data indices %d %d, pieces length in,out %d, %d  dt = %f \n',k1,k2,ll,LL,outdt)
    end
    eval(['y=y_gd(' name ');']);
    yy=y(k1:k2);
    yy=fft(yy);
    df=1/(dt*ll);
    l1=round(fmin/df)+1;
    l2=l1+ll-1;
    AA(l1:l2)=yy;
    eval(['clear ' name])
end 

AA=ifft(AA)*Nband; % corrected 25-10-18
cont.t0=tin;
cont.inifr=0;
cont.bandw=1/outdt0;
cont.durcreation=0;
% cont.timcreation=datetime();
cont.timcreation=datestr(now);
cont.frange=frange;
if exist('trange','var')
    cont.trange=trange;
end
cont=rmfield(cont,'mi_abs_lev');
out=gd(AA);
out=edit_gd(out,'dx',outdt,'cont',cont);
