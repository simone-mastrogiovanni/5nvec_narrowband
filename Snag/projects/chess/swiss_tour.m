function out=swiss_tour(N,m,mod)
%
%    out=swiss_tour(N,m,mod)
% 
%   N           number of participants (even)
%   m           number of rounds
%   mod         mode structure
%      .inierr  error on iniscore

N=floor((N+1)/2)*2;
N2=N/2;
iniscore=1:N;
score=iniscore*0;
standing(1:2:N)=iniscore(1:N2);
standing(2:2:N)=iniscore(N:-1:N2+1);

