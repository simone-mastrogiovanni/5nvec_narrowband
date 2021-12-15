function out=find_5vecphase(bsd,fr,v5t)
% 5-vect best phase
%
%   out=find_5vecphase(bsd,fr,v5t)
%
%   bsd   input bsd
%   fr    frequency
%   v5t   theoretical 5-vect

% Snag version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

res1=10;
res2=0.1;
n1=round(360/res1)+1;
n2=round(2*res1/res2)+1;

ii=0;
aa1=zeros(1,n1);
cc0=aa1;
eff=cc0;

for aa = 0:10:360
    v5s=bsd_5vec(bsd,fr,aa);

    rat=v5s(:)./v5t(:);
    
    ii=ii+1;
    aa1(ii)=aa;
    cc0(ii)=rat(3);
    eff(ii)=abs(sum(rat))/sum(abs(rat));
end

aa0A=atan3(cc0);
figure,plot(aa1,aa0A),grid on,title('ang0')
figure,plot(aa1,eff),grid on,title('eff0')
figure,semilogy(aa1,1-eff),grid on,title('loss0')

out.eff0=eff;
out.ang0=aa0A;

[a,ii]=max(eff);
ph0=aa1(ii);
out.ph0=ph0;
out.eff0max=eff(ii);

ii=0;
aa1=zeros(1,n2);
cc0=aa1;
eff=cc0;

for aa = ph0-10:0.1:ph0+10
    v5s=bsd_5vec(bsd,fr,aa);

    rat=v5s(:)./v5t(:);
    
    ii=ii+1;
    aa1(ii)=aa;
    cc0(ii)=rat(3);
    eff(ii)=abs(sum(rat))/sum(abs(rat));
end

aa0A=atan3(cc0);
figure,plot(aa1,aa0A),grid on,title('ANG')
figure,plot(aa1,eff),grid on,title('EFF')
figure,semilogy(aa1,1-eff),grid on,title('LOSS')

out.eff=eff;
out.ang=aa0A;

[a,ii]=max(eff);
ph=aa1(ii);
out.ph=ph;
out.effmax=eff(ii);
out.loss=1-eff(ii);