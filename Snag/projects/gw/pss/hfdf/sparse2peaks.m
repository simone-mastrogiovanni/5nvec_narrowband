function peaks=sparse2peaks(A,typ)
% from a sparse GD to various peaks formats
%
%   A      sparse gd as created by read_peakmap
%   typ    =2 two columns [t fr]
%          =3 two columns [t fr w]

% Version 2.0 - October 2013 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

B=y_gd2(A);
cont=cont_gd2(A);
tim=x_gd2(A);
fr=x2_gd2(A);

[n1,n2]=size(B);
N=ceil(sum(nonzeros(B)));
tim=tim+cont.tim0;
switch typ
    case 2
        m=2;
    case 3
        m=3;
end
peaks=zeros(m,N);
n=0;

for i = 1:n1
    [ii jj w]=find(B(i,:));
    njj=length(jj);
    peaks(1,n+1:n+njj)=tim(i);
    peaks(2,n+1:n+njj)=fr(jj);
    if m == 3
        peaks(3,n+1:n+njj)=w;
    end
    n=n+njj;
end

peaks=peaks(1:m,1:n);