function tf=iseven(n)
% tests if a number is even (for a single number)
%
%  tf=iseven(n)
%

% Sapienza Università di Roma
% Laboratorio di Segnali e Sistemi II
% Author: Sergio Frasca - 2017

if isnan(n)
    fprintf(' *** n is not a number \n')
    tf=[];
    return
end

if length(n) > 1
    fprintf(' *** n is an array \n')
    tf=[];
    return
end

if n-floor(n) ~= 0
    fprintf(' *** %f is not integer \n',n)
    tf=[];
    return
end

if floor(n/2)*2 == n
    tf=1;
else
    tf=0;
end