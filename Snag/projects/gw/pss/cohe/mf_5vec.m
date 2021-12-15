function mf=mf_5vec(dat,sig)
% MF_5VEC  computes the matched filter for 5-vecs
%          it works for any dimension
%
%   mf=mf_5vec(dat,sig);
%
%    dat   data 5-vec
%    sig   signal 5-vec

mf=sum(dat.*conj(sig))/sum(abs(sig).^2);