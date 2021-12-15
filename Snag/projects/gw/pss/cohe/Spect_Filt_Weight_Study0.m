% Spect_Filt_Weight_Study
% virgo coordinate %
deps=0.0001;
ant.long=10.5;
ant.lat=43.63;
ant.azim=199.43;
ant.type=2;
%source coord (VELA)
sour.a=5;
sour.d=28;
eps=[0,1,5];
psi=[0,90,5];
fi=[0,360,10];
N=eps(3)*fi(3)*psi(3)
[bands,varb]=ana_polar_spfilt(sour,ant,eps,psi,fi,1);
% BAND0=bands;
% VARB0=varb;
% EPS=[eps(1)+deps,eps(2)+deps,eps(3)]
% [bands,varb]=ana_polar_spfilt(sour,ant,EPS,psi,fi,1);


% j=1:eps(3);
% EPS=(j-1)*(eps(2)-eps(1))/eps(3)%+eps(1)
% for k=1:eps(3)
%  [bands,varb]=ana_polar_spfilt(sour,ant,[EPS(k),EPS(k)+0.001,1],psi,fi,1);
%  BandDep(1+(k-1)*(N/eps(3)):k*(N/eps(3)),:)=bands;
% end

[a ia]=max(max(bands)-min(bands));
[A,I]=sort(bands(:,ia));
figure,hold on
for i = 1:4
    ii=ia+i;
    if ii > 5
        ii=ii-5;
    end
    plot(bands(I,ia),bands(I,ii),'.','MarkerEdgeColor',rotcol(i))
end
grid on

% figure,plot(bands(:,1)+bands(:,2)+bands(:,3)+bands(:,4)+bands(:,5))
