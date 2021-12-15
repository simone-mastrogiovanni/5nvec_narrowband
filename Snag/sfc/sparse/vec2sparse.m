function [isp,spsid,vsp,sparse_str]=vec2sparse(vec,sparse_str)
%VEC2SPARSE  codes a vector in snag sparse format
%
%   vec             sparse vector
%   sparse_str      sparse vector structure
%           .stat   status word
%           .bin    =1 binary, =0 non-binary
%           .spar   =1 sparse, =0 non sparse
%           .deriv  =1 derived, =0 normal
%           .dimen  dimension (8, 16, 32)
%           .logx   =1 logx format for non-zero elements
%           .len    =length of original vector
%           .slen   number of non-zero elements
%           .sidlen length of the side vector with the
%
%   isp             indexes of sparse vector
%   spsid           side vector (bigger indexes)
%   vsp             values of the non-zero elements

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ind=find(vec);
n=length(ind);
sparse_str.len=n;
dimen=2^sparse_str.dimen-2;

isp=zeros(1,n);
isp(1)=ind(1);
isp(2:n)=diff(ind);
vsp=vec(ind);

spsid=isp(isp>dimen);
isp(isp>dimen)=0;

sparse_str.slen=length(isp);
sparse_str.sidlen=length(spsid);