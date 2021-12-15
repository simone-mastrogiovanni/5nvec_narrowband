function g=embed_gd(gin,a,k)
%EMBED_GD  embeds a gd in another (only virtual abscissa)
%
%    gin    input gd to be embedded
%    a      a double array or a gd to which gin is added, starting from k
%    k      starting index for embedding
%
%    g      output gd (dimension of a, dx of gin, ini recomputed)

% Version 2.0 - May 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isa(a,'gd')
    a=y_gd(a);
end

n=length(a);
if k > n
    printf(' *** k > n : no embedding !');
    return
end

g=gin;
b=y_gd(gin);
nin=n_gd(gin);
nin=min(nin,n-k+1);
a(k:k+nin-1)=a(k:k+nin-1)+b(1:nin);

g.y=a;
g.n=n;
g.ini=ini_gd(gin)-(k-1)*dx_gd(gin);
g.capt=[gin.capt ' embedded'];
