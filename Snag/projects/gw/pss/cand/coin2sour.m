function [shsour kcand]=coin2sour(coin,kcoin,typ,kcand)
% extracts the cand parameters from a coincidence structure
%
%    [shsour kcand]=cand2sour(coin,kcoin,type,kcand)
%
%  coin     coincidence structure
%  kcoin    coincidence number
%  typ      0  mean of cref cands
%           1  cand1 cref
%           2  cand2 cref
% %           3  cand1 maxA
% %           4  cand2 maxA
%           5  any cand1
%           6  any cand2
%  kcand    cand1 or 2 number (type = 5 or 6)
%
%  shsour  short source array [fr lam bet sd epoch]

% Version 2.0 - July 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

shsour=zeros(1,5);
shsour(5)=coin.T0;
switch typ
    case 0
        kcand(1)=coin.cref(kcoin,2);
        kcand(2)=coin.cref(kcoin,3);
        cand1=coin.cand1(kcand(1),:);
        cand2=coin.cand2(kcand(2),:);
        shsour(1:4)=(cand1(1:4)+cand2(1:4))/2;
    case 1
        kcand=coin.cref(kcoin,2);
        cand1=coin.cand1(kcand,:);
        shsour(1:4)=cand1(1:4);
    case 2
        kcand=coin.cref(kcoin,3);
        cand2=coin.cand2(kcand,:);
        shsour(1:4)=cand2(1:4);
    case 3
    case 4
    case 5
        cand1=coin.cand1(kcand,:);
        shsour(1:4)=cand1(1:4);
    case 6
        cand2=coin.cand2(kcand,:);
        shsour(1:4)=cand2(1:4);
end