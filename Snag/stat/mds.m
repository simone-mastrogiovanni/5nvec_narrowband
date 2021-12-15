function [n,m,s,r,mi,ma]=mds(x)
%MDS  base statistics

n=length(x);
m=mean(x);
s=std(x);
r=m/s;
mi=min(x);
ma=max(x);

fprintf('          Statistics for array %s of length %d \n',inputname(1),n);
fprintf('mean %f - stdev %f - rat %f - min %f - max %f \n',m,s,r,mi,ma);