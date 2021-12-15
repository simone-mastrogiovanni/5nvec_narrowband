%hough_prob_eval

dx=0.01;
xmax=30;
subres=2;

y=peak_pot(0,xmax,dx); % no signal
nth=length(y(subres:subres:length(y)))

nsig=6;
dsig=0.1;

ps=zeros(nsig,nth);
opar=ps;
normopar=ps;
pn(1,1:nth)=y(subres:subres:length(y));

for i = 1:nsig
    y=peak_pot(i*dsig,xmax,dx);
    ps(i,1:nth)=y(subres:subres:length(y));
    opar(i,1:nth)=(ps(i,1:nth)-pn(1,1:nth))./sqrt(pn(1,1:nth).*(1-pn(1,1:nth)));
    normopar(i,1:nth)=opar(i,1:nth)/(i*dsig);
end

[C,Ip]=max(opar');
best_thresh_peak=Ip*dx*subres

x=(subres:subres:length(y))*dx;

figure
plot(x,opar')
grid on

y=spec_rcdf(0,xmax,dx); % no signal

ss=zeros(nsig,nth);
sopar=ss;
sn(1,1:nth)=y(subres:subres:length(y));

for i = 1:nsig
    y=spec_rcdf(i*dsig,xmax,dx);
    ss(i,1:nth)=y(subres:subres:length(y));
    sopar(i,1:nth)=(ss(i,1:nth)-sn(1,1:nth))./sqrt(sn(1,1:nth).*(1-sn(1,1:nth)));
    normsopar(i,1:nth)=sopar(i,1:nth)/(i*dsig);
end

[C,Is]=max(sopar');
best_thresh_allbins=Is*dx*subres

% figure
hold on
plot(x,sopar','--')
grid on

figure
plot(x,sqrt(normopar')),grid on
figure
plot(x,sqrt(normopar(1,:))),grid on,hold on
plot(x,sqrt(normsopar(1,:)),'--')
figure
plot(x,sqrt(normopar(nsig,:))),grid on,hold on
plot(x,sqrt(normsopar(nsig,:)),'--')