function [out,ncoin,mu1,mu2,sig1,sig2,dista]=coin_direc_base(cand1,cand2,tab1,tab2,dist,mindist,pteor_)
% coincidences between candidates for candidates
%
%    par    search parameters (.typ, .dist, .amp, .cr, .mincr, .maxcr, .delay)
%    in1    cand1 structure (.cand,.tab)
%    in2    cand2 structure
%     .........

% Snag Version 2.0 - March 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

band10=10;

i1=1;
j1=1;
[~,ncand1]=size(cand1);
[~,ncand2]=size(cand2);

ncoin=0;
kcoin=[];

tabcol1=tab1(:,1);
fr1_0=-10;

for i = 1:ncand1
    c1=cand1(:,i);
    fr1=cand1(1,i);
    fr11=floor(fr1/band10)*band10;
    if fr11 ~= fr1_0
        iii=find(tabcol1 == fr11);
        if iii > 0
            tabrow1=tab1(iii,:);
            tabrow2=tab2(iii,:);
            dfr1=tabrow1(5);
            dsd1=tabrow1(6);
            dfr2=tabrow2(5);
            dsd2=tabrow2(6);
            dfr=(dfr1+dfr2)/2;
            dsd=(dsd1+dsd2)/2;
            MU1=pteor_*tabrow1(3);
            SIG1=sqrt(pteor_*(1-pteor_)*tabrow1(3));
            MU2=pteor_*tabrow2(3);
            SIG2=sqrt(pteor_*(1-pteor_)*tabrow2(3));
            fr1_0=fr11;
            fprintf(' %10f %d %d  ncoin %d\n',fr11,i,j1,ncoin)
        else
            i1000=i1000+1
            fr11,fr1_0
        end
    end
    sd1=cand1(4,i);
    for j = j1:ncand2
        DF=(cand2(1,j)-fr1)/dfr;
        if DF < -dist
            j1=j1+1;
            continue
        end
        if DF > dist
            break
        end
        DS=(cand2(4,j)-sd1)/dsd;
        dis=sqrt(DF^2+DS^2);
        if dis <= dist && dis >= mindist
            ncoin=ncoin+1;
            kcoin=[kcoin; i j];
            dista(ncoin)=dis;
%                 cr1(ncoin)=(cand1(5,i)-MU1)/SIG1;
%                 cr2(ncoin)=(cand2(5,i)-MU2)/SIG2;
            mu1(ncoin)=MU1;
            sig1(ncoin)=SIG1;
            mu2(ncoin)=MU2;
            sig2(ncoin)=SIG2;
        end
    end
end

out.ncoin=ncoin;
if ncoin > 0
    out.kcoin=kcoin;
    out.dist=dista;
    out.i=i;
    out.j=j;

    for i = 1:ncoin
        out.coin(i).in1=cand1(:,kcoin(i,1));
        out.coin(i).in2=cand2(:,kcoin(i,2));
    end
end