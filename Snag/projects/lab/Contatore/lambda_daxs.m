function y=lambda_daxs(xs,xd)
% calcola lambda da x-sorgente in x-rivelatore
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
    r2=((xs1-xd1).^2+(xs2-xd2).^2+(xs3-xd3).^2);
    y(i)=sum(1./r2);
end

y=y/ns2;
