function cand1=psc_sortcand(cand)
%PSC_SORTCAND  sorts candidate arrays of different types
%
%    cand1=psc_sortcand(cand)

icstr=0;
if isstruct(candin)
    ca=cand;
    icstr=1;
    cand=cand.cand;
end

[i1,i2]=size(cand);

if i1 == 8 & i2 > 1
    cand1=sortrows(cand',[2 1]);
    cand1=cand1';
else if == 7 & i2 > 1
    cand1=sortrows(cand',1);
    cand1=cand1';
else
    nn=length(cand)/8;
    cand1=reshape(cand,8,nn);
    cand1=sortrows(cand1',[2 1]);
    cand1=cand1';
    cand1=cand1(:);
end

if icstr > 0
    ca.cand=cand1;
    cand1=ca;
end