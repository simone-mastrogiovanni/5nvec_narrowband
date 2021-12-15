function c=plus(a,b)
% PLUS  sum for gd2s
%  
%     c=plus(a,b)
%

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics -  Sapienza Rome University

c=a;

if isnumeric(b)
    c.y=a.y+b;
    c.capt=['sum of ' a.capt ' and ' num2str(b)];
else
    [n1a,n2a]=size(a.y);
    [n1b,n2b]=size(b.y);

    c=a;

    if n1a == n1b & n2a == n2b
        c.capt=['sum of ' a.capt ' and ' b.capt];
        c.y=a.y+b.y;
    else
        error('Sum error: non-coherent gd2s (different dimensions)')
    end
end