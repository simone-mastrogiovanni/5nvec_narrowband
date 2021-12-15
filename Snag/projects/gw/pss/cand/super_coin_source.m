function scoin=super_coin_source(sour,cand1,cand2,dmax,dfr,dsd)
% coincidences between candidates and a source
%
%    scoin=super_coin(sour,cand1,cand2,dmax,dfr,dsd)
%
%  sour         source (10 pars)
%  cand1,cand2  candidate structures
%  dmax         max distance
%  dfr,dsd      parameters
%
%  scoin        super coincidence matrix

% Snag Version 2.0 - May 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

enl=1; % ATTENZIONE ! può essere 1.5

[ii1, dd1]=dist_sour(sour,cand1,dmax*enl,dfr,dsd);  
lii1=length(ii1);
scoin.mind1=min(dd1);
[ii2, dd2]=dist_sour(sour,cand2,dmax*enl,dfr,dsd);
lii2=length(ii2);
scoin.mind2=min(dd2);

scoin.ii1=lii1;
scoin.ii2=lii2;
scoin.d=1000000;

if lii1*lii2 > 0
    cand1=cand1(ii1,:);
    cand2=cand2(ii2,:);
    d=zeros(lii1,lii2); size(d)
    if lii1 <= lii2
        scoin.lead=1;
        for i = 1:lii1
            d(i,:)=distance_4(cand1(i,:),cand2,dfr,dsd);
        end
    else
        scoin.lead=2;
        for i = 1:lii2
            d(:,i)=distance_4(cand2(i,:),cand1,dfr,dsd);
        end
    end
    [dd,ii,jj]=minmin(d);
    scoin.d=dd;
    scoin.cand=(cand1(ii,:)+cand2(jj,:))/2;
    scoin.dcand=(cand1(ii,:)-cand2(jj,:))/2;
    scoin.cand1=cand1(ii,:);
    scoin.cand2=cand2(ii,:);

%     scoin.cand(1)=(cand1(ii,1)+cand2(jj,1))/2;
%     scoin.cand(1)=(cand1(ii,2)+cand2(jj,2))/2;
%     scoin.cand(1)=(cand1(ii,3)+cand2(jj,3))/2;
%     scoin.cand(1)=(cand1(ii,4)+cand2(jj,4))/2;
else
    scoin.lead=0;
end