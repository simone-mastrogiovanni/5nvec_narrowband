function [center, borders]=check_optmap(map,sour)
% CHECK_OPTMAP given a sky map and a source, finds the cell of the source
%              (the map is in the format created by pss_optmap.m)
%
%       [center, borders]=check_optmap(map,sour)
%
%    map          sky map (as created by pss_optmap.m)
%    sour         source structure (it uses only sour.bet and sour.lam)
%
%    center(1,2)  center value (given by map)
%    borders(4,2) NW,NE,SW,SE

% Version 2.0 - November 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

Nmap=length(map);
ii=find(diff(map(:,2)));
betas(2:length(ii)+1)=map(ii+1,2);
betas(1)=90;
Nbetas=length(betas);

[c,i]=min(abs(betas-sour.bet));
center(1,2)=betas(i);

if i ~= 1 & i ~= Nbetas
    lambdas=map(ii(i-1)+1:ii(i),1);
    Nlambdas=length(lambdas);
    [c,j]=min(mod(lambdas-sour.lam,360));
    center(1,1)=lambdas(j);
    dlam=360/(Nlambdas*2);
    borders(4,2)=(betas(i)+betas(i+1))/2;
    borders(3,2)=(betas(i)+betas(i+1))/2;
    borders(1,2)=(betas(i)+betas(i-1))/2;
    borders(2,2)=(betas(i)+betas(i-1))/2;
    borders(1,1)=mod(center(1,1)-dlam,360);
    borders(2,1)=mod(center(1,1)+dlam,360);
    borders(3,1)=mod(center(1,1)-dlam,360);
    borders(4,1)=mod(center(1,1)+dlam,360);
else
    center(1,1)=180;
    dlam=180;
    if i == 1
        borders(4,2)=(betas(i)+betas(i+1))/2;
        borders(3,2)=(betas(i)+betas(i+1))/2;
        borders(1,2)=90;
        borders(2,2)=90;
        borders(1,1)=mod(center(1,1)-dlam,360);
        borders(2,1)=mod(center(1,1)+dlam,360);
        borders(3,1)=mod(center(1,1)-dlam,360);
        borders(4,1)=mod(center(1,1)+dlam,360);
    else
        borders(4,2)=-90;
        borders(3,2)=-90;
        borders(1,2)=(betas(i)+betas(i-1))/2;
        borders(2,2)=(betas(i)+betas(i-1))/2;
        borders(1,1)=mod(center(1,1)-dlam,360);
        borders(2,1)=mod(center(1,1)+dlam,360);
        borders(3,1)=mod(center(1,1)-dlam,360);
        borders(4,1)=mod(center(1,1)+dlam,360);
    end
end
