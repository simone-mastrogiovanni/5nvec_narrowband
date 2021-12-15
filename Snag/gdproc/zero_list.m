function gout=zero_list(gin,list,typ)
% ZERO_LIST  zeroes a gd according to a list of time segments
%
%    gout=zero_list(gin,list)
%
%    gin     input gd
%    list    (2,n) array with start and stop
%    typ     type of operation: 1 normal, 2 using gd.cont for the beginning mjd
%            negative, keep on list
%
%    gout    output gd

[i N]=size(list);
y=y_gd(gin);
mi=min(real(y));
ma=max(real(y));
x=x_gd(gin);
n=length(x);

if typ < 0
    keep=1;
    typ=-typ;
else
    keep=0;
end
if typ == 2
    cont=cont_gd(gin);
    x=x-x(1);
    x=x/86400+cont.t0;
end
if keep == 1
    app=list(2,:);
    list(2,:)=list(1,:);
    list(1,2:N+1)=app;
    list(1,1)=x(10-1);
    list(2,N+1)=x(n)+1;
    N=N+1;
end

for i = 1:N
    disp(sprintf('%d  %f  %f  %f',i,list(1,i),list(2,i),(list(2,i)-list(1,i))*86400));
end

mit=min(x);
mat=max(x);

gout=gin;
ii1=0;ii2=0;
iii=0;

for i = 1:N
    t1=list(1,i);
    t2=list(2,i);
    if t2 <= t1 
        continue
    end
    if t1 > mat
        continue
    end
    if t2 < mit
        continue
    end
%     [C i1]=min(abs(x(ii1+1:n)-t1));
%     [C i2]=min(abs(x(ii2+1:n)-t2));
%     ii1=ii1+i1;
%     ii2=ii2+i2;

    [C i1]=min(abs(x-t1));
    [C i2]=min(abs(x-t2));
    iii=iii+1;
    ii(1,iii)=i1;
    ii(2,iii)=i2;
end

figure,plot(gin);hold on
[i N]=size(ii)
x=x_gd(gin);

for i = 1:N
    plot([x(ii(1,i)) x(ii(1,i))],[mi ma],'k')
    plot([x(ii(2,i)) x(ii(2,i))],[mi ma],'g')
    plot(x(ii(1,i):ii(2,i)),real(y(ii(1,i):ii(2,i))),'r');
end

but=questdlg('Do you want to proceed to zeroes the red segments ?');

if strcmp(but,'Yes')
    figure,plot(gin),hold on
    for i = 1:N
        y(ii(1,i):ii(2,i))=0;
        plot([x(ii(1,i)) x(ii(1,i))],[mi ma],'k')
        plot([x(ii(2,i)) x(ii(2,i))],[mi ma],'g')
    end
    
    gout=edit_gd(gout,'y',y);
end
    