function cand=read_piasourcefile(fil)
% READ_PIASOURCEFILE

if ~exist('fil','var')
    fil=selfile(' ');
end

A=readascii(fil,1,5);

figure,plot(A(:,1),A(:,2),'o');
axis([0 360 -90 90]), grid on

figure,semilogy(A(:,3),A(:,4),'x'); grid on

[n,i1]=size(A);
cand=zeros(7,n);
ai=A(:,1);
di=A(:,2);

[ao do]=astro_coord('equ','ecl',ai,di);
ao=mod(ao,360);

cand(1,:)=A(:,3);
cand(2,:)=ao;
cand(3,:)=do;
cand(4,:)=A(:,5);
cand(7,:)=A(:,4);