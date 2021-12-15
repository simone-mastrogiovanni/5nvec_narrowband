function g=lin_hough(pm,np,nq,inip,dp,iniq,dq)
%LIN_HOUGH  computes the hough transform for lines
%
%    g=lin_hough(pm,np,nq,inip,dp,iniq,dq)
%
%              pm                peak map
%    np,nq,inip,dp,iniq,dq       hough map parameters
%
%        y = p*x + q   ->   q = -x*p + y


% Version 1.0 - May 2002
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999-2002  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=zeros(np,nq);
[x,y]=find(y_gd2(pm));
n=size(x);
x=(x-1)*dx_gd2(pm)+ini_gd2(pm);
y=(y-1)*dx2_gd2(pm)+ini2_gd2(pm);

for k = 1:n
    for i = 1:np
        p=inip+(i-1)*dp;
        q=-x(k)*p+y(k);
        j=round((q-iniq)/dq)+1;
        if j > 0 & j <= nq
            g(i,j)=g(i,j)+1;
        end
    end
end

g=gd2(g);

g=edit_gd2(g,'n',np*nq,'m',nq,'capt','Hough map for a line',...
    'ini',inip,'dx',dp,'ini2',iniq,'dx2',dq);
