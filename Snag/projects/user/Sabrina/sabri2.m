% sabri2

ant.long=10.5;
ant.lat=43.63;
ant.azim=199.43;
sour.a=5;
sour.d=28;
eps=[0,1,5];
ant.type=2;
%source coord (VELA)
% sour.a=30.0;
sour.d=0;
eps=[0,1,5];
psi=[0,90,5];
fi=[0,360,10];

[lines orig]=ana_polar_lines(sour,ant,eps,psi,fi);

bands=abs(lines).^2;

[a ia]=max(max(bands)-min(bands));ia
% [A,I]=sort(bands(:,ia));
figure,hold on
for i = 1:4
    ii=ia+i;
    if ii > 5
        ii=ii-5;
    end
    plot(bands(:,ia),bands(:,ii),'.','MarkerEdgeColor',rotcol(i))
end
hold off
grid on

figure,hold on

plot(abs(lines(:,1)).^2,angle(lines(:,1)),'.k')
figure,
plot(abs(lines(:,2)).^2,angle(lines(:,2)),'.r')
figure,
plot(abs(lines(:,3)).^2,angle(lines(:,3)),'.m')
figure,
plot(abs(lines(:,4)).^2,angle(lines(:,4)),'.b')
figure,
plot(abs(lines(:,5)).^2,angle(lines(:,5)),'.g')
hold off

grid on
