function [mm,ii,n1,n2,pks,locsd,locfr]=bsd_find_peaks(yhfdf)

[n1,n2]=size(yhfdf); 

y=yhfdf(:,2:n2-1);
aa=sign(y-yhfdf(:,1:n2-2))+sign(y-yhfdf(:,3:n2));
[locfr,locsd,pks]=find((aa == 2).*y);
locsd=locsd+1;

S=sparse(locfr,locsd,pks,n1,n2);
[mm,ii]=max(S');

mm=full(mm);