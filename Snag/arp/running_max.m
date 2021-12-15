function out=running_max(in)
% RUNNING_MAX 
%

out=in;

for i=2:length(in)
    out(i)=max(out(i-1),in(i));
end
    