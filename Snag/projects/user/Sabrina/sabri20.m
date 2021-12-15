% sabri20

ant.long=10.5;
ant.lat=43.63;
ant.azim=199.43;
sour.a=100;
sour.d=28;
eps=[0,1,5];
ant.type=2;
%source coord (VELA)
% sour.a=30.0;
sour.d=0;
eps=[0,1,5];
psi=[0,90,5];
fi=[0,360,10];
delta=-90
dd=9
nn=floor(180/dd)+1
iiii=0;
picmax(1:nn)=0;
picmaxamp(1:nn)=0;
bandmin=zeros(nn,5);
ibandmin=bandmin;
bandmax=bandmin;
ibandmax=bandmin;

while delta <= 90
    iiii=iiii+1;
    sour.d=delta;
    [lines orig]=ana_polar_lines(sour,ant,eps,psi,fi);

    bands=abs(lines).^2;
    
    for i = 1:5
        [a ia]=max(bands(:,i));
        bandmax(iiii,i)=a;
        ibandmax(iiii,i)=ia;
        [a ia]=min(bands(:,i));
        bandmin(iiii,i)=a;
        ibandmin(iiii,i)=ia;
    end

    [a ia]=max(max(bands)-min(bands));ia
    picmax(iiii)=ia;
    picmaxamp(iiii)=a;
    % [A,I]=sort(bands(:,ia));
    figure,hold on
    for i = 1:4
        ii=ia+i;
        if ii > 5
            ii=ii-5;
        end
        plot(bands(:,ia),bands(:,ii),'.','MarkerEdgeColor',rotcol(i))
    end
    title(sprintf('delta = %f   max a %d',delta,ia));
    hold off
    grid on
    delta=delta+dd
end

% figure,hold on
% 
% plot(abs(lines(:,1)).^2,angle(lines(:,1)),'.k')
% figure,
% plot(abs(lines(:,2)).^2,angle(lines(:,2)),'.r')
% figure,
% plot(abs(lines(:,3)).^2,angle(lines(:,3)),'.m')
% figure,
% plot(abs(lines(:,4)).^2,angle(lines(:,4)),'.b')
% figure,
% plot(abs(lines(:,5)).^2,angle(lines(:,5)),'.g')
% hold off
% 
% grid on
