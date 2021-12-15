function peaks=row_2Dpeaks(A,thresh,nodith)
%
%  peaks=row_2Dpeaks(A,thresh,nodith)
%
%  nodith  =1 -> no dithering correction

% Version 2.0 - July 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('nodith','var')
    nodith=0;
end

[n1 n2]=size(A);

if nodith == 0
    aa=max(A(:))*1.e-9;
    peaks=zeros(n1+2,n2+2);
    peaks(2:n1+1,2:n2+1)=rand(n1,n2)*aa;
else
    peaks=zeros(n1+2,n2+2);
end
peaks(2:n1+1,2:n2+1)=peaks(2:n1+1,2:n2+1)+A;%size(peaks)

Or=diff(sign(diff(peaks,1,2)),1,2);
Ve=diff(sign(diff(peaks,1,1)),1,1);% Or(2:n1+1,:)+Ve(:,2:n2+1)

[i1,i2]=find(Or(2:n1+1,:)+Ve(:,2:n2+1) == -4);

peaks=zeros(n1,n2);

for i = 1:length(i1)
    a=A(i1(i),i2(i));
    if a >= thresh
        peaks(i1(i),i2(i))=a;
    end
end

peaks=sparse(peaks);