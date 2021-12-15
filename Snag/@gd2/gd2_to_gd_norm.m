function g1=gd2_to_gd_norm(g2,i1,i2)
% gd2_to_gd_norm  extracts data from a gd2 to a gd along primary abscissa, 
%                 normalizing on the x and cutting zeroes on the y
%
%      g1=gd2_to_gd_norm(g2,i1,i2)
%
%    g2     input gd2
%    i1     [min,max] primary ascissa choice (0 no choice)
%    i2     [min,max] secondary ascissa normalized mean (0 -> all)

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

M=g2.y;
typ=g2.type;
t=x_gd2(g2);

[n1 n2]=size(M);
if length(i1) == 1
    if i1 == 0
        i1=[1 n1];
    else
        disp(' *** error on i1')
        return
    end
end
if length(i2) == 1
    if i2 == 0
        i2=[1 n2];
    else
        i2=[i2 i2];
    end
end
M=M(i1(1):i1(2),i2(1):i2(2));
[n1 n2]=size(M);

for i = i2(1):i2(2)
    y1=M(:,i);
    ii=find(y1);
    M(:,i)=y1/mean(y1(ii));
end

%figure,imagesc(M)
iii=0;

for i = i1(1):i1(2)
    y1=M(i,:);
    ii=find(y1);
    if ~isempty(ii)
        iii=iii+1;
        m=mean(y1(ii));
        x(iii)=t(i);
        y(iii)=m;
    end 
end

g1=gd(y);
g1=edit_gd(g1,'x',x);