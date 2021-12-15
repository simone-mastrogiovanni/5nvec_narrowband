function [sh lin lintot]=search_harmonics(g,frmin,frmax,dfr)
% SEARCH_HARMONICS  search harmonics
%
%    sh=search_harmonics(g,thr,frmin,frmax,dfr)
%
%   g      a type-2 gd with peaks (see ana_peakfr)
%   minfr  min frequency
%   maxfr  max frequency
%   dfr    resolution

% Version 2.0 - June 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[y n dt ini capt x]=extr_gd(g);
xmax=max(x);

sh=zeros(1,10000);
xsh=zeros(1,10000);
fr=frmin;
nsh=0;
N=1;

while fr <= frmax
    nsh=nsh+1;
    if floor(nsh/10000)*10000 == nsh-1
        sh(nsh:nsh+9999)=zeros(1,10000);fr
        xsh(nsh:nsh+9999)=zeros(1,10000);
    end
    x1=mod(x+dfr/2,fr);
    sh(nsh)=length(find(x1<dfr));
    xsh(nsh)=fr;
    fr=fr+dfr/N;
    N=xmax/fr;
end

sh=sh(1:nsh);
xsh=xsh(1:nsh);

sh=gd(sh);
sh=edit_gd(sh,'x',xsh);

lin=gd_peaks(sh,20);
linx=x_gd(lin);
liny=y_gd(lin);
[liny iy]=sort(liny,'descend');
linx=linx(iy);
linxy=linx.*liny;
lintot=gd(liny);
lintot=edit_gd(lintot,'x',linx);

nhar=20;
har=zeros(1,nhar*nhar);
ii=0;
for i = 1:nhar
    for j = 1:nhar
        ii=ii+1;
        har(ii)=i/j;
        if har(ii) >= 10
            har(ii)=0;
        end
        if har(ii) <= 0.1
            har(ii)=0;
        end
    end
end
har=nonzeros(har);
% har=har(2:81);

nl=length(linx);
ntr=1;

while nl > ntr+1
    trl=linx(ntr);
    ic=1:nl;
    for i = ntr+1:nl
        ind=find(abs(trl*har/linx(i)-1)<0.001, 1);
        if ~isempty(ind)
            ic(i)=0;
        end
    end
    ic=nonzeros(ic);
    linx=linx(ic);
    liny=liny(ic);
    nl=length(linx);
    ntr=ntr+1;
end

lin=gd(liny);
lin=edit_gd(lin,'x',linx);
 