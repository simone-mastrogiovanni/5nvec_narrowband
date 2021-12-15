function [ratmap,intsig]=int_sid_sweep(sids,ints,typ,icsol)
% sid_sweep integration
%
%   sids    output of a sid_sweep
%   ints    integration windows (integer array)
%   typ     normalization (0 no, 1 yes, 2 sqr (def))
%   icsol   = 1 solar data (def 0 sidereal data)

% Snag Version 2.0 - May 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

SD=86164.09053083288;
SOL=86400;

if ~exist('typ','var')
    typ=2;
end
if ~exist('icsol','var')
    icsol=0;
end

M=length(ints);
N=length(sids.sidsig);
intsig=zeros(N,M);
intnois=zeros(N,M);
ratmap=zeros(N,M);

a=1;

for i = 1:M
    switch typ
        case 0
            norm=1;
        case 1
            norm=ints(i);
        case 2
            norm=sqrt(ints(i));
    end
    
    b=ones(1,ints(i))/norm;
    
    if icsol == 0
        intsig(:,i)=filter(b,a,sids.sidsig);
        intnois(:,i)=filter(b,a,sids.sidnois);
    else
        intsig(:,i)=filter(b,a,sids.solsig);
        intnois(:,i)=filter(b,a,sids.solnois);
    end
    ratmap(:,i)=intsig(:,i)./intnois(:,i);
end
