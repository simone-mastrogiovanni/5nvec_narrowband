function data=data_period_film(x,y)
% DATA_PERIOD  analyzes periodicity of x-y data
%
%     data=data_period(x,y,typ)
%
%   x,y     input data; if absent, interactive
%           if x is a string, open a pasco file and take data

% Project LabMec - part of the toolbox Snag - April 2014
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

warning('off','all');
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
tup=yup;
nup=length(iiup);
per=0;
ymi=10^6;
yma=-10^6;

figure

for i = 1:nup
    iii=iiup(i);
    yy=y(iii-2:iii+2)+0.00001*(1:5)';
    xx=x(iii-2:iii+2);
    
    tup(i)=spline(yy,xx,0);
    
    if i > 1
        if iiup(i)-iiup(i-1) > 6
            xx=x(iiup(i-1):iiup(i)+1)-tup(i-1);
            yy=y(iiup(i-1):iiup(i)+1);
            plot(xx,yy),title(sprintf('periodo %d',i-1)),grid on
            hold on,plot(xx,yy,'r.'),hold off
            per=max(per,tup(i)-tup(i-1));
            xlim([0 per])
            ymi=min(ymi,min(yy)-0.05);
            yma=max(yma,max(yy)+0.05);
            ylim([ymi yma])
            pause(1)
        end
    end
end
