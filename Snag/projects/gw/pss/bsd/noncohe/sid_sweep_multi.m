function [sids,bsdsstr]=sid_sweep_multi(bsdsstr,freq,direc,sband,iout,nsid)
% multi antenna sid_sweep candidates
%
%   sids=sid_sweep_multi(bsdsstr,freq,direc,sband,nsid)
%
%   bsdsstr  bsd search structure array (with addr,ant,runame  as for bsd_lego)
%             if it is a cell array containing bsds, use them
%   freq     candidate frequency;
%             if 2-dim freq(2), spin-down
%             if 3-dim freq(3) is the semiband; def semiband 0.5 Hz
%   direc    direction structure
%   sband    search band (in units of 1/SD; typically 10)
%             if present sband(2) = interlacing delay (in 1/SD)
%             sband(3) = enlargement factor (def enl=10, min recommended 5)
%   iout    if present, serial numbers (J) for outputting data (output channels)
%   nsid     number of sidereal bins (def 24); if negative, check with random numbers

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

% icout=0;
% if exist('iout','var')
%     icout=1;
%     nout=length(iout); nout
%     datout=cell(1,nout);
% end

if ~exist('iout','var')
    iout=0;
end

if ~exist('nsid','var')
    nsid=24;
end

if length(freq) == 1
    freq(2)=0;
end

if length(freq) <= 2
    freq(3)=0.5;
end
wband=freq(3)*2;

n=length(bsdsstr);
if ~iscell(bsdsstr)
    for k = 1:n
        kk=num2str(k);
        addr=bsdsstr(k).addr;
        ant=bsdsstr(k).ant;
        runame=bsdsstr(k).runame;
        band=freq(1)+[-0.5 0.5];
        eval(['bsdsstr1{' kk '}=bsd_lego(addr,ant,runame,1,band,2);'])
    end
    bsdsstr=bsdsstr1;
end

for k = 1:n
    [~,pars]=is_bsd(bsdsstr{k});
    if k == 1
        tin=pars.tin;
        tfi=pars.tfi;
    else
        tin=min(tin,pars.tin);
        tfi=max(tfi,pars.tfi);
    end
    sidpars.ant{k}=pars.ant;
end

sidpars.tin=tin;
sidpars.tfi=tfi;
sidpars.epoch=floor((tin+tfi)/2);

if length(sband) > 1
    interl=sband(2);
    if length(sband) > 2
        enl=sband(3);
    end
    sband=sband(1);
else
    interl=sband/2;
end

direc.f0=freq(1);
direc.df0=freq(2);
direc.ddf0=0;

for k = 1:n
    fprintf('\n    %s    %s \n\n',sidpars.ant{k},direc.name)
    [bsds_corr{k},frcorr]=bsd_dopp_sd(bsdsstr{k},direc);
    bsds_corr{k}=cut_bsd(bsds_corr{k},[tin,tfi],1);
    sids{k}=sid_sweep_base(bsds_corr{k},freq,direc,sband,iout,nsid);
    sids{k}.frcorr=frcorr;
end

sids{n+1}=sidpars;


function sids1=sid_sweep_base(bsd_corr,freq,direc,sband,iout,nsid)

icout=0;
if iout(1) > 0
    icout=1;
    nout=length(iout); 
    datout=cell(1,nout);
end

iccheck=0;
if nsid < 0
    iccheck=1;
    nsid=-nsid;
end

SD=86164.09053083288;
enl=10;
wnois=min(floor(nsid/2),21);

if length(sband) > 1
    interl=sband(2);
    if length(sband) > 2
        enl=sband(3);
    end
    sband=sband(1);
else
    interl=sband/2;
end
wband=freq(3)*2;

ant=bsd_ant(bsd_corr);

