function gout=gd_resampling_nointer(gin,dtout,NMAX)
% GD_RESAMPLING  resamples a gd
%
%      gout=gd_resampling_nointer(gin,dt)
%
%   gin     input gd (data object)
%   dtout   desired sampling time
%   NMAX    max length of pieces (def 2^20)
%
%   gout    resampled gd (data object)
%
% The in and out sampling frequencies should be integer numbers

% Version 2.0 - February 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('NMAX','var')
    NMAX=2^20; 
end

dtin=dx_gd(gin);
frin=1/dtin;
nin=n_gd(gin);
ini=ini_gd(gin);
y=y_gd(gin);

frout=1/dtout;
nout=round(nin*frout/frin);

frmax=max(frin,frout);
nsec=min(ceil(max(nin,nout)/(2*frmax)),ceil(NMAX/(2*frmax)))*2 % an even number
ndat1=nsec*frin
ndat2=nsec*frout;
nd2=min(ndat1,ndat2)/2;
ntotin=frin*ceil(nin/frin);
y(nin+1:ntotin)=0;
x1=zeros(1,ndat2);

ii=0;
iiout=0;

while ii < ntotin
    x=y(ii+1:ii+ndat1)*frout/frin;
    ii=ii+ndat1;
    x=fft(x);
    x(nd2:ndat1+2-nd2)=0;
%     x(nd2-10:nd2-1)=x(nd2-10:nd2-1).*(10:-1:1)'/10;
    x1(1:ndat2)=0;
    x1(1:nd2)=x(1:nd2);
    x1(ndat2:-1:ndat2-nd2+2)=conj(x(2:nd2));
    x1=ifft(x1);
    gout(iiout+1:iiout+ndat2)=x1;
    iiout=iiout+ndat2;
end

gout=gd(gout(1:nout));
gout=edit_gd(gout,'dx',dtout,'ini',ini,'capt','resampled data');
