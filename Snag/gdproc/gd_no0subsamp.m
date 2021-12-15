function gout=gd_no0subsamp(gin,red)
% GDNO0SUBSAMP  subsamples a gd, zeroing 0 points
%
%   gin   input gd
%   red   reduction factor

% Version 2.0 - August 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

y=y_gd(gin);
nin=n_gd(gin);
ty=type_gd(gin);
gout=zeros(1,floor(nin/red));
j=0;

if ty == 1
    for i = 1:red:nin-red
        j=j+1;
        yy=y(i:i+red-1);
        ii=find(yy);
        if length(ii) == red
            gout(j)=mean(yy);
        else
            gout(j)=0;
        end
    end
    gout=edit_gd(gin,'y',gout,'dx',red*dx_gd(gin),'ini',ini_gd(gin)+red*dx_gd(gin)/2);
else
    x=x_gd(gin);
    xout=gout;
    for i = 1:red:nin-red
        yy=y(i:i+red-1);
        xx=x(i:i+red-1);
        ii=find(yy);
        if length(ii) == red
            j=j+1;
            gout(j)=mean(yy);
            xout(j)=mean(xx);
        end
    end
    xout=xout(1:j);
    gout=gout(1:j);
    gout=edit_gd(gin,'y',gout,'x',xout);
end