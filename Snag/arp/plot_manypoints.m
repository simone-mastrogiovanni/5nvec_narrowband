function plot_manypoints(x,y,typ,range,marker,how)
%PLOT_MANYPOINTS plots many points with different styles
%
%          plot_manypoints(x,y,typ,range,marker,how)
%
%      x,y      coordinates of points; if x = 0, scale of tipe
%      typ      type of single points (a real parameter)
%      range    [minx,maxx,miny,maxy]
%      marker   'x', 'o','+','.','<','>','^','v','s','d',...
%      how      'bitone','big','compl',...

% Version 2.0 - May 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(x); 
mi=min(typ);
ma=max(typ);
mami=ma-mi;
if mami <= 0
    mami=1;
end
eps=mami/50;

if length(range) >= 4
    if range(1) == range(2)
        range(1)=range(1)-1;
        range(2)=range(2)+1;
    end
    if range(3) == range(4)
        range(3)=range(3)-1;
        range(4)=range(4)+1;
    end
end

if length(x)==1 & length(typ) > 1
    figure, hold on
    for i = 1:length(typ)
        m=(typ(i)-mi)/mami;
        switch how
            case 'big'
                plot(i,typ(i),'marker',marker,'MarkerSize',m*10+1);
            case 'bitone'
                plot(i,typ(i),'marker',marker,'MarkerFaceColor',bicol(floor(m*99+1),100),...
                    'MarkerEdgeColor',bicol(floor(m*99+1),100));
        end
    end
    title('Event types')%,[0 length(typ)+1 mi-eps ma+eps]
    axis([0 length(typ)+1 mi-eps ma+eps]),grid on,hold off
    return
end

figure, hold on

for i = 1:n
    if (ma-mi) > 0
        m=(typ(i)-mi)/mami;
    else
        m=1;
    end
    switch how
        case 'big'
            plot(x(i),y(i),'marker',marker,'MarkerSize',m*10+1);
        case 'bitone'
            plot(x(i),y(i),'marker',marker,'MarkerFaceColor',bicol(floor(m*99+1),100));
    end
end
axis(range),grid on