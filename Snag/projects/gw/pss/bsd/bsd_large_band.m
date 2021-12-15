function out=bsd_large_band(tab,tin,tfi,addr,outdt)
% reduced bsd_largerband
%
%    out=bsd_large_band(tab,tin,tfi,outdt)
%
%   tab     bsd table 
%   tin     initial time (mjd)
%   tfi     final time
%   addr    (used in case of table) path without dirsep; otherwise ''
%   outdt   (if present) output file sampling time

% Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

file=file_tab_bsd(addr,tab);
nfiles=length(file)';
nofiles=0;
chtab=check_bsd_table(tab);
frange=chtab.frange;
trange=chtab.trange;

sband=frange(2)-frange(1);
basefr=frange(1);
    
nfiles,nofiles,disp('entry in large_band')

for i = nfiles:-1:1
    [pathstr,name,ext]=fileparts(file{i});
    load(file{i});
    if i == 1
        eval(['in=' name ';'])
    end
    eval(['cont=cont_gd(' name ');']);
    t0=cont.t0;
    fmin=cont.inifr;
    fmax=cont.inifr+cont.bandw
    if i == nfiles
        outdt0=1/sband;
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
    l1=round((fmin-basefr)/df)+1;
    l2=l1+ll-1;
    AA(l1:l2)=yy;
    eval(['clear ' name])
end 

AA=ifft(AA); 
cont.t0=tin;
cont.inifr=basefr;
cont.bandw=1/outdt0;
cont.durcreation=0;
cont.timcreation=datetime();
cont.frange=frange;
if exist('trange','var')
    cont.trange=trange;
end
cont=rmfield(cont,'mi_abs_lev');
out=gd(AA);
out=edit_gd(out,'dx',outdt,'cont',cont);

out=bsd_zeroholes(out,in);