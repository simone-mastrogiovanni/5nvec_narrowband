function data=data_period_0(typ,x,y)
% DATA_PERIOD  analyzes periodicity of x-y data
%
%     data=data_period(x,y,typ)
%
%   x,y     input data
%   typ     type of analysis
%           1 - simple (def)
%           2 - more

% Project LabMec - part of the toolbox Snag - April 2014
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('typ','var')
    typ=1;
end
if ~exist('x','var')
    [x,y,dt,n,file,comm]=leggi_pasco;
    [pathstr,name,ext] = fileparts(file);
    name=tit_underscore(name);
else
    name=' ';
end
[x ix]=sort(x);
y=y(ix);
x1=x;
[xx ii]=sel_absc(0,y,x,1);
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
tdown=ydown;

for i = 1:length(iiup)
    iii=iiup(i);
    yy=y(iii-2:iii+2)+0.00001*(1:5)';
    xx=x(iii-2:iii+2);
    tup(i)=spline(yy,xx,0);
end

for i = 1:length(iidown)
    iii=iidown(i);
    yy=y(iii-2:iii+2)+0.00001*(1:5)';
    xx=x(iii-2:iii+2);
    tdown(i)=spline(yy,xx,0);
end

figure,plot(x,y,'.'),hold on,grid on,plot(x,y)
plot(tup,tup*0,'r.'),plot(tdown,tdown*0,'g.'),title(name),xlabel('time')

figure,plot(0.5:length(tup)-1,diff(tup),'r.'),hold on,plot(1:length(tdown)-1,diff(tdown),'g.'),grid on
title(name),xlabel('k'),ylabel('periodo')

t2=sort([tup;tdown]);
semip=diff(t2);
figure,plot(1:2:length(semip),semip(1:2:length(semip))*2,'.'),hold on,plot(semip*2)
plot(2:2:length(semip),semip(2:2:length(semip))*2,'r.'),grid on
title(name),xlabel('k'),ylabel('periodo')

data.tup=tup;
data.tdown=tdown;
data.semip=semip;

if typ > 1
    in.t=x;
    in.s=y;
    dt=0.0001;
    out=unif_poly_samp(in,dt,16,3);
    data.out=out;
    x=out.T;
    y=out.S;

    n=length(y);
    iiup=find(y(1:n-1).*y(2:n) < 0 & y(1:n-1) < 0);
    iidown=find(y(1:n-1).*y(2:n) < 0 & y(1:n-1) > 0);
    yup=iiup*0;
    ydown=iidown*0;
    tup=yup;
    tdown=ydown;

    for i = 1:length(iiup)
        iii=iiup(i);
        yy=y(iii-3:iii+3)+0.00001*(1:7);
        xx=x(iii-3:iii+3);
        tup(i)=spline(yy,xx,0);
    end

    for i = 1:length(iidown)
        iii=iidown(i);
        yy=y(iii-3:iii+3)+0.00001*(1:7);
        xx=x(iii-3:iii+3);
        tdown(i)=spline(yy,xx,0);
    end

    figure,plot(x,y,'.'),hold on,grid on,plot(x,y)
    plot(tup,tup*0,'r.'),plot(tdown,tdown*0,'g.')

    figure,plot(0.5:length(tup)-1,diff(tup),'.'),hold on,plot(1:length(tdown)-1,diff(tdown),'r.'),grid on

    t2=sort([tup, tdown]);
    semip=diff(t2);
    figure,plot(1:2:length(semip),semip(1:2:length(semip)),'.'),hold on,plot(semip)
    plot(2:2:length(semip),semip(2:2:length(semip)),'r.'),grid on
end
