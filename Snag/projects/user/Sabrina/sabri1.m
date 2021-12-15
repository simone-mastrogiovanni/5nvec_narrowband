% sabri1

ant.long=10.5;
ant.lat=43.63;
ant.azim=199.43;
sour.a=5;
sour.d=28;
ant.type=2;
%source coord (VELA)
% sour.a=30.0;
 sour.d=65;
eps=[0,1,5];
psi=[0,90,5];
fi=[0,360,10];

[bands,varb]=ana_polar_spfilt(sour,ant,eps,psi,fi,1);

% figure,hold on
% plot(bands(:,1),bands(:,5),'.k')
% plot(bands(:,1),bands(:,2),'.r')
% plot(bands(:,1),bands(:,3),'.m')
% plot(bands(:,1),bands(:,4),'.b')
% hold off

[a ia]=max(max(bands)-min(bands));ia
[A,I]=sort(bands(:,ia));
figure,hold on
for i = 1:4
    ii=ia+i;
    if ii > 5
        ii=ii-5;
    end
    plot(bands(I,ia),bands(I,ii),'.','MarkerEdgeColor',rotcol(i)); % b r g k 
end
hold off
grid on