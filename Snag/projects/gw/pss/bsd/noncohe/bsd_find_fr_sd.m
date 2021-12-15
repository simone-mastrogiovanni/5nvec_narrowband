function [out,bsd_ftr]=bsd_find_fr_sd(bsd_out,cand,frs,sds,par)
% search for frequency and spin-down
%
%   bsd_out   input data bsd
%   cand      candidate structure (like a pulsar)
%   frs       frequency band ([min max], of the order of ~10/SD)
%   sds       spin-down band ([min max])
%   par       search parameters
%      .nl    raw search reduction factor (def 5)
%      .nh    refined search enhancement factor (def 2)
%      .refb  refinement band (in natural units, def 5)
%      .enl   enlargement factor for bsd_trim (def 10)

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

SD=86164.09053083288;
fsid=1/SD;

if ~exist('par','var')
    par=struct;
end

if ~isfield(par,'nl')
    par.nl=5;
end
if ~isfield(par,'nh')
    par.nh=2;
end
if ~isfield(par,'refb')
    par.refb=5;
end
if ~isfield(par,'enl')
    par.enl=10;
end

enl=par.enl;

n=n_gd(bsd_out);
dt=dx_gd(bsd_out);
Tobs=n*dt;

out.Tobs=Tobs;
out.dfr=1/Tobs;
dsd0=1/Tobs^2;
out.dsd0=dsd0;
out.pars=[par.nl par.nh par.refb];

dsd1=dsd0*par.nl;
sds1=sds(1):dsd1:sds(2);
ns1=length(sds1);

filmax1=zeros(1,ns1);
jj=0;

for a = sds1
    jj=jj+1;
    [bsd_corr,frcorr]=bsd_dopp_sd(bsd_out,cand,[a,0]);

    [bsd_ftr,out]=bsd_ftrim(bsd_corr,frs,enl,1);
    f5v=find_5vec(out.sp);
    filmax1(jj)=f5v.max;
    fprintf(' %d/%d  %e  %f\n',jj,ns1,a,f5v.max)
end

[mm,imax]=max(filmax1);
sd1=sds1(imax);
out.sd1=sd1;
out.maxfilt1=filmax1;

dsd2=dsd0/par.nh;
sds2=sd1-par.refb*dsd0:dsd2:sd1+par.refb*dsd0;
ns2=length(sds2);

filmax2=zeros(1,ns2);
jj=0;

for a = sds2
    jj=jj+1;
    [bsd_corr,frcorr]=bsd_dopp_sd(bsd_out,cand,[a,0]);

    [bsd_ftr,out]=bsd_ftrim(bsd_corr,frs,enl,1);
    f5v=find_5vec(out.sp);
    filmax2(jj)=f5v.max;
    fprintf(' %d/%d  %e  %f\n',jj,ns2,a,f5v.max)
end

[mm,imax]=max(filmax2);
sd2=sds2(imax);
out.maxfilt2=filmax2;

figure,plot(sds1,filmax1),grid on,hold on,plot(sds1,filmax1,'gx')
plot(sds2,filmax2,'r.')

[bsd_corr,frcorr]=bsd_dopp_sd(bsd_out,cand,[sd2,0]); 
[bsd_ftr,out]=bsd_ftrim(bsd_corr,frs,enl);
f5v=find_5vec(out.sp);

plot_lines(f5v.frs5v,out.sp,'m')

out.f5v=f5v;

out.fr=f5v.frs5v(3);
out.sd=sd2;
