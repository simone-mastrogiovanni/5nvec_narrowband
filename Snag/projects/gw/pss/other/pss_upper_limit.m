function out=pss_upper_limit(injin,injout,thr,candh,band)
% computes the upper limits for certain cands
%
%    out=pss_upper_limit(injin,injout,thr,candh)
%
%   injin   injected normalized amplitudes
%   injout  detected normalized amplitudes
%   thr     u.l. level threshold (typically 0.9)
%   candh   candidates detected normalized amplitude to compute upper limit
%
%   out
%

% Snag version 2.0 - January 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('band','var')
    band=0.1;
end
N=length(injin);
m=length(candh);
ul=zeros(m,1);
ninj=ul;
ninjok=ul;
% figure,loglog(injin,injout,'.'),hold on,grid on,

for i = 1:m
    cmin=candh(i);
    cmax=max(injin);
    h=cmin;
    while h <= cmax
        ii=find(injin >= h*(1-band) & injin <= h*(1+band));
        jj=find(injout(ii) >= cmin);%sprintf('%d  %d \n',length(ii),jj)
        if length(jj)/length(ii) >= thr
            ul(i)=h;
            ninj(i)=length(ii);
            ninjok(i)=length(jj);
            break
        end
        h=h*(1+band);
    end
end

out.ul=ul;
out.ulrat=ul(:)./candh(:);
out.ninj=ninj;
out.ninjok=ninjok;