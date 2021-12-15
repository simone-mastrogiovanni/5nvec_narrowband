function outstr=sid_band_anamedian(g2in,subband,ant,gencapt,nofig,nbin)
% sid_band_analysis 
%
%    subband   [frmin frmax]; 0 -> all
%    nofig     > 0 no figures
%              = 2 no phfr_spec2
%
%    outstr.

% Version 2.0 - March 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('nofig','var')
    nofig=0;
end

if ~exist('nbin','var')
    nbin=100;
end

if nbin ==0
    nbin=100;
end

if isfield(ant,'inifr')
    outstr.inifr=ant.inifr;
else
    outstr.inifr=0;
end

ihand=0;

gencapt1=underscore_man(gencapt);

capt.spec.title='spectral density';
capt.spec.xlabel='Hz';
capt.spec.ylabel='h/sqrt(Hz)';
capt.amp.title='periodicity amplitude';
capt.amp.xlabel='Hz';
capt.amp.ylabel='fraction of the mean value';
capt.phase.title='phase of the maximum';
capt.phase.xlabel='Hz';
capt.phase.ylabel='hours';
capt.aphase.title='phase of the minimum';
capt.aphase.xlabel='Hz';
capt.aphase.ylabel='hours';
capt.epfold.title='epoch folding with smoothing';
capt.epfold.xlabel='hours';
capt.epfold.ylabel='fraction of the mean value';

x2=x2_gd2(g2in);
t=x_gd2(g2in);
outstr.band=[min(x2) max(x2)];
ccapt=sprintf(' band %4.0f-%4.0f ',min(x2),max(x2));

if length(subband) == 2
    g2in=cut_gd2(g2in,subband(1),subband(2),1);
end

g1in=gd2_median(g2in,2,1);
h1in=gd2_median(g2in,1,1);

outstr.g1in=g1in;
outstr.h1in=h1in;

nbin1=[nbin 24 1];

[periods harms percleans wins]=gd_period(g1in,'sid',nbin1,4,ant);
outstr.periods=periods/mean(periods);
outstr.percleans=percleans/mean(percleans);
[periodd harmd percleand wind]=gd_period(g1in,'day',nbin1,4,ant);
outstr.periodd=periodd/mean(periodd);
outstr.percleand=percleand/mean(percleand);
[perioda harma percleana wina]=gd_period(g1in,'asid',nbin1,4,ant);
outstr.perioda=perioda/mean(perioda);
outstr.percleana=percleana/mean(percleana);

gout=gd_nu_median(g1in,7,1);
gout1=gd_nu_moav(g1in,7,1);

if nofig <= 0
    gen_plot(g1in,'.'),grid on,hold on,plot(gout,'r'),plot(gout1,'g')
    title([gencapt1 ccapt ' median']),xlabel('days')
    gen_plot(h1in),title([gencapt1 ccapt ' spectral density']),xlabel('Hz')
    figure,plot(percleans),hold on,grid on,plot(percleand,'r'),plot(percleana,'g')
    title([gencapt1 ccapt ' epoch-folding; b sid, r sol, g asid']),xlabel('hours'),xlim([0 24])
end

[outstr.pf_map map outstr.pf_spec]=phfr_spec1(g1in,60,[gencapt1 ccapt],subband,nbin,2);

T=max(t)-min(t);
res=8;
fr=[0 3.1];

dfr=1/(T*res);

g1=g1in/std(g1in);
ps=gd_holeps(g1,fr(1),fr(2),dfr);
show_spec_lines(ps,['Power spectrum on ' gencapt1 ccapt])
outstr.ps=ps;

[sp1 sp4 spall ft]=gd_nud_spec(g1,fr,res,nbin);
show_spec_lines(sp1,['Epoch-folding spectrum on ' gencapt1 ccapt])
outstr.sp1=sp1;
    
% [psls prob]=lombscargle(g1,5,4,1.1,0);
% show_spec_lines(psls,['old Lomb-Scargle spectrum on ' gencapt1 ccapt])
% outstr.psls=psls;

% xx=x_gd(g1);
% yy=y_gd(g1);
% pls=ls_periodogram(xx,yy,[0.9 1.1 6]);
% show_spec_lines(pls,['Lomb-Scargle spectrum on ' gencapt1 ccapt])
% outstr.pls=pls;