function c=times(a,b)
% TIMES  multiplication for gd2s
%  
%     c=times(a,b)
%

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics -  Sapienza Rome University

c=a;disp('ciao')

if isnumeric(b)
    c.y=a.y*b;
    c.capt=['product of ' a.capt ' and ' num2str(b)];
elseif isnumeric(a)
    c=b;
    c.y=b.y*a;
    c.capt=['product of ' b.capt ' and ' num2str(a)];
else
    [n1a,n2a]=size(a.y);
    [n1b,n2b]=size(b.y);

    c=a;

    if n1a == n1b & n2a == n2b
        c.capt=['product of ' a.capt ' and ' b.capt];
        c.y=a.y.*b.y;
    else
        error('Product error: non-coherent gd2s (different dimensions)')
    end
end