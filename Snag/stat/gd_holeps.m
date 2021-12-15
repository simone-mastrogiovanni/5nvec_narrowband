function ps=gd_holeps(gin,frin,frfin,dfr,norm)
% gd_holeps  power spectrum with unevenly sampled data (not l-s)
%            zero data are considered holes
%
%    gin              input gd or array
%    frin,frfin,dfr   or fr
%    norm             normalization type (1 natural, 2 prob (exp)
%                      (or in frfin if use of fr)

% Version 2.0 - January 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if isnumeric(gin)
    gin=gd(gin);
end

t=x_gd(gin);
y=y_gd(gin);

ii=find(y);
t=t(ii);
y=y(ii);

if length(frin) == 1
    fr=frin:dfr:frfin;
else
    fr=frin;
    dfr=fr(2)-fr(1);
    frin=fr(1);
    if exist('frfin','var')
        norm=frfin;
    end
end

if ~exist('norm','var')
    norm=2;
end

my=mean(y);
nfr=length(fr);
ps=zeros(1,nfr); 

for i = 1:nfr
    e=exp(-1j*fr(i)*2*pi*t);
    ps(i)=2*abs(mean(e.*(y-my)).^2);
end

if norm == 2
    ps=ps*nfr/(4*var(y));
end

ps=gd(ps);
ps=edit_gd(ps,'ini',frin,'dx',dfr,'capt',['gd_holeps on ' capt_gd(gin)]);