% ex_bsd_5vec
%
% after ex_bsd_sband and ex_bsd_dedop

bsd=bsd_corrL;
tic

t0_O1=57277;

pp=pulsar_3;  %  not updated sources !

pp=new_posfr(pp,t0_O1);
f0=pp.f0;

df=1.e-8;

frs=(-15:15)*df+f0;
n=length(frs);

v=bsd_5vec(bsd,frs);

for i = 1:n
    vnorm(i)=norm(v(:,i));
end

vabs=abs(v);
vang=angle(v)*180/pi;
for j = 1:5
    vang1(j,:)=atan3(v(j,:));
end
frs1=frs(1:n-1)+df/2;

figure,plot(frs,vnorm),grid on,title('Norm')
plot_lines(f0,vnorm,'g')
[vmax,imax]=max(vnorm);
fmax=frs(imax);
plot_lines(fmax,vnorm,'r')

figure,plot(frs,vabs(1,:),'r'),grid on
hold on,plot(frs,vabs(2,:),'m')
hold on,plot(frs,vabs(3,:),'k')
hold on,plot(frs,vabs(4,:),'g')
hold on,plot(frs,vabs(5,:),'b'),title('Absolute values')
vabsmax=max(vabs);
plot_lines(f0,vabsmax,'g')
plot_lines(fmax,vabsmax,'r')

figure,plot(frs,vabs(1,:)./vabsmax,'r'),grid on
hold on,plot(frs,vabs(2,:)./vabsmax,'m')
hold on,plot(frs,vabs(3,:)./vabsmax,'k')
hold on,plot(frs,vabs(4,:)./vabsmax,'g')
hold on,plot(frs,vabs(5,:)./vabsmax,'b'),title('Normalised absolute values')
vabsmax=max(vabs);
plot_lines(f0,[0 1.05],'g')
plot_lines(fmax,[0 1.05],'r')

figure,plot(frs,vang(1,:),'r'),grid on
hold on,plot(frs,vang(2,:),'m')
hold on,plot(frs,vang(3,:),'k')
hold on,plot(frs,vang(4,:),'g')
hold on,plot(frs,vang(5,:),'b'),title('Angles')
plot_lines(f0,vang(:),'g')
plot_lines(fmax,vang(:),'r')

figure,plot(frs,vang1(1,:),'r'),grid on
hold on,plot(frs,vang1(2,:),'m')
hold on,plot(frs,vang1(3,:),'k')
hold on,plot(frs,vang1(4,:),'g')
hold on,plot(frs,vang1(5,:),'b'),title('Angles (in turns)')
plot_lines(f0,vang1(:),'g')
plot_lines(fmax,vang1(:),'r')

figure,plot(frs1,diff(vang1(1,:)),'r'),grid on
hold on,plot(frs1,diff(vang1(2,:)),'m')
hold on,plot(frs1,diff(vang1(3,:)),'k')
hold on,plot(frs1,diff(vang1(4,:)),'g')
hold on,plot(frs1,diff(vang1(5,:)),'b'),title('Angles differences')
plot_lines(f0,diff(vang1(:))/4,'g')
plot_lines(fmax,diff(vang1(:))/4,'r')

toc

