function sim_uncplot(def)
% SIM_UNCPLOT  gui per grafico di dati con incertezze
%
%   def    valori di default

% Project LabMec - part of the toolbox Snag - July 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('def','var')
    def={'7' '0.3' '0.5' '[2 10]' '[1 2.3]' '1' '1'};
end

answ=inputdlg({'Numero di punti' 'Livello di casualità (0-1)' 'Incertezza media' ...
    'Range ascisse' 'Legge polinomiale (dalla potenza più alta)' ...
    'Ordine del fit' 'Amplificazione incertezza del fit'},...
    'Simulazione dati polinomiali con incertezze',1,def);

N=eval(answ{1});
caslev=eval(answ{2});
incmed=eval(answ{3});
xrange=eval(answ{4});
pol0=eval(answ{5});
fitord=eval(answ{6});
errmag=eval(answ{7});

xx=xrange(1)+(xrange(2)-xrange(1))*(0:200)/200;
dxr=(xrange(2)-xrange(1))/N;
uncx=dxr*0.1*ones(N,1);
rr=rand(N,1);

for i = 1:N
    x(i)=xrange(1)+(i-0.5)*dxr+dxr*caslev*(rr(i)-0.5);
end
x=sort(x);
unc=2*incmed*(rand(N,1));
erry=unc.*randn(N,1);
y=polyval(pol0,x)+erry';

y1=gd(y);
y1=edit_gd(y1,'x',x,'unc',unc,'uncx',uncx);

plot_unc(y1)
plot(xx,polyval(pol0,xx),'m:')

[a,covar,F,res,chiq,ndof,err1,errel1]=gen_lin_fit(x,y,unc,1,fitord,0);

for i = 1:N
    f=F(i,:);
    err(i)=f*covar*f';
end

err=sqrt(err);size(y),size(err),size(res),

fit=y+res';std(res)
err=err*std(res)/mean(unc);

plot(x,y+res'+err*errmag,'g')
plot(x,y+res'-err*errmag,'g')
for i = 1:N
    plot([x(i) x(i)],[y(i)+res(i)+err(i)*errmag y(i)+res(i)-err(i)*errmag],'g')
end
plot(x,y+res','k--'),plot(x,y,'r.')
plot_unc(y1,1)
a