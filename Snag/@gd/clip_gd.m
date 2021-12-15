function [gin,ii]=clip_gd(gin,minv,maxv,mode,val)
% gd trimming
%
%   gout=clip_gd(gin,minv,maxv.mode)
%
%  minv,maxv   min,max permitted values
%  mode        =0 zero or val
%              =1 preceding value (or val)
%              =2 clipping value
%  val         value for mode 0 or 1 (def 0)

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('val','var')
    val=0;
end

switch mode
    case 0
        ii=find(gin.y < minv | gin.y > maxv);
        gin.y(ii)=val;
    case 1
        ii1=0;
        if gin.y(1) < minv | gin.y(1) > maxv
            gin.y(1)=val;
            ii1=1;
        end
        ii=find(gin.y(2:gin.n) < minv | gin.y(2:gin.n) > maxv);
        ii=ii+1;
        for i = 1:length(ii)
            gin.y(ii(i))=gin.y(ii(i)-1);
        end
    case 2
        ii=find(gin.y < minv);
        gin.y(ii)=minv;
        ii2=find(gin.y > maxv);
        gin.y(ii2)=maxv;
        ii=[ii,ii2];
end