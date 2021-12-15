function set_on_figure(gin,lin)
% SET_ON_FIGURE  puts vertical line references

y=y_gd(gin);
miny=min(y);
maxy=max(y);

plot(gin),hold on

for i = 1:length(lin)
    plot([lin(i) lin(i)],[miny maxy],'r');
end
