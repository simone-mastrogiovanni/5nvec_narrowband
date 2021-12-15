function vec=sparse2vec(sparse_str,isp,spsid,vsp)
%SPARSE2VEC  converts sparse vector format to vector format
%
%   isp             indexes of sparse vector
%   spsid           side vector (bigger indexes)
%   vsp             values of the non-zero elements
%   sparse_str      sparse vector structure
%
%   vec             uncoded vector

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

isp0=find(isp==0);
isp(isp0)=spsid;
isp=cumsum(isp);
vec=zeros(1,sparse_str.len);
if sparse_str.bin == 1
    vec(isp)=1;
else
    vec(isp)=vsp;
end