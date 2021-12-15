function psc_showcoin(c_cand1,c_cand2,fr,lam,bet,sd,cr)
%PSC_SHOWCOIN  shows coincidences
%
%      psc_showcoin(c_cand1,c_cand2,fr,lam,bet,sd,cr)
%
%   c_cand1,c_cand2  input candidate matrices
%   fr           [frmin,frmax]; = 0 no selection
%   lam          [lammin,lammax]; = 0 no selection
%   bet          [betmin,betmax]; = 0 no selection
%   sd           [sdmin,sdmax]; = 0 no selection
%   cr           [crmin,crmax]; = 0 no selection
%
%  selections are on the first file

% Version 2.0 - June 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if length(fr) == 1
    fr=[0 10000];
end
[ia ib]=find(c_cand1(1,:)>=fr(1) & c_cand1(1,:)<=fr(2));
c_cand1=c_cand1(:,ib);
c_cand2=c_cand2(:,ib);
if length(lam) == 1
    lam=[-360 360];
end
[ia ib]=find(c_cand1(2,:)>=lam(1) & c_cand1(2,:)<=lam(2));
c_cand1=c_cand1(:,ib);
c_cand2=c_cand2(:,ib);
if length(bet) == 1
    bet=[-100 100];
end
[ia ib]=find(c_cand1(3,:)>=bet(1) & c_cand1(3,:)<=bet(2));
c_cand1=c_cand1(:,ib);
c_cand2=c_cand2(:,ib);
if length(sd) == 1
    sd=[-1.e36 1.e36];
end
[ia ib]=find(c_cand1(4,:)>=sd(1) & c_cand1(4,:)<=sd(2));
c_cand1=c_cand1(:,ib);
c_cand2=c_cand2(:,ib);
if length(cr) == 1
    cr=[-1.e36 1.e36];
end
[ia ib]=find(c_cand1(5,:)>=cr(1) & c_cand1(5,:)<=cr(2));
c_cand1=c_cand1(:,ib);
c_cand2=c_cand2(:,ib);

length(c_cand1)

c_cand=(c_cand1+c_cand2)/2;

frmin=min(c_cand(1,:));
frmax=max(c_cand(1,:));
epsf=(frmax-frmin)/50;
sdmin=min(c_cand(4,:));
sdmax=max(c_cand(4,:));
epss=(sdmax-sdmin)/50;
plot_manypoints(c_cand(1,:),c_cand(4,:),c_cand1(4,:),[frmin-epsf frmax+epsf sdmin-epss sdmax+epss],'o','bitone')
xlabel('Frequency'),ylabel('Spin-down')

plot_manypoints(c_cand(2,:),c_cand(3,:),c_cand1(4,:),[0 360 -90 90],'o','bitone')
title('Ecliptical Coordinates')

[ao,do]=astro_coord_fix('ecl','equ',c_cand(2,:),c_cand(3,:));
ii=find(ao<0);
ao(ii)=ao(ii)+360;

plot_manypoints(ao,do,c_cand1(4,:),[0 360 -90 90],'o','bitone')
title('Equatorial Coordinates')

astra=pss_astra(0);
for i = 1:length(astra)
    a(i)=astra(i).alpha;
    d(i)=astra(i).delta;
end

plot(a,d,'Or')

[a,d]=galac_disc(60);
plot(a,d,'.m')

[ao,do]=astro_coord_fix('ecl','gal',c_cand(2,:),c_cand(3,:));
ii=find(ao>180);
ao(ii)=ao(ii)-360;

plot_manypoints(ao,do,c_cand1(4,:),[-180 180 -90 90],'o','bitone')
title('Galactic Coordinates')

plot_manypoints(0,0,c_cand1(4,:),0,'o','bitone')
xlabel('Sequence number'),ylabel('Spin-down')

cr1min=min(c_cand1(5,:));
cr1max=max(c_cand1(5,:));
epsc1=(cr1max-cr1min)/50;
cr2min=min(c_cand2(5,:));
cr2max=max(c_cand2(5,:));
epsc2=(cr2max-cr2min)/50;
plot_manypoints(c_cand1(5,:),c_cand2(5,:),c_cand1(4,:),[cr1min-epsc1 cr1max+epsc1 cr2min-epsc2 cr2max+epsc2],'o','bitone')
title('CR Scatter Plot')
xlabel('DB 1'),ylabel('DB 2')
