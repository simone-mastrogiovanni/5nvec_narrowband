function [sour stat psw gw v5sig0 v5sig45 wien]=ana_kpsour(fr0,band,gdata,gsig0,gsig45,limw,thr)
% ANA_KPSOUR  analyze known periodic source data
%
%     [sour stat psw gw v5sig0 v5sig45 wien]=ana_kpsour(fr0,gdata,gsig0,gsig45,limw,thr)
%
%   fr0      (corrected) frequency; if fr0(1)=0 uses the data in the cont structure
%   band     band for analysis around ([frmin frmax] of output frequency);
%            if only one number, half-bandwidth around f0; 0 -> default (f0+-0.05 Hz)
%   gdata    gd with the time domain data (created by a pss_recos)
%   gsig0    gd with the simulation of signal of lin pol psi=0 (by sfdb09_band2sbl); or source
%   gsig45   gd with the simulation of signal of lin pol psi=45; or antenna
%            gsig0 and gsig45 can contain (both) or a gd with the simulated
%            data, or a 5-vect, or the source and antenna structures
%   limw     limit to the Wiener filter gain (typically 3; if 0 -> no Wiener filter)
%   thr      threshold to eliminate disturbances, or an array with weights;
%            if absent, choose interactively
%
%   sour     source parameters
%   stat     statistics
%   psw      power spectrum

% Version 2.0 - December 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ST=86164.09053083288;

pars=cont_gd(gdata);
fr0a=fr0;
if fr0 == 0
    fr0a=pars.appf0;
end
fr0=mod(fr0a,1/dx_gd(gdata));

if length(band) == 1
    if band <= 0
        band=0.05;
    end
    band=[fr0-band fr0+band];
end

disp(sprintf(' fr0_input = %f, fr0_subsamp = %f  band = [%f,%f]',fr0a,fr0,band))

if ~exist('limw','var')
    limw=3;
end

icwie=1;
if ~exist('thr','var')
    icwie=0;
elseif length(thr) > 1
    icwie=2;
end

if icwie == 0
    figure,plot(real(gdata))
    pause(16);
    answ=inputdlg({'Threshold level ?'},'Threshold level',1,{'0'});
    thr=eval(answ{1});
end

if icwie < 2
    [gdata deld]=rough_clean(gdata,-thr,thr,60);
end

if limw > 0
    [gw nois wien]=ps_wiener(gdata,4.5,limw);
%     deld=deld.*wien.';
    figure,plot(deld),grid on,hold on,plot(wien,'r')
    title('Wiener Filter')
    check_wien=sum(wien)/length(wien);
    fprintf(' A--> Check NWF : %f  (should be 1) \n',check_wien)
else
    wien=deld'.*check_nonzero(gdata);
    figure,plot(deld),grid on,
end

gw=gdata.*wien;
v5dat=compute_5comp(gw,fr0);

if isa(gsig0,'gd')
    v5sig0=compute_5comp(gsig0,fr0,wien);
    v5sig45=compute_5comp(gsig45,fr0,wien);
elseif isstruct(gsig0)
elseif isnumeric(gsig0)
    v5sig0=gsig0;
    v5sig45=gsig45;
else
end

res=4;
psw=gd_pows(gw,'resolution',res,'window',2);
figure,semilogy(psw); grid on, hold on %,semilogy(psw,'r.')
title('Power Spectrum')
mm1=min(psw);
mm2=max(psw);
for i = -2:2
    semilogy([fr0+i*1/ST fr0+i*1/ST],[mm1 mm2],'r');
end

yps=y_gd(psw);
dfr=dx_gd(psw);
% n=n_gd(psw);
% dt=dx_gd(gdata);
% 
% N=round(ceil(res*n*dt/ST)*ST/dt);
% 
% DF=1/(N*dt);
% dn=round(1/(DF*ST));
% 
% n4=round(n-4*dn);
% n2=round(n4*0.975/2);
% fprintf('dn,n4,n2 = %d  %d  %d \n',dn,n4,n2)
% 
% ypsa=abs(yps(1:n2)).^2;
% ypsa(n2+1:2*n2)=abs(yps(n4-n2+1:n4)).^2;
% spnois=mean(ypsa);

