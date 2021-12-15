function out=color_points(A,iclog,tits)
%
%    out=color_points(A,iclog)
%
%    A      (N,3) matrix [x y amplitude]
%    iclog   =1  log plot
%    tits    {title xlabel ylabel max} 
%             if exist max, symbol for max

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('iclog','var')
    iclog=0;
end
if ~exist('tits','var')
    tits={' ' ' ' ' '};
end

icmax=0;
if length(tits) > 3
    icmax=1;
end
res=50;
mi1=min(A(:,1));
ma1=max(A(:,1));
mi2=min(A(:,2));
ma2=max(A(:,2));
mi3=min(A(:,3));
ma3=max(A(:,3));
iv=(A(:,3)-mi3)/(ma3-mi3);

if iclog == 1
    miv=log10(mi3);
    mav=log10(ma3);
    iv=(log10(A(:,3))-miv)/(mav-miv);
end
    
figure,hold on,grid on
subplot(1,7,1:6)

for i = 1:res
    rgb=p2rgb((i-0.5)/res);
    ii=find(iv < i/res & iv > (i-1)/res);
    if ~isempty(ii)
        plot(A(ii,1),A(ii,2),'.','Color',rgb),hold on
    end
end
grid on
title(tits{1}),xlabel(tits{2}),ylabel(tits{3})
if (ma2-mi2) > 0 && (ma1-mi1) > 0
    rapfc2=(ceil(ma2)-floor(mi2))/(ma2-mi2);
    if rapfc2 < 1.2
        ylim([floor(mi2) ceil(ma2)])
    else
        ylim([mi2 ma2])
    end
    rapfc1=(ceil(ma1)-floor(mi1))/(ma1-mi1);
    if rapfc1 < 1.05
        xlim([floor(mi1) ceil(ma1)])
    else
        xlim([mi1 ma1])
    end
end

[aa jj]=max(A(:,3));
out.max=[A(jj,1),A(jj,2),A(jj,3)];
if icmax > 0
    plot(A(jj,1),A(jj,2),tits{4})
end

scale=[mi3 ma3 iclog];
subplot(1,7,7)
p2rgb_colormap(scale,0,1)
out.scale=scale;