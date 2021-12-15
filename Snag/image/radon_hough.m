function [g,par]=radon_hough(pm,np,nq,inip,dp,iniq,dq,radlev)
%LIN_HOUGH  computes the hough transform for lines
%
%    g=lin_hough(pm,np,nq,inip,dp,iniq,dq)
%
%              pm                peak map or non-negative map
%    np,nq,inip,dp,iniq,dq       hough map parameters
%
%        y = p*x + q   ->   q = -x*p + y
%    radlev                      radon level (radlev(2) or more: params; def 0)
%                                 0 : hough  radlev(2) = threshold (def 0)
%                                 1 : hough with amplitude  radlev(2) = threshold (def 0, equiv. radon)
%                                 2 : radon with sigmoid  radlev(2:3) mu,sig of erf_sigmoid

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

par.parin=[np,nq,inip,dp,iniq,dq,radlev];
yy=y_gd2(pm);
par.ntot=n_gd2(pm);
        
g=zeros(np,nq);
switch radlev(1)
    case 0
        if length(radlev) > 1
            thr=radlev(2);
        else
            thr=0;
        end
        [ix,iy]=find(yy > thr);
        x=(ix-1)*dx_gd2(pm)+ini_gd2(pm);
        y=(iy-1)*dx2_gd2(pm)+ini2_gd2(pm);
        n=length(x(:));
        par.n=n;
        par.minx=min(x);
        par.maxx=max(x);
        par.miny=min(y);
        par.maxy=max(y);
        p=inip+(0:np-1)*dp;
        par.minp=min(p);
        par.maxp=max(p);
        q=-x.*p+y;
        par.minq=min(min(q));
        par.maxq=max(max(q));
        j=round((q-iniq)/dq)+1;
        par.minj=min(min(j));
        par.maxj=max(max(j));
        if par.maxj < 2
            fprintf(' *** maxj = %d \n',par.maxj)
        end
        if par.minj > nq
            fprintf(' *** minj = %d  > %d \n',par.minj,nq)
        end
        
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
    case 1
        if length(radlev) > 1
            thr=radlev(2);
        else
            thr=0;
        end
        [ix,iy]=find(yy > thr);
        x=(ix-1)*dx_gd2(pm)+ini_gd2(pm);
        y=(iy-1)*dx2_gd2(pm)+ini2_gd2(pm);
        n=length(x);

        for k = 1:n
            z=yy(ix(k),iy(k));
            for i = 1:np
                p=inip+(i-1)*dp;
                q=-x(k)*p+y(k);
                j=round((q-iniq)/dq)+1;
                if j > 0 & j <= nq
                    g(i,j)=g(i,j)+z;
                end
            end
        end
    case 2
        d=radlev(2);
        s=radlev(3);
        yy=erf_sigmoid(yy,d,s);
        [ix,iy]=find(yy);
        x=(ix-1)*dx_gd2(pm)+ini_gd2(pm);
        y=(iy-1)*dx2_gd2(pm)+ini2_gd2(pm);
        n=length(x);
        for k = 1:n
            z=yy(ix(k),iy(k));
            for i = 1:np
                p=inip+(i-1)*dp;
                q=-x(k)*p+y(k);
                j=round((q-iniq)/dq)+1;
                if j > 0 & j <= nq
                    g(i,j)=g(i,j)+z;
                end
            end
        end
end

g=gd2(g);

g=edit_gd2(g,'n',np*nq,'m',nq,'capt','Hough or Radon map',...
    'ini',inip,'dx',dp,'ini2',iniq,'dx2',dq);
par.n=n;