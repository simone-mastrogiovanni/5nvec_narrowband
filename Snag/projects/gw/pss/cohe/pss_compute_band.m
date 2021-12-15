function [fr1,fr2,fr01,fr02,fr]=pss_compute_band(source,antenna,tim)
%PSS_COMPUTE_BAND  computes the band spanned by a source
%
%    source    source structure
%    antenna   antenna structure
%    tim       [tinit tfin]

sour1=new_posfr(source,tim(1));
sour2=new_posfr(source,tim(2));
alpha=sour1.a;
delta=sour1.d;
long=antenna.long;
lat=antenna.lat;

fr01=sour1.f0;
fr1=doppler(tim(1),fr01,alpha,delta,long,lat,0);

fr02=sour2.f0;
fr2=doppler(tim(2),fr02,alpha,delta,long,lat,0);

N=1000;
t=tim(1)+(0:N)*(tim(2)-tim(1))/N;
fr=zeros(1,N+1);

for i = 1:N+1
    sour=new_posfr(source,t(i));
    fr0=sour.f0;
    fr(i)=doppler(t(i),fr0,alpha,delta,long,lat,0);
end