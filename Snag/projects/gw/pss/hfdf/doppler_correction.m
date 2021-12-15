function [factdop]=doppler_correction(timfr_simdoppler,lambda,beta,va,ve,vd)
%doppler_correction from an input gd and sky map, source (lines) parameters --> to a gd with the
%Doppler correction applied

day2sec=86400.0;
A=y_gd2(timfr_simdoppler); 
[ff,tt,aa]=find(A');
frini=ini2_gd2(timfr_simdoppler);
%%timeini=ini_gd2(timfr_simdoppler);  
dfr=dx2_gd2(timfr_simdoppler);
dt=dx_gd2(timfr_simdoppler);
%%ff=(ff-1)*dfr+frini;  
tt=(tt-1)*dt; %%+timeini;             
nn=length(tt);
ntot=n_gd2(timfr_simdoppler);
nfr=m_gd2(timfr_simdoppler);  %number of frequencies
nspectra=ntot/nfr;       %number of spectra       
%%Source in the loop
ss(1)=lambda;  
ss(2)=beta;
ss(3)=1;
s(:,1)=astro2rect(ss,0);  %0 for degrees

time=-10000;
j=0;
for i=1:nn
    if tt(i) > time
        j=j+1;
        time=tt(i);
    end
    rr(1)=va(j);
    rr(2)=vd(j);
    rr(3)=ve(j);
    det_r=astro2rect(rr,1);  %1 for radians in input
    scalarp=det_r(1)*s(1,1)+det_r(2)*s(2,1)+det_r(3)*s(3,1);
    factdop(i)=1./(1+scalarp);
    
end
