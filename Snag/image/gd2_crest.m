function [cr1,cr2,cr0]=gd2_crest(g2,sym1,sym2)
% computes and plots crests of a gd2
%
%    g2     a gd2
%    sym1   if present, plots on the opened gd2 map (dim 1; ex.: 'rx')
%    sym2   if present, plots on the opened gd2 map (dim 2)

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

y=y_gd2(g2);
x=x_gd2(g2);
x2=x2_gd2(g2);

[M1,I1]=max(y); % size(M1),size(x2),size(x(I1)),size([x2,x(I1),M1'])
[M0,I0]=max(M1);

cr1=[x2,x(I1),M1'];
[M2,I2]=max(y');
cr2=[x,x2(I2),M2'];

[x,y,v]=max_gd2(g2);
cr0=[x,y,v];

if exist('sym1','var')
    hold on,plot(cr1(:,2),cr1(:,1),sym1)
    plot(cr0(1),cr0(2),'-p','MarkerSize',15,'MarkerFaceColor','y','MarkerEdgeColor','b')
end
if exist('sym2','var')
    hold on,plot(cr2(:,1),cr2(:,2),sym2)
end