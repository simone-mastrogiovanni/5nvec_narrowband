function sidpat_rand=ana_sidpat_rand(ant,direc,N,nharm)
% analyze sidereal pattern
%
%   ant     antenna (e.g. 'virgo')
%   direc   direction structure or cw-source structure
%   N       montecarlo dimension (def or 0 -> 1000)
%   nharm   number of harmonics (def 20)

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('nharm','var')
    nharm=20;
end
if ~exist('N','var')
    N=1000;
end
if N == 0
    N=1000;
end

if ischar(ant)
    sidpat_rand.ant=ant;
    eval(['ant=' ant ';'])
else
    sidpat_rand.ant=ant.name;
end

if ischar(direc)
    sidpat_rand.direc=direc;
    eval(['direc=' direc ';'])
else
    sidpat_rand.direc=direc.name;
end

sidpat_rand.N=N;

sour=direc;
culm=1;
n=100;

psi=rand(1,N)*180;
cosiota=rand(1,N)*2-1;
eta=-2*cosiota./(1+cosiota.^2);
sidpat_rand.eta=eta;
sidpat_rand.psi=psi;

s=zeros(nharm+1,N);
% sabs=s;

for i = 1:N
    sour.eta=eta(i);
    sour.psi=psi(i);
    
    [sidpat,ftsp,v]=pss_sidpat(sour,ant,n,culm);
    s(:,i)=ftsp(1:nharm+1);
%     sabs(i)=sqrt(s1(i)^2+s2(i)^2+s3(i)^2+s4(i)^2);
end

sidpat_rand.s=s;
% sidpat_rand.sabs=sabs;