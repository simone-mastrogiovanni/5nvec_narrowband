function [sp1 sp4 spall ft]=gd_nud_spec(gin,fr,res,NP,par)
% gd_nud_spec   spectrum for non-uniformly sampled data
%
%    [sp1 sp4 spall]=gd_nud_spec(gin,fr,res,red)
%
%   gin   input gd
%   fr    frequencies [dim=1: single frequency, no gd; dim=2: [frmin frmax]; dim>2: frs)
%   res   frequency resolution (in terms of natural resolution)
%   NP    number of bins in a period
%   par   parameter structures:
%            .red   subsample reduction factor
%            .noz   = 1 only non-zero data (default)
%            .squ   = 1 square the absolute values (default)
%            .s2d   = 1 converts sampling unit from seconds to days
%
%   sp1    first harmonic
%   sp4    first 4 harmonics
%   spall  all harmonics
%   ft     fourier transform

% Version 2.0 - August 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('NP','var')
    NP=120;
end
if ~exist('par','var')
    par.red=1;
    par.noz=1;
    par.squ=1;
    par.s2d=0;
end
if ~isfield(par,'noz')
    par.noz=1;
end
if ~isfield(par,'squ')
    par.squ=1;
end
if ~isfield(par,'s2d')
    par.s2d=0;
end

x=x_gd(gin);
if par.s2d == 1
    x=x/86400;
end
T=max(x)-min(x);
dfr=1/(T*res);

if par.red > 0 
    gin=gd_no0subsamp(gin,par.red);
end

per=zeros(1,NP);
win=per;

if par.noz == 1
    gin=find(gin);
end
y=y_gd(gin);
n=n_gd(gin);
x=x_gd(gin);
if par.s2d == 1
    x=x/86400;
end
obstim=max(x)-min(x);

switch length(fr)
    case 1
        frs=fr;
    case 2
        frs=fr(1):dfr:fr(2);
    otherwise
        frs=fr;
end

nfr=length(frs);
mm=mean(y);
y=y-mm;
sp1=zeros(1,nfr);
sp4=sp1;
spall=sp1;
ft=zeros(1,nfr)+1j*zeros(1,nfr);

for i = 1:nfr
    per=per*0;
    win=win*0;
    ii=mod(floor(x*frs(i)*NP),NP)+1;
    for j = 1:n
        per(ii(j))=per(ii(j))+y(j);
        win(ii(j))=win(ii(j))+1;
    end
    iii=find(win==0);
    if ~isempty(iii)
        win(iii)=max(win)*1e6;
        w(i)=0;
    else
        w(i)=1;
    end
    per=per./win;
    per=per-mean(per);%plot(per),pause(0.2)
    f=fft(per);
    f(6:NP-4)=0;
    per4=ifft(f);
    sp1(i)=abs(f(2));
    sp4(i)=(max(per4)-min(per4));
    spall(i)=sum(abs(per))/NP;
    if par.squ == 1
        sp1(i)=sp1(i).^2;
        sp4(i)=sp4(i).^2;
        spall(i)=spall(i).^2;
    end
    ft(i)=f(2);
end

ii=find(w == 0);

if ~isempty(ii)
    frii=frs(ii);
    iii=find(frii*obstim > 10);
     if ~isempty(iii)
         frs(ii(iii))
         disp(' *** Error ! holes in periods bins; reduce NP.')
     end
end

if length(frs) > 1
    sp1=sp1.*w;
    sp1=gd(sp1);
    sp1=edit_gd(sp1,'ini',frs(1),'dx',dfr,'capt',['spectrum first harmonic on ' capt_gd(gin)]);
    sp4=gd(sp4);
    sp4=edit_gd(sp4,'ini',frs(1),'dx',dfr,'capt',['spectrum first 4 harmonics on ' capt_gd(gin)]);
    spall=gd(spall);
    spall=edit_gd(spall,'ini',frs(1),'dx',dfr,'capt',['spectrum allt harmonics on ' capt_gd(gin)]);

    ft=gd(ft);
    ft=edit_gd(ft,'ini',frs(1),'dx',dfr,'capt',['pseudo Fourier tranxform on ' capt_gd(gin)]);
end