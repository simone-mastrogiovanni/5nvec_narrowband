% ana_4dof
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
% [outmf cohe x inif DF]=band_5ana(1372.53*gwC,fr0,sigs,agwC,[0.255 0.495],8);

TS=86164.09053083288;
out2(1,:)=abs(outmf(1,:)).^2+abs(outmf(5,:)).^2;
out2(2,:)=abs(outmf(3,:)).^2+abs(outmf(6,:)).^2;
out2(3,:)=abs(outmf(1,:)).^2+abs(outmf(2,:)).^2;
out2(4,:)=abs(outmf(3,:)).^2+abs(outmf(4,:)).^2;
[i1 N]=size(out2);

k1=floor(-(inif-fr0+2/TS)/DF)+1;
k2=ceil(-(inif-fr0+2/TS)/DF)+1;
x1=x(k1);
x2=x(k2); % x1,x2
k0=round((fr0-inif-2/TS)/DF)+1; % k0,k1,k2
ma=max(max(out2));
mi=min(min(out2))+eps;
figure,plot(x,out2(1,:)),grid on,hold on,
plot(x,out2(2,:),'r')
plot([-2 -2]*1/TS,[mi ma],'m')
plot([-1 -1]*1/TS,[mi ma],'m')
plot([0 0]*1/TS,[mi ma],'m')
plot([1 1]*1/TS,[mi ma],'m')
plot([2 2]*1/TS,[mi ma],'m')
title('2 f-stat: b,r')
xlabel('Hz')

xh=(0:200)*ma/200;
dhxmf4=ma/200;
his2(1,:)=histc(out2(1,:),xh);
his2(2,:)=histc(out2(2,:),xh);
his2=his2/(N*dhxmf4);
figure,semilogy(xh,his2'),grid on
title('2 f-stat histogram: b,r,g,k')

figure,plot(x,cohe(5,:)),grid on,hold on,
plot(x,cohe(6,:),'r')
plot([-2 -2]*1/TS,[0 1],'m')
plot([-1 -1]*1/TS,[0 1],'m')
plot([0 0]*1/TS,[0 1],'m')
plot([1 1]*1/TS,[0 1],'m')
plot([2 2]*1/TS,[0 1],'m')
title('2 f-stat coherences: b,r,g,k')
xlabel('Hz')

xh=(0:200)/200;
dhxco=1/200;
hisc2(1,:)=histc(cohe(5,:),xh);
hisc2(2,:)=histc(cohe(6,:),xh);
hisc2=hisc2/(N*dhxco);
cohteor4dof=12*xh.*(1-xh).^2;
figure,plot(xh,hisc2'),grid on,hold on
plot(xh,cohteor4dof,'r--','LineWidth',2)
title('4 coherence histogram: b,r,g,k')
figure,semilogy(xh,hisc2'),grid on,hold on
semilogy(xh,cohteor4dof,'r--','LineWidth',2)
title('4 coherence histogram: b,r,g,k')

xh=(0:200)/200;
dhxco=1/200;
hisc2(1,:)=histc(cohe(7,:),xh);
hisc2(2,:)=histc(cohe(8,:),xh);
hisc2=hisc2/(N*dhxco);
cohteor4dof=12*xh.*(1-xh).^2;
figure,plot(xh,hisc2'),grid on,hold on
plot(xh,cohteor4dof,'r--','LineWidth',2)
title('4 coherence histogram: b,r,g,k')
figure,semilogy(xh,hisc2'),grid on,hold on
semilogy(xh,cohteor4dof,'r--','LineWidth',2)
title('4 coherence histogram: b,r,g,k')
