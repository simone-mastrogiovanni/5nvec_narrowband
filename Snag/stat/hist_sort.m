function [xout,b]=hist_sort(x,hi,nmax)
% HIST_SORT  sorts values of histograms

[b,ib]=sort(hi,'descend');

xout=x(ib);
b1=find(hi>0);

lb1=length(b1);
nmax=min(nmax,lb1);

xout=xout(1:nmax);
b=b(1:nmax);