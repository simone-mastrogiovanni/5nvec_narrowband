function [ra,rp]=v_ranking(v,minv,maxv)
% rank values preparation (use rank_v to rank values)
%
%  v           values
%  minv,maxv   min,max admitted values

% Version 2.0 - March 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('minv','var')
    minv=min(v);
end
if ~exist('maxv','var')
    maxv=max(v);
end
nv0=length(v);
ii=find(v >= minv & v <= maxv);
v=v(ii);
nv1=length(v);
fprintf(' %d values considered from %d  (%f) \n',nv1,nv0,nv1/nv0)

ra=sort(v);
nv=length(v);

rp=(nv:-1:1)/nv;