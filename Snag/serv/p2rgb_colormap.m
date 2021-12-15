function p2rgb_colormap(scale,typ,strtit)
% colormap for p2rgb
%
%    p2rgb_colormap(scale)
%
%   scale   [min max iclog] ; iclog = 1 log scale
%   typ     color type
%   strtit  title =1 only colormap

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('scale','var')
    scale(2)=1;
    scale(1)=0;
    scale(3)=0;
end
l=length(scale);
if l == 1
    scale(2)=scale;
    scale(1)=0;
    scale(3)=0;
elseif l == 2
    scale(3)=0;
end

if ~exist('typ','var')
    typ=0;
end

if ~exist('strtit','var')
    strtit=' ';
end

res=50;
ds=(scale(2)-scale(1))/res;
x=[0 0 1 1];
if ischar(strtit)
    figure
end

hold on
plot([0 0 1 1],[scale(1) scale(2) scale(2) scale(1)])
r=zeros(res+1,1);
g=r;b=g;

if scale(3) == 0
    for i = 0:res
        rgb=p2rgb(i/res,typ);
        r(i+1)=rgb(1);
        g(i+1)=rgb(2);
        b(i+1)=rgb(3);
        y=[i i+1 i+1 i]*ds+scale(1);
        fill(x,y,rgb)
    end
else
    y0=scale(1);
    ds=(scale(2)/scale(1))^(1/(res+1));
    for i = 0:res
        rgb=p2rgb(i/res,typ);
        r(i+1)=rgb(1);
        g(i+1)=rgb(2);
        b(i+1)=rgb(3);
        y1=y0*ds
        y=[y0 y1 y1 y0];
        y0=y1;
        fill(x,y,rgb)
    end
    set(gca,'Yscale','log')
end

ylim([scale(1) scale(2)]);
if ischar(strtit)
    title(strtit)
    figure,plot(r,'r'),hold on,grid on,plot(g,'g'),plot(b,'b'),title(strtit)
end