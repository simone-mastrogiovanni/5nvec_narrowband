function out=check_hmap(hmap)
%

out=struct();

y=y_gd2(hmap);
[n1,n2]=size(y);
[v,i1]=max(y');
fr=x_gd2(hmap);
sd=x2_gd2(hmap);

figure,plot(fr,v),grid on,hold on,plot(fr,v,'r.')
[vv,ii1]=max(v);
fprintf('max value %f at %f Hz \n',vv,fr(ii1))
out.max=vv;
out.frmax=fr(ii1);
figure,plot(sd(i1),'.')
figure,hist(sd(i1),unique(sd(i1)))