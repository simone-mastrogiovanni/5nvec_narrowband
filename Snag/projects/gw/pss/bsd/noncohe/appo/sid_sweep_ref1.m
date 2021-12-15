function sidsref=sid_sweep_ref(addr,ant,runame,freq,direc,sband)
% refinement of sid_sweep candidates
%
%   sids=sid_sweep_ref(addr,ant,runame,freq,direc,sband)
%
%   addr,ant,runame  as for bsd_lego
%           if addr is a bsd, use it
%           if ant is a table, use it
%   freq    candidate frequency;
%            if 2-dim freq(2), spin-down
%            if 3-dim freq(3) is the semiband; def semiband 0.5 Hz
%   direc   direction structure
%   sband   search band (in units of 1/SD; typically 10)
%             if present sband(2) = interlacing delay (in 1/SD)
%             sband(3) = enlargement factor (def enl=10, min recommended 5)

% Snag Version 2.0 - May 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

SD=86164.09053083288;
SOL=86400;
icsol=1;

nsid=24;
wnois=min(floor(nsid/2),21)
enl=10;

if length(freq) == 1
    freq(2)=0;
end

if length(freq) <= 2
    freq(3)=0.5;
end
wband=freq(3)*2;

sidsref.fr0=freq(1);
sidsref.dfr0=freq(2);
sidsref.direc=direc;
sidsref.sband=sband;

if length(sband) > 1
    interl=sband(2);
    if length(sband) > 2
        enl=sband(3);
    end
    sband=sband(1);
else
    interl=sband/2;
end

sidsref.interl=interl;
sidsref.enl=enl;

sidsref.direc=direc;

tic

sidpat_rand=ana_sidpat_rand(ant,direc,0,4);
weig=mean(abs(sidpat_rand.s(2:5,:)').^2);
weig=weig/mean(weig);

sidsref.weig=weig;

band=[freq(1)-freq(3) freq(1)+freq(3)];

microband0=sband/SD;
N=floor(wband*sband/(microband0*interl));
sidsref.N=N;
sidsig=zeros(1,N);
sidnois=sidsig;
solsig=sidsig;
solnois=sidsig;
% fr=zeros(1,N);
% ii=0;
fprintf(' ---> microband0,N:  %f  %d \n',microband0,N)
sidsref.band=band;
direc.f0=freq(1);
direc.df0=freq(2);
direc.ddf0=0; 

if is_bsd(addr) < 0
    sidsref.bsd_out=bsd_lego(addr,ant,runame,1,band,2);
else
    cont=ccont_gd(addr);
    bandbsdin=cont.inifr+[0,cont.bandw];
    sidsref.bsd_out=addr;
    if band(1) < bandbsdin(1)
        fprintf(' *** band(1) changed from %f to %f \n',band(1),bandbsdin(1))
        band(1)=bandbsdin(1);
    end
    if band(2) > bandbsdin(2)
        fprintf(' *** band(2) changed from %f to %f \n',band(2),bandbsdin(2))
        band(2)=bandbsdin(2);
    end
end
bsd_corr=bsd_dopp_sd(sidsref.bsd_out,direc);
sidsref.bsd_corr=bsd_corr;
y=y_gd(bsd_corr);
dt=dx_gd(bsd_corr);
n=n_gd(bsd_corr);
dfr0=1/(n*dt);
ccont=ccont_gd(bsd_corr);
sidsref.ant=ccont.ant;
inifr=ccont.inifr;
dfr=1/(n*dt);
sidsref.inifr=inifr;
sidsref.dfr=dfr;
i1=round((band(1)-inifr)/dfr)+1;
i2=round((band(2)-inifr)/dfr);

microband=round(microband0/(2*dfr0))*2*dfr0;
sidsref.microband=microband;
djj=round(microband/dfr0);
DJJ=round(djj*enl);
sidsref.djj=djj;
sidsref.DJJ=DJJ;
t=(0:DJJ-1)'*dt*n/DJJ;
ant1=bsd_ant(bsd_corr);
cont=cont_gd(sidsref.bsd_out);
t0=cont.t0;

st0=loc_sidtim(t0,ant1.long)-direc.a/15;
ww=zeros(1,nsid);
pp=ww;

f=fft(y);
f=f(i1:i2);

n1=length(f);
fr1=band(1);
DFR=interl/SD;
sidsref.DFR=DFR;
fr=fr1+(0:N-1)*DFR;
for j = 1:N
%     ii=ii+1;
%     fr(ii)=fr1+(j-1)*DFR;
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
    y1=y1.*exp(-1j*(fr(j)-fr1)*2*pi*t);
    ay=abs(y1);
    py=ay.^2;

    st=mod(t+st0*3600,SD);
    st=floor(st*nsid/SD)+1; 

    for ij = 1:nsid
        i1=find(st == ij);
        pp(ij)=mean(py(i1));
        ww(ij)=mean(sign(ay(i1)));
    end
    jjj=isnan(pp);
    pp(jjj)=0;
    jjj=isnan(ww);
    ww(jjj)=1;
    pow=pp./ww; 
    ff=fft(pow);
    sidsig(j)=sum((abs(ff(2:5)).^2).*weig);
    sidnois(j)=mean(abs(ff(6:wnois)).^2);

%         --------------------------------

    if icsol > 0
        solt=mod(t,SOL);
        solt=floor(solt*nsid/SOL)+1; 

        for ij = 1:nsid
            i1=find(solt == ij);
            pp(ij)=mean(py(i1));
            ww(ij)=mean(sign(ay(i1)));
        end
        jjj=isnan(pp);
        pp(jjj)=0;
        jjj=isnan(ww);
        ww(jjj)=1;
        pow=pp./ww; 
        ff=fft(pow);
        solsig(j)=sum((abs(ff(2:5)).^2).*weig);
        solnois(j)=mean(abs(ff(6:wnois)).^2);
    end
end

sidsref.fr=fr+microband/2;
sidsref.sidsig=sidsig;
sidsref.sidnois=sidnois;
if icsol > 0
    sidsref.solsig=solsig;
    sidsref.solnois=solnois;
end
sidsref.toc=toc