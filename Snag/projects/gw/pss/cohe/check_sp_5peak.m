function [sp pfr pa]=check_sp_5peak(gin)

ST=86164.09053083288;

cont=cont_gd(gin);
dt=dx_gd(gin);

fr=cont.appf0;
fr0=fr-floor(fr*dt)/dt;

s=gd_pows(gin,'resolution',4,'window',2);
dft=dx_gd(s);
kf1=round((fr0-4/ST)/dft);
kf2=round((fr0+4/ST)/dft);

sp=s(kf1:kf2);
figure,semilogy(sp),grid on,hold on
thresh=max(sp)/100;
npeaks=10;
[pfr,pa]=oned_peaks(sp,thresh,npeaks,4);

masp=max(sp);
misp=min(sp);
plot([fr0-2/ST fr0-2/ST],[misp masp],'m:')
plot([fr0-1/ST fr0-1/ST],[misp masp],'m:')
plot([fr0 fr0],[misp masp],'m:')
plot([fr0+1/ST fr0+1/ST],[misp masp],'m:')
plot([fr0+2/ST fr0+2/ST],[misp masp],'m:')

for i = 1:length(pfr)
    fprintf(' %d    fr = %14.9f   k = %d    amp = %f \n',i,pfr(i),round(pfr(i)/dft)+1,pa(i))
end