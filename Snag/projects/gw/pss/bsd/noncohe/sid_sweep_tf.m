function sidstf=sid_sweep_tf(addr,ant,runame,freq,direc,sband,nSD,outband)
% time-frequency refinement of sid_sweep candidates
%
%   sids=sid_sweep_tf(addr,ant,runame,freq,direc,sband)
%
%   addr,ant,runame  as for bsd_lego
%              if addr is a bsd, use it
%              if ant is a table, use it
%   freq     candidate frequency;
%             if 2-dim freq(2), spin-down
%             if 3-dim freq(3) is the semiband; def semiband 0.5 Hz
%   direc    direction structure
%   sband    search band (in units of 1/SD; typically 10)
%              if present sband(2) = interlacing delay (in 1/SD)
%   nSD      time resolution in SD (typically integer); if 2-dim,
%             nSD(2) interlacing shift (def nSD(2)=nSD(1)/2)
%             nSD(3) resolution enhancement (def 2)
%   outband  output sub-band

% Snag Version 2.0 - May 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

SD=86164.09053083288;
SOL=86400;

nsid=96;
enl=10;

if length(nSD) == 1
    kSD=nSD/2;
    res=2;
elseif length(nSD) == 2
    kSD=nSD(2);
    nSD=nSD(1);
    res=2;
else
    kSD=nSD(2);
    res=nSD(3);
    nSD=nSD(1);
end

if length(freq) == 1
    freq(2)=0;
end

if length(freq) <= 2
    freq(3)=0.5;
end

semiband=freq(3);

sidstf.fr0=freq(1);
sidstf.sd0=freq(2);
sidstf.semiband=semiband;
sidstf.direc=direc;
sidstf.sband=sband;
sidstf.nSD=nSD;
sidstf.kSD=kSD;
sidstf.res=res;

if length(sband) > 1
    interl=sband(2);
    sband=sband(1);
else
    interl=sband/2;
end

tic

sidpat_rand=ana_sidpat_rand(ant,direc,0,4);
weig=mean(abs(sidpat_rand.s(2:5,:)').^2);
weig=weig/mean(weig);

sidstf.weig=weig;

band=[freq(1)-freq(3) freq(1)+freq(3)];

direc.f0=freq(1);
direc.df0=freq(2);
direc.ddf0=0; 

if is_bsd(addr) < 0
    sidstf.bsd_out=bsd_lego(addr,ant,runame,1,band,2);
    cont=cont_gd(sidstf.bsd_out);
else
    cont=cont_gd(addr);
    sidstf.bsd_out=addr;
end

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


if ~exist('outband','var')
    outband=band;
end

bsd_corr=bsd_dopp_sd(sidstf.bsd_out,direc);
sidstf.bsd_corr=bsd_corr;
y=y_gd(bsd_corr);
dt=dx_gd(bsd_corr);
n=n_gd(bsd_corr);
ccont=ccont_gd(bsd_corr);
sidstf.ant=ccont.ant;
t0=ccont.t0;
isec=0;
inifr=ccont.inifr;

sidstf.dt=dt;
sidstf.n=n;
sidstf.ant=ccont.ant;
sidstf.inifr=inifr;
sidstf.band=band;
T0=dt*n;

T1=nSD*SD;
n1=round(T1/dt);
DT=kSD*SD;
sidstf.DT=DT;
k1=round(DT/dt);
i0=round(mod(diff_mjd(epoch2000,t0),T1)/dt);
sidstf.i0=i0;
yy(i0+1:i0+n)=y;
sidstf.n=n;
sidstf.nprel=n+i0;      % prelonged length
t0prel=t0-i0*dt/86400;  % prelonged beginning time
sidstf.t0=t0;
sidstf.t0prel=t0prel;
lfft=round(n1*res);
dfr=1/(T1*res);
sidstf.lfft=lfft;
sidstf.dfr=dfr;
M=floor((n-n1)/k1)+1;

microband0=sband/SD;
microband=round(microband0/(2*dfr))*2*dfr;
sidstf.microband=microband;

i1=round((band(1)-inifr)/dfr)+1;
i2=round((band(2)-inifr)/dfr);

sidstf.nt=M;
tims=zeros(1,M);

djj=round(microband/dfr);
DJJ=round(djj*enl);
dt1=T1/DJJ;
t=(0:DJJ-1)*dt1;
% t=(0:DJJ-1)*dt*n/DJJ;
ant1=bsd_ant(bsd_corr);
sidstf.djj=djj;
sidstf.DJJ_lenifft=DJJ;

st0=loc_sidtim(t0,ant1.long)-direc.a/15;
ww=zeros(1,nsid);
pp=ww;

fr1=band(1);
DFR=interl/SD;
N=round((band(2)-band(1))/DFR)+1;
sidstf.nf=N;
N1=round((outband(1)-band(1))/DFR)+1;
sidstf.N1=N1;
N2=round((outband(2)-band(1))/DFR)+1;
sidstf.N2=N2;
NN=N2-N1+1;

sidsig=zeros(M,NN);
fr=(0:N-1)*DFR+fr1;
ii=0; 
adhocbias=1.5*DFR;

for i = 1:M
    tims(i)=adds2mjd(t0prel,isec)+T1/(2*86400);
    fprintf('  t index > %d   %s \n',i,mjd2s(tims(i)))
    isec=isec+DT;
    y1=yy((i-1)*k1+1:(i-1)*k1+n1);
    f=fft(y1,lfft);
    f=f(i1:i2); 
    lenf=length(f);
    j0=N1-1;
    for j = N1:N2
        ii=ii+1;
        jj1=floor((fr(j)-fr1-adhocbias)/dfr)+1;
        jj2=jj1+djj-1;
        if jj1 <= 0
            continue
        end
        if jj2 <= lenf
            f1=f(jj1:jj2);
        else
            continue
        end
        if floor(ii/2000)*2000 == ii
            dat=datetime;
            fprintf('%s %d  %d  %10f  %s\n',ant1.name,ii,i,fr(j),dat)
        end
        y1=ifft(f1,DJJ); 
%         y1=y1.*exp(-1j*(fr(j)-fr1)*2*pi*t); 
        ay=abs(y1);
        py=ay.^2;

        st=mod(t+st0*3600,SD);
        st=floor(st*nsid/SD)+1; 

        for ij = 1:nsid
            ii=find(st == ij);
            pp(ij)=mean(py(ii));
            ww(ij)=mean(sign(ay(ii)));
        end
        jjj=isnan(pp);
        pp(jjj)=0;
        jjj=isnan(ww);
        ww(jjj)=1;
        pow=pp./ww;
        ff=fft(pow);
        sidsig(i,j-j0)=sum((abs(ff(2:5)).^2).*weig);
    end
end

sidstf.tims=tims;
sidstf.fr=fr+microband/2;
sidsig=fillmissing(sidsig,'constant',0);
sidsig=gd2(sidsig);
sidsig=edit_gd2(sidsig,'ini',tims(1),'dx',DT/86400,'ini2',outband(1),'dx2',DFR);
sidstf.sidsig=sidsig;
sidstf.toc=toc