sidpat_rand=ana_sidpat_rand(ant,direc,0,4);
weig=mean(abs(sidpat_rand.s(2:5,:)').^2);
weig=weig/mean(weig);

band=[freq(1)-freq(3) freq(1)+freq(3)];

cont=cont_gd(bsd_corr);
bandbsdin=cont.inifr+[0,cont.bandw];
if band(1) < bandbsdin(1)
    fprintf(' *** band(1) changed from %f to %f \n',band(1),bandbsdin(1))
    band(1)=bandbsdin(1);
end
if band(2) > bandbsdin(2)
    fprintf(' *** band(2) changed from %f to %f \n',band(2),bandbsdin(2))
    band(2)=bandbsdin(2);
end
biasfr=band(1)-bandbsdin(1);
    
microband0=sband/SD;
N=floor(wband*sband/(microband0*interl));

y=y_gd(bsd_corr);
if iccheck > 0
    y=y.*randn(length(y),1); 
    [isz1,isz2]=size(y);
    fprintf('randomization, %d %d \n',isz1,isz2);
end
dt=dx_gd(bsd_corr);
n=n_gd(bsd_corr);
dfr0=1/(n*dt);
cont=cont_gd(bsd_corr);
sids1.ant=cont.ant;
inifr=cont.inifr;
dfr=1/(n*dt);
sids1.inifr=inifr;
sids1.dfr=dfr;
i1=round((band(1)-inifr)/dfr)+1;
i2=round((band(2)-inifr)/dfr);

sids1.weig=weig;
sids1.wnois=wnois;

microband=round(microband0/(2*dfr0))*2*dfr0;
sids1.microband=microband;
djj=round(microband/dfr0);
DJJ=round(djj*enl);
sids1.nfr_mb=djj;
sids1.Nfr_mb=DJJ;
t=(0:DJJ-1)'*dt*n/DJJ;
cont=cont_gd(bsd_corr);
t0=cont.t0;

st0=loc_sidtim(t0,ant.long)-direc.a/15;
ww=zeros(1,nsid);
pp=ww;

zer=cont.tfstr.zeros/86400;
vin=ones(1,DJJ);
cover=1-zero_pers(vin,0,t(2)-t(1),zer)';

st=mod(t+st0*3600,SD);
st=floor(st*nsid/SD)+1;

for ij = 1:nsid
    ii=find(st == ij);
    ww(ij)=mean(cover(ii));
end

jjj=isnan(ww);
ww(jjj)=1;
sids1.ww=ww;

f=fft(y);
f=f(i1:i2);

n1=length(f);
fr1=band(1);
DFR=interl/SD;
sids1.DFR=DFR;
fr=fr1+(0:N-1)*DFR;
sidsig=zeros(1,N);
sidnois=zeros(1,N);
jj=zeros(1,N);

for j = 1:N
    if floor(j/1000)*1000 == j
        dat=datetime;
        fprintf('%d  %f  %10f  %s\n',j,fr1,fr(j),dat)
    end
    jj1=floor((fr(j)-fr1)/dfr0)+1;
    jj2=jj1+djj-1;
    if jj1 <= 0
        continue
    end
    if jj2 <= n1
        f1=f(jj1:jj2);
    else
        continue
    end
    y1=ifft(f1,DJJ);
%     y1=y1.*exp(-1j*(fr(j)-fr1)*2*pi*t);
    y1=y1.*cover;
    py=abs(y1).^2; 

    for ij = 1:nsid
        ii=st == ij;
        pp(ij)=mean(py(ii));
    end
    jjj=isnan(pp);
    pp(jjj)=0;
    pow=pp./ww;
    jjj=pow>0;
    mu=mean(pow(jjj));
    jjj=pow==0;
    pow(jjj)=mu;
    ff=fft(pow); 
    sidsig(j)=sum((abs(ff(2:5)).^2).*weig);
    sidnois(j)=mean(abs(ff(6:wnois)).^2);
    jj(j)=1;
    
    if icout
        DT=t(2)-t(1);
        lwsid=round(SD/DT);
        sidfilt=ones(1,lwsid)/lwsid;
        for ik = 1:nout
            if iout(ik) == j
                dat=struct();
                dat.bin=j;
                dat.y1=y1;
                dat.dt=DT;
                dat.cover=cover;
                dat.st=st;
                dat.fsid=filter(sidfilt,1,y1);
                dat.wsid=filter(sidfilt,1,cover);
                ii=find(dat.wsid > 0.3333);
                dat.fwsid=dat.fsid*0;
                dat.fwsid(ii)=dat.fsid(ii)./dat.wsid(ii);
                dat.pow=pow;
                datout{ik}=dat;
            end
        end
    end

end

jj=find(jj);

sids1.fr=fr(jj)+microband/2;
sids1.sidsig=sidsig(jj);
sids1.sidnois=sidnois(jj);
if icout
    sids1.datout=datout;
end