function out=circ_filter(b,a,X)
% circular filter (Matlab filter on ring data)
%
%     out=circ_filter(b,a,X)
%
%  b,a,X   see filter function 
%   X can be an array or a gd

% Version 2.0 - April 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if isnumeric(X)
    nenh=max(length(b),length(a));
    n=length(X);
    if nenh > n
        fprintf(' *** Error ! too long filter n = %d,  len.filter %d \n',n,nenh)
        return
    end
    X(n+1:n+nenh)=X(1:nenh);

    X=filter(b,a,X);
    out=X(nenh+1:nenh+n);
else
    X1=y_gd(X);
    out=circ_filter(b,a,X1);
    out=edit_gd(X,'y',out);
end
    