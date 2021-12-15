function p=sort_p_rank(v,minv,maxv)
% probability from ranking
% 
%    v          values array
%    minv,maxv  substitutes values out the limits with p=1

% Version 2.0 - April 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('minv','var')
    minv=min(v);
end
if ~exist('maxv','var')
    maxv=max(v);
end
n=length(v);
[~,~,ic] = unique(v);
ii1=find(v < minv);
ii2=find(v > maxv);

p=(n+1-ic)/length(v);
p(ii1)=1;
p(ii2)=1;