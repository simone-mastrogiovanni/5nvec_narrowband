function [yy,y]=campo_daxs(xs,xd)
% calcola il campo da x-sorgente in x-rivelatore
%
%   xs    [3,n] celle della sorgente
%   xd    [3,n] posizioni del rivelatore

[ns1,ns2]=size(xs);
[nd1,nd2]=size(xd);
y=zeros(1,nd2);
xs1=xs(1,:);
xs2=xs(2,:);
xs3=xs(3,:);

for i = 1:nd2
    xd1=xd(1,i);
    xd2=xd(2,i);
    xd3=xd(3,i);
    r3=((xs1-xd1).^2+(xs2-xd2).^2+(xs3-xd3).^2).^1.5;
    y1(i)=sum((xd1-xs1)./r3);
    y2(i)=sum((xd2-xs2)./r3);
    y3(i)=sum((xd3-xs3)./r3);
end

y(1,:)=y1;
y(2,:)=y2;
y(3,:)=y3;
y=y/ns2;
yy=sqrt(y1.^2+y2.^2+y3.^2)/ns2;