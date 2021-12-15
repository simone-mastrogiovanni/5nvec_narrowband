function [ii,mm,n1,n2,pks,loc]=bsd_find_peaks(yhfdf)

[n1,n2]=size(yhfdf); 

y=yhfdf';
y=y(:); % n1,n2,figure,plot(y)

[pks,loc]=findpeaks(y);

locsd=mod(loc,n2)+1;
locfr=ceil(loc/n2);

S=sparse(locfr,locsd,pks,n1,n2);
[mm,ii]=max(S');

mm=full(mm);