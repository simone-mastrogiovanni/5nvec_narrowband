function logplot_gd2(g2,ngr,mode)
% logplot   semilogy plots of a gd2 along the primary abscissa, for groups
% 
%    ngr    number of elements for each group  
%    mode   absent or something like '.'

% Version 2.0 - March 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('ngr')
    ngr=1;
end
if ~exist('mode')
    mode='';
end

[n1 n2]=size(g2.y);
x=x_gd2(g2);
y=zeros(n1,1);
k=0;

for i = 1:ngr:floor(n2/ngr)*ngr
    for j = 1:ngr
        y=y+g2.y(:,i+j-1);
    end
    y=y/ngr;
    ii=find(y);
    yy=y(ii);
    xx=x(ii);
    xx=xx-round(xx(1));
    k=k+1;
    [tcol colstr colchar]=rotcol(k);
    eval(['semilogy(xx,yy,''' colchar mode ''');'])
    hold on
end