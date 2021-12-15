function rl=radpat_loss(ant,n)
%RADPAT_LOSS  computes the radiation pattern loss in h for all the declinations,
%             in the range between 0 and 90 degrees
%
%   ant   antenna structure
%   n     number of points 

d=(0:n-1)*90/n;
rl=d;

sour.a=0;
sour.eps=0;
sour.psi=0;

for i = 1:n
    sour.d=d(i);
    sr=sid_resp(ant,sour,360);
    rl(i)=sqrt(mean(sr));
end