function [dist,mindist,imin,maxdist,imax,nulldist]=candset_dist(cand1,cand2,mindist,dfr,dsd)

[n1,dummy]=size(cand1);
[n2,dummy]=size(cand2);
dist=zeros(n1,1);
nulldist=dist;

for i = 1:n1
    d=distance(cand1(i,:),cand2',dfr,dsd);
    ii=find(d);
    if ii > 0
        dist(i)=min(d(ii));
        ii=find(d<=mindist);
    else
        dist(i)=0;
    end
    jj=find(d==0);
    nulldist(i)=length(jj);
end

[maxdist,imax]=max(dist);
[mindist,imin]=min(dist);


function d=distance(const,arr,dfr,dsd)

Dlam=const(2)-arr(2,:);

d=sqrt(...
    ((const(1)-arr(1,:))/dfr).^2+...
    ((const(4)-arr(4,:))/dsd).^2+...
    (min(mod(Dlam,360),mod(-Dlam,360))./(abs(const(7))+abs(arr(7,:)))).^2+...
    ((const(3)-arr(3,:))./(abs(const(8))+abs(arr(8,:)))).^2 ...
    );