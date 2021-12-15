function imap_hist(m,x,y)
%IMAP_HIST   mapping an histo-map
%
%    m   the histo-map array
%    x   the x values (dimension of the first dim of m)
%    y   the y values (dimension of the second dim of m)

[na,nd]=size(m);

if size(x) == 1
    y=1:na;
end
if size(y) == 1
    x=1:nd;
end
y=y(length(y):-1:1);

figure;
image(x,y,m);
%image(m,'XData',x,'YData',y,'CDataMapping','scaled');
%axes('YDir','reverse'); % NON FUNZIONA
colorbar; % sporca la finestra di pss_explorer
%colormap cool;
grid on;zoom on;
%drawnow