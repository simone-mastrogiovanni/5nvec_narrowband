function c=minus(a,b)
% MINUS  difference for gd2s
%  
%     c=minus(a,b)
%

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics -  Sapienza Rome University

c=a;

if isnumeric(b)
    c.y=a.y-b;
    c.capt=['difference of ' a.capt ' and ' num2str(b)];
else
    [n1a,n2a]=size(a.y);
    [n1b,n2b]=size(b.y);

    if n1a == n1b & n2a == n2b
        c.capt=['difference of ' a.capt ' and ' b.capt];
        c.y=a.y-b.y;
    else
        error('Minus error: non-coherent gd2s (different dimensions)')
    end
end
