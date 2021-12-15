function [x,lam,bet]=pss_optmap_spot(ND,res,lam0,bet0,d)
% sky points for a spot
%
%   [x,bet,lam]=pss_optmap_spot(ND,res,lam0,bet0,d)
%
%    ND         number of freq bins in the *FULL* Doppler band
%    res        resolution
%    lam0,bet0  spot center
%    d          spot radius (in deg)
%
%  pss_opt_map       all sky
%  pss_opt_map_spot  for directed "square" spot
%  pss_opt_map_ref   for follow-up

deg2rad=pi/180;

if ~exist('res','var')
    res=1;
end

poles=0;

if bet0+d > 90
    poles=1;
elseif bet0-d < -90
    poles=-1;
end

ND=ND*res; 

dd=deg2rad*d;

bet1(1)=bet0*deg2rad;   
delbet=1./abs(ND*sin(bet1(1))); 
if delbet > dd
    delbet=dd;
end
i1=1;

switch poles
    case 0
        while bet1(i1) < (bet0+d)*deg2rad && bet1(i1) < pi/2 -delbet
            i1=i1+1;
            bet1(i1)=bet1(i1-1)+delbet;
            delbet=abs(1./(ND*sin(bet1(i1))));
        end

        delbet=1./abs(ND*sin(bet1(1)));
        if delbet > dd
            delbet=dd;
        end
        bet2(1)=bet0*deg2rad-delbet;
        i2=1;

        while bet2(i2) > (bet0-d)*deg2rad && bet2(i2) > -pi/2+delbet
            i2=i2+1;
            bet2(i2)=bet2(i2-1)-delbet;
            delbet=abs(1./(ND*sin(bet2(i2))));
        end

        bet=bet1(i1:-1:1);
        bet(i1+1:i1+i2)=bet2;
        bet=bet/deg2rad;

        dellam=(1./abs(ND*cos(bet0)))/deg2rad;
        nlam=ceil(d/dellam)+1;
        lam=lam0+(-nlam:nlam)*dellam;
        
        nb=length(bet);
        nl=length(lam);
        x=zeros(nl*nb,5);
        ij=0;

        for i= 1:nl
            for j = 1:nb
                ij=ij+1;
                x(ij,1)=lam(i);
                x(ij,2)=bet(j);
                x(ij,3)=dellam;
                x(ij,4)=bet(j)+delbet/deg2rad;
                x(ij,5)=bet(j)-delbet/deg2rad;
            end
        end
    case 1
        dang=2/(ND*res*deg2rad); % ATTENTION
        bet(1)=90;
        n=1;
        ang=90;
        while ang >= 90-d
            n=n+1;
            ang=ang-dang;
            bet(n)=ang;
        end
        
        kk=1;
        x(kk,1)=lam0;
        x(kk,2)=90;
        x(kk,3)=1;
        x(kk,4)=lam0;
        
        for j = 2:n-1
            nl1=ceil(res*2*pi*(ND*cos(bet(j)*deg2rad)));
            dl=360/nl1;
            for jj = 0:round(nl1/2-1)
                kk=kk+1;
                x(kk,1)=lam0+jj*dl;
                x(kk,2)=bet(j);
                x(kk,3)=dl;
                x(kk,4)=bet(j-1);
                x(kk,5)=bet(j+1);
            end
            for jj = 1:round(nl1/2-1)
                kk=kk+1;
                x(kk,1)=lam0-jj*dl;
                x(kk,2)=bet(j);
                x(kk,3)=dl;
                x(kk,4)=bet(j-1);
                x(kk,5)=bet(j+1);
            end
        end
        lam=x(:,1);
    case -1
        dang=2/(ND*res*deg2rad); % ATTENTION
        bet(1)=-90;
        n=1;
        ang=-90;
        while ang <= -90+d
            n=n+1;
            ang=ang+dang;
            bet(n)=ang;
        end
        
        kk=1;
        x(kk,1)=lam0;
        x(kk,2)=-90;
        x(kk,3)=1;
        x(kk,4)=lam0;
        
        for j = 2:n-1
            nl1=ceil(res*2*pi*(ND*cos(bet(j)*deg2rad)));
            dl=360/nl1;
            for jj = 0:round(nl1/2-1)
                kk=kk+1;
                x(kk,1)=lam0+jj*dl;
                x(kk,2)=bet(j);
                x(kk,3)=dl;
                x(kk,4)=bet(j-1);
                x(kk,5)=bet(j+1);
            end
            for jj = 1:round(nl1/2-1)
                kk=kk+1;
                x(kk,1)=lam0-jj*dl;
                x(kk,2)=bet(j);
                x(kk,3)=dl;
                x(kk,4)=bet(j-1);
                x(kk,5)=bet(j+1);
            end
        end
        lam=x(:,1);
end

