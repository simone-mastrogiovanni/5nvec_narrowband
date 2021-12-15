function [fr,sdmin,sdmax]=psc_readfr(candvect)
%PSC_READFR  reads frequencies from candidate files (and computes the
%            number of sd parameters)
%
%   [fr,sdmin,sdmax]=psc_readfr(candvect)
%
% In the files the data are read as UInt16 
%
%   candvect   contains single candidates information as groups of 8 uint16
%              the first 2 uint contain the frequency information
%
%   fr         frequency
%   sdmin,sdmax   min max spin down parameter numbers

n=length(candvect);
fr=(candvect(1:8:n)+65536*candvect(2:8:n))*0.000001;fr=fr';

sdmin=min(candvect(5:8:n));
sdmax=max(candvect(5:8:n));