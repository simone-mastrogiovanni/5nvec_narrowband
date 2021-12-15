function data=data_period(x,y)
% DATA_PERIOD  analyzes periodicity of x-y data
%
%     data=data_period(x,y,typ)
%
%   x,y     input data; if absent, interactive
%           if x is a string, open a pasco file and take data
%
%   tper    1 up, 2 max, 3 down, 4 min

% Project LabMec - part of the toolbox Snag - April 2014
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

warning('off','all');
dtfino=0.0001;
if ~exist('typ','var')
    typ=1;
end
if ~exist('x','var')
    [x,y,dt,n,file,comm]=leggi_pasco;
    [pathstr,name,ext] = fileparts(file);
    name=tit_underscore(name);
else
    if ischar(x)
        file=x;
        [x,y,dt,n,file,comm]=leggi_pasco(file);
        [pathstr,name,ext] = fileparts(file);%figure,plot(x,y),file,name
        name=tit_underscore(name);
        ii=[2 n-1];
    else
        name=' ';
    end
end
[x ix]=sort(x);
y=y(ix);
x1=x;
if ~exist('ii','var')
    [xx ii]=sel_absc(0,y,x,1); title(name),xlabel('time')
else
    figure,plot(x,y),grid on, title(name),xlabel('time')
end
[i1 i2]=size(ii);

x=x(ii(1):ii(2));
y=y(ii(1):ii(2));
my=mean(y);
y=y-my;
data.x=x;
data.y=y;

n=length(y);
iiup=find(y(1:n-1).*y(2:n) < 0 & y(1:n-1) < 0);
iidown=find(y(1:n-1).*y(2:n) < 0 & y(1:n-1) > 0);
yup=iiup*0;
ydown=iidown*0;
tup=yup;
iup=yup;
tdown=ydown;
nup=length(iiup);
tper=zeros(4,nup-1);
aper=zeros(2,nup-1);
iper=0;

for i = 1:nup
    iii=iiup(i);
    yy=y(iii-2:iii+2)+0.00001*(1:5)';
    xx=x(iii-2:iii+2);
    tup(i)=spline(yy,xx,0);
    if i > 1
        if iiup(i)-iiup(i-1) > 6
            iper=iper+1;
            tper(1,iper)=tup(i-1);
            xxx=x(iiup(i-1):iiup(i));
            yyy=y(iiup(i-1):iiup(i));
            nnn=length(xxx);
            iidown=find(yyy(1:nnn-1).*yyy(2:nnn) < 0 & yyy(1:nnn-1) > 0);
            [mi,jj]=min(abs(iidown-nnn/2)); % se sono più di uno
            iii=iidown(jj);
            yy=yyy(iii-2:iii+2)+0.00001*(1:5)';
            xx=xxx(iii-2:iii+2);
            tper(3,iper)=spline(yy,xx,0);
            iimax=round((1+iii)/2);
            iimax1=round((1+iimax)/2);
            iimax2=round((iii+iimax)/2);
            xx=xxx(iimax1:iimax2);
            yy=yyy(iimax1:iimax2);
            nn=length(xx); %nnn,iimax,iimax1,iimax2,nn
            if nn > 4
                kdeg=4;
            else
                kdeg=3;
            end
            p = polyfit(xx,yy,kdeg);
            xxxx=xx(1):dtfino:xx(nn);
            yyyy=polyval(p,xxxx);
            [aper(1,iper),ii]=max(yyyy);
            tper(2,iper)=xxxx(ii);
            
            iimin=round((iii+nnn)/2);
            iimin1=round((iii+iimin)/2);
            iimin2=round((nnn+iimin)/2);
            xx=xxx(iimin1:iimin2);
            yy=yyy(iimin1:iimin2);
            nn=length(xx); % nnn,iimin,iimin1,iimin2,nn
            if nn > 4
                kdeg=4;
            else
                kdeg=3;
            end
            p = polyfit(xx,yy,kdeg);
            xxxx=xx(1):dtfino:xx(nn);
            yyyy=polyval(p,xxxx);
            [aper(2,iper),ii]=min(yyyy);
            tper(4,iper)=xxxx(ii);
        end
    end
end

data.tper=tper;
data.aper=aper;
tper1=diff(tper')';

figure,hold on
plot((tper(2,:)-tper(1,:))*4,'g'),plot((tper(2,:)-tper(1,:))*4,'g.')
plot((tper(3,:)-tper(1,:))*2),plot((tper(3,:)-tper(1,:))*2,'.')
plot((tper(4,:)-tper(1,:))*4/3,'r'),plot((tper(4,:)-tper(1,:))*4/3,'r.')
plot(tper(1,2:iper)-tper(1,1:iper-1),'k'),plot(tper(1,2:iper)-tper(1,1:iper-1),'k.')
grid on,title([name ': punti nodali (k,b) e massimali (g,r) normalizzati']),xlabel('periodi')

figure,hold on
plot(tper1(1,:)),plot(tper1(1,:),'r.')
plot(tper1(2,:)),plot(tper1(2,:),'g.')
plot(tper1(3,:)),plot(tper1(3,:),'.')
plot(tper1(4,:)),plot(tper1(4,:),'k.')
grid on,title([name ': periodi nodali e massimali']),xlabel('periodi')

figure,hold on
plot(aper(1,:)),plot(aper(1,:),'r.')
plot(aper(2,:),'g'),plot(aper(2,:),'k.')
grid on,title([name ': ampiezze']),xlabel('periodi')

figure,hold on
plot(aper(1,:)),plot(aper(1,:),'r.')
plot(-aper(2,:),'g'),plot(-aper(2,:),'k.')
grid on,title([name ': abs(ampiezze)']),xlabel('periodi')

% figure,hold on
% plot(tper1(1,:)-tper1(3,:)),plot(tper1(1,:)-tper1(3,:),'r.')
% grid on,title([name ': differenze periodi nodali']),xlabel('periodi')
% 
% figure,hold on
% plot(tper1(2,:)-tper1(4,:)),plot(tper1(2,:)-tper1(4,:),'r.')
% grid on,title([name ': differenze periodi massimali']),xlabel('periodi')