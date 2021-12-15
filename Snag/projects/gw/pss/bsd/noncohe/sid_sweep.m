function sids=sid_sweep(addr,ant,runame,freq,direc,wband,sband,icflat,frbase,pcheck)
% analyze data from known direction for sidereal patterns
%
%   sids=sid_sweep(addr,ant,runame,freq,direc,wband,sband,icflat,frbase)
%
%   addr,ant,runame  as for bsd_lego
%   freq    a frequency inside the bsd base band (10 Hz)
%   direc   direction structure
%   wband   sub-band division (0.5,1,2,5,10 Hz; typically 1 Hz)
%   sband   search band (in units of 1/SD; typically 10)
%   icflat  >0 flat weights (def 0)
%   frbase  basic bsd frequency (def 10)
%   pcheck  if present, substitute SD for check (no SOL)

% Snag Version 2.0 - April 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

SD=86164.09053083288;
SOL=86400;
icsol=1;

if exist('pcheck','var')
    SD=pcheck;
    icsol=0;
end

nsid=48;
enl=10;

sids.ant=ant;
sids.direc=direc;

tic

switch wband
    case 0.5
    case 1
    case 2
    case 5
    case 10
    otherwise
        sids=' *** ERROR: wband not correct';
        disp(sids)
        return
end

if ~exist('icflat','var')
    icflat=0;
end

if ~exist('frbase','var')
    frbase=10;
end

if icflat <= 0
    sidpat_rand=ana_sidpat_rand(ant,direc,0,4);
    weig=mean(abs(sidpat_rand.s(2:5,:)').^2);
    weig=weig/mean(weig);
else
    weig=ones(4,1);
end

sids.weig=weig;

nwband=frbase/wband;
frs=floor(freq/frbase)*frbase+(0:nwband-1)*frbase/nwband;
microband0=sband/SD;
nmicb=floor(wband*2/microband0);
N=nwband*nmicb;
sidsig=zeros(1,N);
sidnois=sidsig;
solsig=sidsig;
solnois=sidsig;
fr=zeros(1,N);
ii=0;
fprintf(' ---> nwband,microband0,nmicb,N: %d  %f  %d  %d\n',nwband,microband0,nmicb,N)
sids.band=floor(freq/frbase)*frbase+[0 frbase];
direc.df0=0;
direc.ddf0=0;

for i = 1:nwband
    fprintf(' --- sband %d\n',i)
    frlego=frs(i)+[0 wband-100000*eps];
    bsd_out=bsd_lego(addr,ant,runame,1,frlego,2);
    direc.f0=frs(i)+wband/2;
    bsd_corr=bsd_dopp_sd(bsd_out,direc,0);
    y=y_gd(bsd_corr);
    dt=dx_gd(bsd_corr);
    n=n_gd(bsd_corr);
    dfr0=1/(n*dt);
    if i == 1
        microband=round(microband0/(2*dfr0))*2*dfr0;
        djj=round(microband/dfr0);
        DJJ=round(djj*enl);
        t=(0:DJJ-1)'*dt*n/DJJ;
        ant1=bsd_ant(bsd_corr);
%         long=ant1.long;
        cont=cont_gd(bsd_out);
        t0=cont.t0;
%         inifr=cont.inifr;
        st0=loc_sidtim(t0,ant1.long)-direc.a/15;
        ww=zeros(1,nsid);
%         yy=ww;
%         aa=ww;
        pp=ww;
    end
    f=fft(y);%length(f)
    
    n1=length(f);
    fr1=frlego(1);
    for j = 1:nmicb
        ii=ii+1;
        fr(ii)=fr1+j*microband/2-microband/2;
        if floor(ii/1000)*1000 == ii
            dat=datetime;
            fprintf('%d  %f  %10f  %s\n',ii,fr1,fr(ii),dat)
%             py,st
        end
        jj1=floor((fr(ii)-fr1)/dfr0)+1;
        jj2=jj1+djj-1;
        if jj1 <= 0
            continue
        end
        if jj2 <= n1
            f1=f(jj1:jj2);
        else
            continue
%             f1=f(jj1:n1);
%             f1(n1+1:jj2)=0;
        end
        y1=ifft(f1,DJJ);
%         y1=y1.*exp(-1j*(fr(ii)-fr1)*2*pi*t);
        ay=abs(y1);
        py=ay.^2;
        
        st=mod(t+st0*3600,SD);
        st=floor(st*nsid/SD)+1; 
 
        for ij = 1:nsid
            i1=find(st == ij);
            pp(ij)=mean(py(i1));
%             aa(ij)=mean(ay(i1));
%             yy(ij)=mean(y1(i1));
            ww(ij)=mean(sign(ay(i1)));
        end
        jjj=isnan(pp);
        pp(jjj)=0;
        jjj=isnan(ww);
        ww(jjj)=1;
        pow=pp./ww; %figure,plot(pp),title('pp'),figure,plot(ww),title('ww'),figure,plot(pow),title('pow')
        ff=fft(pow);
%         harm=ff(1:21);
%         sidrat(ii)=sum(abs(ff(2:5)).^2/sum(abs(ff(6:21)).^2))*(16/4);
        sidsig(ii)=sum((abs(ff(2:5)).^2).*weig);
        sidnois(ii)=sum(abs(ff(6:21)).^2)/4;
        
%         --------------------------------
        
        if icsol > 0
            solt=mod(t,SOL);
            solt=floor(solt*nsid/SOL)+1; 

            for ij = 1:nsid
                i1=find(solt == ij);
                pp(ij)=mean(py(i1));
    %             aa(ij)=mean(ay(i1));
    %             yy(ij)=mean(y1(i1));
                ww(ij)=mean(sign(ay(i1)));
            end
            jjj=isnan(pp);
            pp(jjj)=0;
            jjj=isnan(ww);
            ww(jjj)=1;
            pow=pp./ww; 
            ff=fft(pow);
    %         harm=ff(1:21);
    %         sidrat(ii)=sum(abs(ff(2:5)).^2/sum(abs(ff(6:21)).^2))*(16/4);
            solsig(ii)=sum((abs(ff(2:5)).^2).*weig);
            solnois(ii)=sum(abs(ff(6:21)).^2)/4;
        end
    end
end

sids.fr=fr+microband/2;
sids.sidsig=sidsig;
sids.sidnois=sidnois;
if icsol > 0
    sids.solsig=solsig;
    sids.solnois=solnois;
end
sids.toc=toc