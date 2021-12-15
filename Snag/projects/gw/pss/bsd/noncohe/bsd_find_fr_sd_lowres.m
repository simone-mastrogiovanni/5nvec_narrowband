function [out,bsd_ftr]=bsd_find_fr_sd_lowres(bsd_out,nper,cand,frs,sds,par)
% search for frequency and spin-down
%
%   bsd_out   input data bsd
%   nper      number of period to divide; if exist, nper(2) is the min non zero perc
%              of the original to allow analysis (def 0.5)
%   cand      candidate structure (like a pulsar)
%   frs       frequency band ([min max], of the order of ~10/SD)
%   sds       spin-down band ([min max])
%   par       search parameters
%      .nl    raw search reduction factor (def 5)
%      .nh    refined search enhancement factor (def 2)
%      .refb  refinement band (in natural units, def 5)
%      .enl   enlargement factor for bsd_trim

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

tic
SD=86164.09053083288;
fsid=1/SD;

nzperc2=0.5;
if length(nper) > 1
    nzperc2=nper(2);
    nper=nper(1);
end

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

oo=zero_percent(bsd_out);
out.zeroperc0=oo.zeroperc;
nN=floor(n/nper);
TobsN=nN*dt;

out.Tobs=Tobs;
out.dfr=1/Tobs;
dsd0=1/Tobs^2;
out.dsd0=dsd0;
out.nper=nper;
out.TobsN=TobsN;
out.dfrN=1/TobsN;
dsd0N=1/TobsN^2;
out.dsd0N=dsd0N;

out.pars=[par.nl par.nh par.refb];

dsd1=dsd0N*par.nl;
sds1=sds(1):dsd1:sds(2);
out.sds1=sds1;
ns1=length(sds1);

filmax1=zeros(1,ns1);
ii=0;
i1=1;

fprintf('\n --- First step %d periods of %d sd samples \n sd band %e - %e\n\n',nper,ns1,sds(1),sds(2))

for i = 1:nper
    bsd_out1=cut_bsd(bsd_out,[i1,i1+nN-1]*dt);
    i1=i1+nN;
    oo=zero_percent(bsd_out1);
    if oo.zeroperc < out.zeroperc0*nzperc2
        continue
    end
    ii=ii+1;
    fprintf(' chunk %d/%d  ok %d  %f on %f \n',i,nper,ii,oo.zeroperc,out.zeroperc0*nzperc2)
    jj=0;
    for a = sds1
        jj=jj+1;
        [bsd_corr,frcorr]=bsd_dopp_sd(bsd_out1,cand,[a,0]);

        [bsd_ftr,outrim]=bsd_ftrim(bsd_corr,frs,enl,1);
        if jj == 1 & ii == 1
            sp=zeros(ns1,length(y_gd(outrim.sp)));
            sp0=outrim.sp;
        end
        sp(jj,:)=sp(jj,:)+y_gd(outrim.sp)';
    end
end

sp=sp;
figure,plot(sp');
out.sps=sp;
jj=0;
for a = sds1
    jj=jj+1;
    sp1=edit_gd(sp0,'y',sp(jj,:));
    f5v=find_5vec(sp1);
    filmax1(jj)=f5v.max;
    fprintf(' %d/%d  %e  %f\n',jj,ns1,a,f5v.max)
end

[mm,imax]=max(filmax1);
sd1=sds1(imax);
out.sd1=sd1;
out.maxfilt1=filmax1;
toc1=toc

figure,plot(sds1,filmax1),grid on,hold on,plot(sds1,filmax1,'gx')

dsd2=dsd0*nper;
sds2=sds1(imax-1):dsd2:sds1(imax+1);
out.sds2=sds2;
ns2=length(sds2);

filmax2=zeros(1,ns2);
jj=0;

fprintf('\n --- Second step %d sd samples \n sd band %e - %e\n\n',ns2,sds2(1),sds2(ns2))

for a = sds2
    jj=jj+1;
    [bsd_corr,frcorr]=bsd_dopp_sd(bsd_out,cand,[a,0]);

    [bsd_ftr,outr]=bsd_ftrim(bsd_corr,frs,enl,1);
    f5v=find_5vec(outr.sp);
    filmax2(jj)=f5v.max;
    fprintf(' %d/%d  %e  %f\n',jj,ns2,a,f5v.max)
end

[mm,imax]=max(filmax2);
sd2=sds2(imax);
out.sd2=sd2;
out.maxfilt2=filmax2;

dsd3=dsd0;
sds3=sds2(imax-1):dsd3:sds2(imax+1);
out.sds3=sds3;
ns3=length(sds3);
toc2=toc

filmax3=zeros(1,ns3);
jj=0;

fprintf('\n --- Third step %d sd samples \n sd band %e - %e\n\n',ns3,sds3(1),sds3(ns3))

for a = sds3
    jj=jj+1;
    [bsd_corr,frcorr]=bsd_dopp_sd(bsd_out,cand,[a,0]);

    [bsd_ftr,outr]=bsd_ftrim(bsd_corr,frs,enl,1);
    f5v=find_5vec(outr.sp);
    filmax3(jj)=f5v.max;
    fprintf(' %d/%d  %e  %f\n',jj,ns3,a,f5v.max)
end

[mm,imax]=max(filmax3);
sd3=sds3(imax);
out.maxfilt3=filmax3;
toc3=toc

figure,plot(sds2,filmax2);hold on,grid on,plot(sds3,filmax3,'r.');

[bsd_corr,frcorr]=bsd_dopp_sd(bsd_out,cand,[sd2,0]); 
[bsd_ftr,outr]=bsd_ftrim(bsd_corr,frs,enl);
f5v=find_5vec(outr.sp);

plot_lines(f5v.frs5v,outr.sp,'m');

out.f5v=f5v;

out.fr=f5v.frs5v(3);
out.sd=sd3;
out.T1=toc1;
out.T2=toc2-toc1;
out.T3=toc3-toc2;
out.Ttot=toc;
