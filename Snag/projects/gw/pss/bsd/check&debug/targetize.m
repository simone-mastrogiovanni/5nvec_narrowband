function [out,x,dist,I]=targetize(sour,tfft,T0,unc)
% creates targets for check
%
%   sour    base for the target
%   tfft    length of the ffts (s)
%   T0      observation time (days)
%   unc     added uncertainty [fr lam bet sd]

% Snag Version 2.0 - March 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

out=sour;

if length(unc) == 1
    unc(1:4)=unc;
end

fr0=sour.f0(1);
if isfield(sour,'df0')
    df0=sour.df0;
else
    df0=sour.f0(2);
end
[lam0,bet0]=astro_coord('equ','ecl',sour.a,sour.d);[lam0,bet0]

dfr=1/tfft;
dsd0=1/(tfft*T0*86400);

Ndop=ceil(2*1.06e-4*fr0/dfr);

[x,b,index,nlon]=pss_optmap(Ndop);

[n1,n2]=size(x);
dist=zeros(n1,1);

for i = 1:n1
    dist(i)=spherical_distance(x(i,1),x(i,2),lam0,bet0);
end

[M,I]=min(dist);

X=x(I,:);
lam=X(1);
bet=X(2);
[a,d]=astro_coord('ecl','equ',lam,bet);

r=rand(1,4)-0.5;

out.f0=round(fr0/dfr)*dfr+unc(1)*r(1)*dfr;
out.a=a+unc(2)*r(2)*X(3);
out.d=d+unc(3)*r(3)*(X(5)-X(4))/2;
out.ecl=[lam,bet];
out.df0=round(df0/dsd0)*dsd0+unc(4)*r(4)*dsd0;