dsf=round(1/(ST*dfr));
i1=max(round(band(1)/dfr),1);
i2=min(round(band(2)/dfr),n_gd(psw));
yps=yps(i1:i2);
i3=max(round(fr0/dfr)-3*dsf,1)-i1+1;
i4=max(round(fr0/dfr)+3*dsf,1)-i1+1;

[sour stat matfil]=estimate_psour(v5dat,v5sig0,v5sig45);

sour.dat5=v5dat;
sour.sigp5=v5sig0;
sour.sigc5=v5sig45;
sour.ndat5=norm(v5dat);
sour.nsigp5=norm(v5sig0);
sour.nsigc5=norm(v5sig45);
sour.pars=pars;
sour.v5(1)=norm(v5sig0);
sour.v5(2)=norm(v5sig45);
sour.v5(3)=dot(v5sig0,v5sig45)/(sour.v5(1)*sour.v5(2));
fprintf(' v5sig norms: %g %g  corr = %g %gi \n',sour.v5,imag(sour.v5(3)))

stat.maxsp=max(yps);% i3,i4,length(yps),length(yps)
yps=[yps(1:i3).' yps(i4:length(yps)).'];
stat.msp=mean(yps);
stat.sdsp=std(yps);
stat.snrsp=(stat.maxsp-stat.msp)/stat.sdsp;
xhi=(0:0.1:20)*stat.msp;
hi=histc(yps,xhi);
figure,semilogy(xhi,hi),grid on
title('Power Spectrum Distribution')

spnois=mean(yps);

dt=dx_gd(gw);
n=n_gd(gw);
N=ceil(ceil(n/ST)*ST);
newamp=sqrt(N/n);
y=y_gd(gw)*newamp;
y(n+1:N)=((n+1):N)*0;
gw=edit_gd(gw,'y',y);
psw=gd_pows(gw,'resolution',res,'window',2);
y=y_gd(psw);
dfr=dx_gd(psw);
i1=max(round(band(1)/dfr),1);
i2=min(round(band(2)/dfr),n_gd(psw));
y=y(i1:i2);
psw=edit_gd(psw,'y',y,'ini',(i1-1)*dfr);
dsf=round(1/(ST*dfr));
i3=max(round(fr0/dfr)-3*dsf,1)-i1+1;
i4=max(round(fr0/dfr)+3*dsf,1)-i1+1;
yf=(y+rota(y,dsf)+rota(y,dsf*2)+rota(y,dsf*3)+rota(y,dsf*4))/5;
yf=rota(yf,-2*dsf);
sf=edit_gd(psw,'y',yf);

figure,semilogy(psw),grid on,hold on,semilogy(psw,'r.'),semilogy(sf,'g')
title('Input data power spectrum (b) and Rough Spectral Filter (g)')

mm1=min(psw);
mm2=max(psw);
for i = -2:2
    semilogy([fr0+i*1/ST fr0+i*1/ST],[mm1 mm2],'m')
end

stat.maxsf=max(yf);
yf=[yf(1:i3).' yf(i4:length(yps)).'];
stat.msf=mean(yf);
stat.sdsf=std(yf);
stat.snrsf=(stat.maxsf-stat.msf)/stat.sdsf;
xhi=(0:0.1:20)*stat.msf;
hi=histc(yf,xhi);
figure,semilogy(xhi,hi),grid on
title('Rough Spectral Filter Distribution')

sig(1,:)=v5sig0;
sig(2,:)=v5sig45;
[out cohe inif DF yy sdfilt2]=band_ana_ps(gw,fr0,sig,band,4);
stat.snr(1)=sqrt(abs(sour.hp)^2/sdfilt2(1));
stat.snr(2)=sqrt(abs(sour.hc)^2/sdfilt2(2));
stat.snr(3)=sqrt(sour.h0^2/sdfilt2(3));
stat.snr(4)=sqrt(sour.h0^2/sdfilt2(4));
stat.sdfilt2=sdfilt2;
stat.noise=sqrt(spnois);