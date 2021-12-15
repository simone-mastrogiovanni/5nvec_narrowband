function [x,lam,bet]=pss_optmap_ref(ND,res,lam0,bet0,enl)
% sky points for a spot
%
%   [x,bet,lam]=pss_optmap_spot(ND,res,lam0,bet0,enl)
%
%    ND         number of freq bins in the *FULL* Doppler band
%    res        resolution (number of points in unc)
%    lam0,bet0  candidate to ref
%    enl        enlargment (def 1.5)
%
%  pss_opt_map       all sky
%  pss_opt_map_spot  for directed "square" spot
%  pss_opt_map_ref   for follow-up

deg2rad=pi/180;
rad2deg=1/deg2rad;

if ~exist('enl','var')
    enl=1.5;
end

maxdelbet=rad2deg/sqrt(ND);

if bet0 ~= 0
    delbet=max(rad2deg./abs(ND*sin(bet0*deg2rad)),maxdelbet); 
else
    delbet=maxdelbet;
end

dellam=min((1./abs(ND*cos(bet0*deg2rad)))*rad2deg,180);

N=round(res*enl*2+1);
N1=floor(N/2);
DB=delbet/res;
DL=dellam/res;

lam=mod(lam0+((1:N)-N1-1)*DL,360);
bet=bet0+((1:N)-N1-1)*DB;

i1=1;
i2=N;

for i = 1:N1
    if bet(i) < -90
        i1=i+1;
    end
    if bet(N-i+1) > 90
        i2=N-i;
    end
end

ij=0;i1,i2

for i= 1:N
    for j = i1:i2
        ij=ij+1;
        x(ij,1)=lam(i);
        x(ij,2)=bet(j);
        x(ij,3)=dellam;
        x(ij,4)=bet(j)+DB;
        x(ij,5)=bet(j)-DB;
    end
end

bet=bet(i1:i2);