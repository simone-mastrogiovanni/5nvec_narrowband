function sids=sid_sweep(addr,ant,runame,freq,direc,wband,sband,frbase)
% analyze data from known direction for sidereal patterns
%
%   sids=sid_sweep(tab,direc,wband,wband0)
%
%   addr,ant,runame  as for bsd_lego
%   freq    a frequency inside the bsd base band (10 Hz)
%   direc   direction structure
%   wband   sub-band division (0.5,1,2,5,10 Hz; typically 1 Hz)
%   sband   search band (in units of 1/SD; typically 10)
%   frbase  basic bsd frequency (def 10)

% Snag Version 2.0 - April 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

SD=86164.09053083288;
nsid=48;

sids.ant=ant;

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

if ~exist('frbase','var')
    frbase=10;
end

nwband=frbase/wband;
frs=floor(freq/frbase)*frbase+(0:nwband-1)*frbase/nwband;
microband=sband/SD;
nmicb=floor(wband*2/microband);
N=nwband*nmicb;
sidrat=zeros(1,N);
fr=sidrat;
ii=0;
ii1=1;
fprintf(' ---> nwband,microband,nmicb,N: %d  %f  %d  %d\n',nwband,microband,nmicb,N)
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
        djj=floor(microband/dfr0)+1;
        t=(0:djj-1)'*dt*n/djj;
        ant1=bsd_ant(bsd_corr);
        long=ant1.long;
        cont=cont_gd(bsd_out);
        t0=cont.t0;
        inifr=cont.inifr;
        st0=loc_sidtim(t0,ant1.long)-direc.a/15;
        ww=zeros(1,nsid);
        yy=ww;
        aa=ww;
        pp=ww;
    end
    f=fft(y);%length(f)
    
    n1=length(f);
    fr1=frlego(1);
    for j = 1:nmicb
        ii=ii+1;
        fr(ii)=fr1+j*microband/2;
        if floor(ii/1000)*1000 == ii
            dat=datetime;
            fprintf('%d  %f  %10f  %s %f\n',ii,fr1,fr(ii),dat,sidrat(ii-1))
%             py,st
        end
        jj1=floor((fr(ii)-fr1)/dfr0)+1;
        jj2=jj1+djj-1; 
        if jj2 <= n1
            f1=f(jj1:jj2);
        else
            continue
%             f1=f(jj1:n1);
%             f1(n1+1:jj2)=0;
        end
        y1=ifft(f1);
        y1=y1.*exp(-1j*(fr(ii)-fr1)*2*pi*t);
        
        st=mod(t+st0*3600,SD);
        st=floor(st*nsid/SD)+1; 

        ay=abs(y1);
        py=ay.^2; 
        for ij = 1:nsid
            i1=find(st == ij);
            pp(ij)=mean(py(i1));
            aa(ij)=mean(ay(i1));
            yy(ij)=mean(y1(i1));
            ww(ij)=mean(sign(ay(i1)));
        end
        jjj=isnan(pp);
        pp(jjj)=0;
        jjj=isnan(ww);
        ww(jjj)=1;
        pow=pp./ww; %figure,plot(pp),title('pp'),figure,plot(ww),title('ww'),figure,plot(pow),title('pow')
        ff=fft(pow);
        sidrat(ii)=sum(abs(ff(2:5)).^2/sum(abs(ff(6:21)).^2))*(16/4);
    end
    ii1=ii+1;
end

sids.fr=fr;
sids.sidrat=sidrat;
sids.toc=toc