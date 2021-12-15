function [A cont]=gd2_to_peaks(gA,thresh)
% from a (typically sparse) gd2 to a list of peaks
%
%     A=gd2_to_peaks(gA,thresh)
% 
%   gA       input gd2
%   thresh   threshold (def 0) or, if 2 elements, thresholds
%
%   A(n,3)   x,y,v

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('thresh','var')
    thresh=0;
end

M=y_gd2(gA);
x=x_gd2(gA);
x2=x2_gd2(gA);
cont=cont_gd2(gA);

if length(thresh) == 1
    [ii jj]=find(M > thresh);
else
    [ii jj]=find(M > thresh(1) & M < thresh(2));
end

N=length(ii);
A=zeros(N,3);

A(:,1)=x(ii);
A(:,2)=x2(jj);