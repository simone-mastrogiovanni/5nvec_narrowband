function g=leggipia_simp
% legge in formato x1,y1,x2,y2,.... e produce un gd

file=selfile(' ');

% fid=fopen(file);

g=load(file);size(g)

% dx=g(3)-g(1);
% ini=g(1);
% g=g(2:2:length(g));
dx=g(2,1)-g(1,1);
ini=g(1,1);
g=g(:,2);

g=gd(g);
g=edit_gd(g,'dx',dx,'ini',ini,'capt',['from ' file]);