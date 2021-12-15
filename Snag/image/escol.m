function B=escol(A,c)
% ESCOL  esalta un colore in un'immagine
%
%   A   immagine
%   c   colore RGB [R G B]
%
%   B   matrice di uscita

A=double(A);
A1=A(:,:,1)-c(1);
A2=A(:,:,2)-c(2);
A3=A(:,:,3)-c(3);

B=sqrt(A1.^2+A2.^2+A3.^2);

minb=min(min(B));
maxb=max(max(B));
B=maxb-B;


% A1=A(:,:,1);
% A2=A(:,:,2);
% A3=A(:,:,3);
% 
% A0=sqrt(A1.^2+A2.^2+A3.^2);
% 
% A1=A1./A0;
% A2=A2./A0;
% A3=A3./A0;
% 
% c=c/sqrt(c(1)^2+c(2)^2+c(3)^2);
% 
% B=(A1*c(1)+A2*c(2)+A3*c(3));



minb=min(min(B));

figure,image((B-minb)*64/(1-minb)),colorbar
