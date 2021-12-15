function g2out=side_gd2(in1,in2)
% side_gd2  compose a gd2 by posing side by side 2 other gd2s
%
%    g2out=side_gd2(in1,in2)

% Version 2.0 - march 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if in1.ini2 ~= in2.ini2
    fprintf('Different ini2: %d  %d \n',in1.ini2,in2.ini2)
    return
end

if in1.dx2 ~= in2.dx2
    fprintf('Different dx2: %d  %d \n',in1.dx2,in2.dx2)
    return
end

if in1.m ~= in2.m
    fprintf('Different m: %d  %d \n',in1.m,in2.m)
    return
end

ini=in1.ini;
nm1=in1.n/in1.m;
nm2=in2.n/in2.m;
    
if in1.type == 1
    if in1.dx ~= in2.dx
        fprintf('Different dx: %d  %d \n',in1.dx,in2.dx)
        return
    end
    
    fin=in2.ini+in2.dx*(nm2);
    nn=round((fin-ini)/in1.dx)+1;
    ii=round((in2.ini-ini)/in1.dx)+1;
    
    M=zeros(nn,in1.m);%[nn,ii,nm1,nm2]
    M(1:nm1,:)=in1.y;
    M(ii:ii+nm2-1,:)=in2.y;
    g2out=gd2(M);
    g2out=edit_gd2(g2out,'ini',in1.ini,'dx',in1.dx,'ini2',in1.ini2,'dx2',in1.dx2);
else 
    M=zeros(nm1+nm2,m);
    M(1:nm1,:)=in1.y;
    M(nm1+1:nm1+nm2,:)=in2.y;
    g2out=gd2(M);
    g2out=edit_gd2(g2out,'x',[in1.x in2.x],'ini',in1.ini,'dx',in1.dx,'ini2',in1.ini2,'dx2',in1.dx2);
end
