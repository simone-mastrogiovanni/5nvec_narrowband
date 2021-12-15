% sabri3

ant.long=10.5;
ant.lat=43.63;
ant.azim=199.43;
sour.a=5;
sour.d=16;
ant.type=2;
%source coord (VELA)
sour.a=30.0;
sour.d=12;
eps=[0.5,1,2];
psi=[20,90,2];
fi=[30,360,2];

[lines orig]=fit_polar_lines(sour,ant,eps,psi,fi);

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
