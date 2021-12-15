function crea_uncplot(fil)
% CREA_UNCPLOT  gui per grafico di dati con incertezze
%
%   fil    file

% Project LabMec - part of the toolbox Snag - April 2009
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if exist('fil','var')
    out=LM_read(fil);
else
    out=LM_read;
end

icsel=0;

if isfield(out,'sel')
    i=find(out.sel);
    ii=find(1-out.sel);
    if length(ii) > 0
        out1.x=out.x(ii);
        out1.dx=out.dx(ii);
        out1.y=out.y(ii);
        out1.dy=out.dy(ii);
        out.x=out.x(i);
        out.dx=out.dx(i);
        out.y=out.y(i);
        out.dy=out.dy(i);
        out.n=length(out.y);
        icsel=1;
    end
end

unc=read_error(out.y);
g=gd(out.y);
if out.unclevel == 1
    g=edit_gd(g,'x',out.x,'unc',out.dy);
elseif out.unclevel == 2
    g=edit_gd(g,'x',out.x,'unc',out.dy,'uncx',out.dx);
    if icsel == 1
        g1=gd(out1.y);
        g1=edit_gd(g1,'x',out1.x,'unc',out1.dy,'uncx',out1.dx);
    end
else
    out.dy=out.y*0+unc;
end

figure,plot_unc(g,1),hold on

answ=inputdlg({'Ordine del fit' 'Amplificazione incertezza del fit'},'Parametri Fit',1,{'1' '1'});

fitord=eval(answ{1});
errmag=eval(answ{2});

% xx=xrange(1)+(xrange(2)-xrange(1))*(0:200)/200;
% dxr=(xrange(2)-xrange(1))/N;
% uncx=dxr*0.1*ones(N,1);
% rr=rand(N,1);
% 
% for i = 1:N
%     x(i)=xrange(1)+(i-0.5)*dxr+dxr*caslev*(rr(i)-0.5);
% end
% x=sort(x);
% unc=2*incmed*(rand(N,1));
% erry=unc.*randn(N,1);
% y=polyval(pol0,x)+erry';
% 
% y1=gd(y);
% y1=edit_gd(y1,'x',x,'unc',unc,'uncx',uncx);
% 
% plot_unc(y1)
% plot(xx,polyval(pol0,xx),'m:')

unc=out.dy;
x=out.x;
y=out.y;
N=out.n;

[coef,covar,F,res,chiq,ndof,err1,errel1]=gen_lin_fit(x,y,unc,1,fitord,0);

for i = 1:N
    f=F(i,:);
    err(i)=f*covar*f';
end

err=sqrt(err);%size(y),size(err),size(res),

fit=y+res';std(res)
err=err*std(res)/mean(unc);

plot(x,y+res'+err*errmag,'g')
plot(x,y+res'-err*errmag,'g')
for i = 1:N
    plot([x(i) x(i)],[y(i)+res(i)+err(i)*errmag y(i)+res(i)-err(i)*errmag],'g')
end
plot(x,y+res','k--'),plot(x,y,'r.')
plot_unc(g,1)
if icsel == 1
    plot_unc(g1,1,2);
end

figure,plot(x,res),grid on,hold on,plot(x,res,'r.')
title('Residuals');

n=length(coef);
disp(sprintf('  Coefficienti polinomio di fit'))
disp(sprintf('grado  valore  incertezza'))
for i = 1:n
    disp(sprintf('  %d   %f   %f',n-i,coef(i),sqrt(covar(i,i))))
end