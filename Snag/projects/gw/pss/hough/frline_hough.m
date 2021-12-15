function H=frline_hough(pm,par)
%FRLINE_HOUGH  frequency line analysis by hough maps
%
%        H=frline_hough(pm,par)
%
%  pm         peak map (a gd2 or a (n,2)=[t,fr] or a (n,3)=[t,fr,amp] array
%              the arrays should be time sorted
%  par        parameter structure
%     .frmin  min f0
%     .frmax  max f0
%     .nfr    number of f0s
%     .dmax   max of |dfr|
%     .nd     number of dfr bins (odd suggested)
%
%
%                                    Operation
% The input is a time-frequency (t,f) matrix that can be sparse, with dimension  A(nt,nfr)
% or an array (npeak,2) containing the time and frequency of each peak, or an array (npeak,3) 
% containing also the amplitude.
% The output is a (f0,d=df/dt) hough map. It has dimension H(nfr+2*m,nd); nd should be
% odd, so there is a 0-centered bin. At each d the f0 are computed as
%                         f0=f-d*t

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

icgd2=0;
if isa(pm,'gd2')
    icgd2=1;
    A=y_gd2(pm);
    t=x_gd2(pm);
    t=t-t(1);
    tmax=t(length(t));
    dfr=dx2_gd2(pm);
    inifr=ini2_gd2(pm);
    n=n_gd2(pm);
    nfr=m_gd2(pm);
    nt=n/nfr;
    
    [ff,tt,aa]=find(A');

    ff=(ff-1)*dfr+inifr;
    tt=t(tt); %figure, plot(diff(tt),'.')
    sz=3;
else
    [a,sz]=size(pm);
    tt=pm(:,1);
    ff=pm(:,2);
    if sz >= 3
        aa=pm(:,3);
    end
    tmax=max(tt);
    if ~exist('par','var')
        disp(' *** Needs a par structure !')
        par.dfr=1;
        dfr=par.dfr;
        par.nfr=1000;
        par.nd=50;
        par.dmax=par.nd*par.dfr/4;
    end
    nfr=par.nfr;
end

if ~isfield(par,'frmin')
    par.frmin=0;
    par.frmax=(nfr-1)*dfr;
end

npeak=length(tt);
index(1)=1;
ind=find(diff(tt));
nind=length(ind);
index=zeros(nind+2,1);
index(1)=1;
index(2:nind+1)=ind+1;
index(nind+2)=npeak+1;
nt=nind+1

nd=par.nd;
dmax=par.dmax;
ddfr=2*dmax/nd;
more=ceil(tmax*dmax);
nfr1=nfr+2*more;
Dfr=(par.frmax-par.frmin)/nfr;
H=zeros(nfr1,nd); size(H),dfr,Dfr
h=zeros(nfr1,1);

for i=1:nt
    frin=index(i):index(i+1)-1;
    h=round(ff(frin)/Dfr)+more;
    t=tt(index(i));
    shift=ddfr*t;
    for j = 1:nd
        dd=round(shift*(j-nd/2));h,dd
        H(h+dd,j)=H(h+dd,j)+1;
    end
end

