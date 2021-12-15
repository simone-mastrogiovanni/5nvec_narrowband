function sidpat_base=ana_sidpat_base(ant,direc,N,res)
% sidpat_base to analyze sidereal pattern
%
%   ant     antenna (e.g. 'virgo')
%   direc   direction structure or cw-source structure
%   N       number of montecarlo samples for background evaluation (def no)
%           -1: no background, full range (symmetrical)
%           <-1: background with -N, full range (symmetrical)
%   res     resolution for eta and psi [neta,npsi] (def [201,90])

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('N','var')
    N=0;
end
if ~exist('res','var')
    res=[201,90];
    if N < 0
        res=[201,90];
    end
end

if ischar(ant)
    sidpat_base.ant=ant;
    eval(['ant=' ant ';'])
else
    sidpat_base.ant=ant.name;
end

if ischar(direc)
    sidpat_base.direc=direc;
    eval(['direc=' direc ';'])
else
    sidpat_base.direc=direc.name;
end

sour=direc;
culm=1;
n=100;

if N < 0  % ??
    deta=2/(res(1)-1);
    eta=-1:deta:1;
else
    deta=2/(res(1)-1);
    eta=-1:deta:1;
end

dpsi=90/res(2);
psi=0:dpsi:90-dpsi;
sidpat_base.eta=eta;
sidpat_base.psi=psi;

s0=zeros(res(1),res(2));
s1=s0;
s2=s0;
s3=s0;
s4=s0;
sabs=s0;
i=0;

for e = eta
    i=i+1;
    sour.eta=e;
    j=0;
    for p = psi
        j=j+1;
        sour.psi=p;
        [sidpat,ftsp,v]=pss_sidpat(sour,ant,n,culm);
        s0(i,j)=ftsp(1);
        s1(i,j)=ftsp(2);
        s2(i,j)=ftsp(3);
        s3(i,j)=ftsp(4);
        s4(i,j)=ftsp(5);
        sabs(i,j)=sqrt(abs(s1(i,j))^2+abs(s2(i,j))^2+abs(s3(i,j))^2+abs(s4(i,j))^2);
    end
end

sidpat_base.s0=s0;
sidpat_base.s1=s1;
sidpat_base.s2=s2;
sidpat_base.s3=s3;
sidpat_base.s4=s4;
sidpat_base.sabs=sabs;
sidpat_base.s1n=s1./abs(s1);
sidpat_base.s2n=s2./abs(s2);
sidpat_base.s3n=s3./abs(s3);
sidpat_base.s4n=s4./abs(s4);

if abs(N) > 1
    sidpat_base.spb_bg=ana_sidpat_background(sidpat_base,abs(N));
end