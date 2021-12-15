function H=frline_hough(pm,par)
%FRLINE_HOUGH  frequency line analysis by hough maps
%
%        H=frline_hough(pm,par)
%
%  pm         peak map analysis
%  par        parameter structure
%     .dmax   max of |dfr|
%     .nd     number of dfr bins (odd suggested)
%
%
%                                    Operation
% The input is a time-frequency (t,f) matrix that can be sparse (binary  peak map) or, in
% the case of low frequency resolution, contains the number of peaks at that frequency 
% bandelet. It has dimension A(nt,nfr).
% The output is a (f0,d=df/dt) hough map. It has dimension H(nfr+2*m,nd); nd should be
% odd, so there is a 0-centered bin. At each d the f0 are computed as
%                         f0=f-d*t

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

A=y_gd2(pm); size(A)
t=x_gd2(pm);
t=t-t(1);
tmax=t(length(t));
dfr=dx2_gd2(pm);
n=n_gd2(pm);
nfr=m_gd2(pm);
nt=n/nfr;

if ~exist('par')
    par.nd=401;
    par.dmax=2*dfr/(t(2)-t(1));
end
nd=par.nd;
dmax=par.dmax;
ddfr=2*dmax/nd;
more=ceil(tmax*dmax);
nfr1=nfr+2*more;
% shift=round((1:nd)*ddfr-dmax-ddfr/2)/dfr);
% shift=ddfr*t;

H=zeros(nfr1,nd); size(H)
h=zeros(nfr1,1);

[tt,ff]=find(A);
npeak=length(tt);
ff=ff*dfr;

nt,nd,nt*nd

for i=1:nt
    h=find(A(i,:))+more;
    shift=ddfr*t(i);%shift*nd/2;
    for j = 1:nd
        dd=round(shift*(j-nd/2));
        H(h+dd,j)=H(h+dd,j)+1;
    end
end