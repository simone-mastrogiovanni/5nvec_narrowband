function out=bsd_orthoband2(bandin,res)
% general computation for orthoband
%
%   bandin   input band
%   res      resolution (def 0.001) or [res Nsol] 

% Snag Version 2.0 - November 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('res','var')
    res=0.001;
end

if length(res) == 2
    Nsol=res(2);
    res=res(1);
else
    Nsol=1;
end

bandw0=bandin(2)-bandin(1);

bandw=bandw0;
n0(1)=floor(bandin(1)/bandw);
bandout(1,1)=bandw*n0(1);
bandout(2,1)=bandw*(n0(1)+1);
ii(1)=0;

for k = 1:Nsol
    while bandout(2,k) < bandin(2)
        bandw(k)=bandw(k)+res;
        n0(k)=floor(bandin(1)./bandw(k));
        bandout(1,k)=bandw(k)*n0(k);
        bandout(2,k)=bandw(k)*(n0(k)+1);
        ii(k)=ii(k)+1;
    end
    bandw1=bandout(2,k)-bandout(1,k)+res;
    n1=floor(bandin(1)/bandw1);
    bandout(1,k+1)=bandw1*n1;
    bandout(2,k+1)=bandw1*(n1+1);
    bandw(k+1)=bandw1;
    ii(k+1)=0;
end

bandout=bandout(:,1:Nsol);
ii=ii(1:Nsol);
out.bandin=bandin;
out.bandout=bandout;
out.bandwin=bandw0;
out.bandwout=bandout(2,:)-bandout(1,:);
out.n0=n0;
out.dt=1./out.bandwout;
out.iter=ii;