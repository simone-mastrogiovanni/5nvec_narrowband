function [d nearest]=divisors(n,num)
% DIVISORS  computes the divisors of a number n (excluding itself)
%
%   [d nearest]=divisors(n,num)
%
%   n      number for the search of divisors
%   num    number we search the nearest divisor (if present) 

nn=ceil(n/2);
nd=0;
d=[];
nearest=[];

for i = 2:nn
    if floor(n/i)*i == n
        nd=nd+1;
        d=[d i];
    end
end

if exist('num','var')
    rat=d/num;
    ii=find(rat<1);
    rat(ii)=1./rat(ii);
    [c,i]=min(rat);
    nearest=d(i);
end
    