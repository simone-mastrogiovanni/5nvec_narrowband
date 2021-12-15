function p=p_max_interv(data,thr,interv)
% evaluate the probability of having a certain value over a threshold
% in an interval
%
%   data     a one-dimensional array
%   thr      the threshold
%   interv   length of the interval (in sampling units)

N=length(data-interv);

n=floor(2*(N-1)/interv);
ini=floor(1+(0:n-1)*interv/2);
fin=floor(ini+interv-1);
i=find(fin > N);
fin(i)=N;

ii=0;

for i = 1:n
    if max(data(ini(i):fin(i))) >= thr
        ii=ii+1;
    end
end

p=ii/n;