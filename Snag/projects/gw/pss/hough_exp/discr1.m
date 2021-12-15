function k=discr1(v,x)
%DISCR1   discrete value for one dimension
%
% Problem :
%
% I have a number x to be represented by a sample of the set v : which
% sample of the set should be used ?
%
%      k=discr1(v,x)
%
%   v   array containing the discretized values
%   x   value to be discretized
%
%   k   index of v such that v(k) is the nearest to x

[x1,k]=min(abs(v-x));