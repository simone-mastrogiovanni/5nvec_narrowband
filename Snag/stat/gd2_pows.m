function out=gd2_pows(in,res,rec)
% 2-D power spectrum (for type-1 gd2)
%
%   in    input gd2 or matrix 
%   res   [resx resy] resolution enhancement
%   rec   > 0 -> recenter the spectrum; < 0 no mean subtraction

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if length(res) == 1
    res=[res res];
end

if ~exist('rec','var')
    rec=0;
end

y=y_gd2(in);
if rec > 0
    y=y-mean(y);
end
rec=abs(rec);

dx1=dx_gd2(in);
dx2=dx2_gd2(in);

[n1,n2]=size(y);

N1=round(n1*res(1)/2)*2;
N2=round(n2*res(2)/2)*2;

Y=zeros(N1,N2);

Y(1:n1,1:n2)=y;

Y=abs(fft2(Y));

df1=1/(dx1*N1);
df2=1/(dx2*N2);
ini1=0;
ini2=0;

if rec > 0
    y=Y;
    Y(1:N1/2,:)=y(N1/2+1:N1,:);
    Y(N1/2+1:N1,:)=y(1:N1/2,:);
    y=Y;
    Y(:,1:N2/2)=y(:,N2/2+1:N2);
    Y(:,N2/2+1:N2)=y(:,1:N2/2);
    ini1=-N1*df1/2;
    ini2=-N2*df2/2;
end

out=gd2(Y);

out=edit_gd2(out,'dx',df1,'dx2',df2,'ini',ini1,'ini2',ini2);