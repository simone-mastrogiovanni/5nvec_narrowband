% an_flusso
%
% unità CGS

unc=0.1;
S=208/62;
i=0;
clear data fl vel P data2 dat2

while 1
    i=i+1;
    [t,s,dt,n,comm]=leggi_pasco;
    str1=comm{1};
    iclun=findstr(str1,'lunghezza');
    if isempty(iclun)
        ans=inputdlg('Lunghezza capillare (in mm) ?');
        lun=eval(ans{1});
    else
        str=str1(iclun+9:length(str1));
        lun=sscanf(str,'%f');
    end
    icdiam=findstr(str1,'diametro');
    if isempty(icdiam)
        ans=inputdlg('Diametro capillare (in mm) ?');
        diam=eval(ans{1});
    else
        str=str1(icdiam+8:icdiam+8+5);
        diam=sscanf(str,'%f');
    end
    diam=diam/10;
    capsec=pi*(diam/2)^2;
    data(i)=data_polyfit(t,s,unc,0,4);
    maxlev=max(data(i).y)*1.01;
    maxlev=max(maxlev,200);
    a=data(i).a;
    afl=polyder(a);
    fl1=polyval(afl,data(i).x);
%     fl(i,1:length(data(i).x))=fl1;
%     vel(i,1:length(fl1))=fl1./capsec;
    fl{i}=fl1;
    vel{i}=fl1./capsec;
    Re{i}=diam*fl1./(capsec*0.01003);
    P1=(maxlev-data(i).y)/S;
%     P(i,1:length(data(i).x))=P1;
    P{i}=P1;
%     figure,plot(P1,fl1),grid on;
    disp('____________________________________')
    str=sprintf(' pezzo %d  coefficienti ',i);
    for j = 1:length(data(i).a)
        str1=sprintf(' %f,  ',data(i).a(j));
        str=[str str1];
    end
    disp(str)
    
    str=sprintf('             incertezze ',i);
    for j = 1:length(data(i).a)
        str1=sprintf(' %f,  ',data(i).aunc(j));
        str=[str str1];
    end
    disp(str)
    
    prob=1-chi2cdf(data(i).chiq,data(i).ndof);
    str=sprintf('    chi quadro %f   N.g.l. %d    probabilità = %f ',...
        data(i).chiq,data(i).ndof,prob);
    disp(str)
    
    str=sprintf('   residui : media e dev. standard = %f  %f ',...
        data(i).meanres,data(i).stdres);
    disp(str)
     
    risp=questdlg('Ancora ?');
    if risp(1) ~= 'Y'
        break
    end
end

N=i;

figure

for i = 1:N
    tcol=rotcol(i);
    plot(P{i},vel{i},'color',tcol),hold on,grid on
    plot(P{i},vel{i},'color',tcol,'Marker','.')
end

xlabel('Pressione (g_peso/cm^2)'),ylabel('Velocità (cm/s)')

figure

for i = 1:N
    tcol=rotcol(i);
    plot(P{i},Re{i},'color',tcol),hold on,grid on
end

xlabel('Pressione (g_{peso}/cm^2)'),ylabel('Numero di Reynolds')

% for i = 1:N
%     clear data2
%     x=P{i};
%     y=vel{i};
%     data2=data_polyfit(x,y,min(abs(diff(y))),3,1);
%     dat2{i}=data2;
%     for k = 1:length(data2)
%         disp('.........................................')
%         str=sprintf(' pezzo %d  coefficienti ',i);
%         na=length(data2(k).a);
%         for j = 1:na
%             str1=sprintf(' %f,  ',data2(k).a(j));
%             str=[str str1];
%         end
%         disp(str)
% 
%         str=sprintf('   residui : media e dev. standard = %f  %f ',...
%             data2(k).meanres,data2(k).stdres);
%         disp(str)
%     end
% end