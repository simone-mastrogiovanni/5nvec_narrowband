function [sp lin]=houghsearch_harmonics(g,frmin,frmax,N)
% HOUGHSEARCH_HARMONICS  search harmonics with a special Hough transform
%
%    sh=search_harmonics(g,thr,frmin,frmax,dfr)
%
%   g      a type-2 gd with peaks (see ana_peakfr)
%   minfr  min frequency
%   maxfr  max frequency
%   N      number of frequency bins for the fundamental

% Version 2.0 - July 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[y n dt ini capt x]=extr_gd(g);
xmax=max(x);

aa=frmax/frmin;
bb=aa^(1/(N-1));
ff=frmin*bb.^(0:N-1);

sp=zeros(1,N);

for i = 1:n
    xi=x(i);
    yi=y(i);
    if xi < frmin 
        continue
    end
    kmax=floor(xi/frmin);
    kmin=ceil(xi/frmax);
    kk=(kmin:kmax);
    fk=xi./kk;
    iff=round(log(fk./frmin)/log(bb))+1;
    if ~isempty(iff)
        sp(iff)=sp(iff)+1; % choose a method
%         sp(iff)=sp(iff)+yi; 
%         sp(iff)=sp(iff)+yi./kk; 
    end
end

sp=gd(sp);
sp=edit_gd(sp,'x',ff,'capt','houghsearch_harmonics');