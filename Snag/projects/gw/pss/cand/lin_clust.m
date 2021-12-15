function out=lin_clust(cand,baseamp)
% computes linear model for clusters
%
%    out=lin_clust(cand,baseamp)
%
%   cand     candidate matrix (at list (:,5)) (fr,lam,bet,sd,amp)
%   baseamp  amplitude base (to compute uncertainty)
%
%   out.

% Version 2.0 - July 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome


[f,ii]=sort(cand(:,1));
cand=cand(ii,:);
unc=1./(cand(:,5)-baseamp);
l=cand(:,2);
s=cand(:,4);
% [dum,ii]=max(abs(cand(:,3)));
% signb=sign(cand(ii,3));
b=abs(cand(:,3));
[a_fl,covar,F,res,chiq,ndof,err,errel,wres,wsnr]=gen_lin_fit(f,l,unc,1,1,0);
out.L=F*a_fl;
out.wres_l=wres;
out.wsnr_l=wsnr;
[a_fs,covar,F,res,chiq,ndof,err,errel,wres,wsnr]=gen_lin_fit(f,s,unc,1,1,0);
out.S=F*a_fs;
out.wres_s=wres;
out.wsnr_s=wsnr;
[a_fb,covar,F,res,chiq,ndof,err,errel,wres,wsnr]=gen_lin_fit(f,b,unc,1,1,0);
out.B=F*a_fb;
out.wres_b=wres;
out.wsnr_b=wsnr;

out.f=f;
out.l=l;
out.s=s;
out.b=b;
out.unc=unc;
out.a_fl=a_fl;
out.a_fs=a_fs;
out.a_fb=a_fb;