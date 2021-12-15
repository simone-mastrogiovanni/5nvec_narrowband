% ana_2dof
%
% after driver_5band_ana, containing
% 
% fr0=0.38194046
% 
% agwC=compute_5comp(gwC,fr0);
% 
% sigs(1,:)=compute_5comp(pL0wien,fr0);
% sigs(2,:)=compute_5comp(pL45wien,fr0);
% sigs(3,:)=compute_5comp(pCAwien,fr0);
% sigs(4,:)=compute_5comp(pCCwien,fr0);
% 
% [outmf cohe x inif DF]=band_5ana(gwC,fr0,sigs,agwC,[0.255 0.495],8);

TS=86164.09053083288;
out1=abs(outmf).^2;
[i1 N]=size(out1);

k1=floor(-(inif-fr0+2/TS)/DF)+1;
k2=ceil(-(inif-fr0+2/TS)/DF)+1;
x1=x(k1);
x2=x(k2); % x1,x2
k0=round((fr0-inif-2/TS)/DF)+1; % k0,k1,k2
ma=max(max(out1));
mi=min(min(out1))+eps;
figure,plot(x,out1(1,:)),grid on,hold on,
plot(x,out1(2,:),'r')
plot(x,out1(3,:),'g')
plot(x,out1(4,:),'k')
plot([-2 -2]*1/TS,[mi ma],'m')
plot([-1 -1]*1/TS,[mi ma],'m')
plot([0 0]*1/TS,[mi ma],'m')
plot([1 1]*1/TS,[mi ma],'m')
plot([2 2]*1/TS,[mi ma],'m')
title('4 matched filters: b,r,g,k')
xlabel('Hz')

xh=(0:200)*ma/200;
dhxmf=ma/200;
his(1,:)=histc(out1(1,:),xh);
his(2,:)=histc(out1(2,:),xh);
his(3,:)=histc(out1(3,:),xh);
his(4,:)=histc(out1(4,:),xh);
his=his/(N*dhxmf);
figure,semilogy(xh,his'),grid on
title('4 m.f. histogram: b,r,g,k')

figure,plot(x,cohe(1,:)),grid on,hold on,
plot(x,cohe(2,:),'r')
plot(x,cohe(3,:),'g')
plot(x,cohe(4,:),'k')
plot([-2 -2]*1/TS,[0 1],'m')
plot([-1 -1]*1/TS,[0 1],'m')
plot([0 0]*1/TS,[0 1],'m')
plot([1 1]*1/TS,[0 1],'m')
plot([2 2]*1/TS,[0 1],'m')
title('4 m.f. coherences: b,r,g,k')
xlabel('Hz')

xh=(0:200)/200;
dhxco=1/200;
hisc(1,:)=histc(cohe(1,:),xh);
hisc(2,:)=histc(cohe(2,:),xh);
hisc(3,:)=histc(cohe(3,:),xh);
hisc(4,:)=histc(cohe(4,:),xh);
hisc=hisc/(N*dhxco);
cohteor2dof=4*(1-xh).^3;
figure,plot(xh,hisc'),grid on,hold on
plot(xh,cohteor2dof,'r--','LineWidth',2)
title('4 coherence histogram: b,r,g,k')
figure,semilogy(xh,hisc'),grid on,hold on
semilogy(xh,cohteor2dof,'r--','LineWidth',2)
title('4 coherence histogram: b,r,g,k')

