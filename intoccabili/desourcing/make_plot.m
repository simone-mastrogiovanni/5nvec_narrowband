sizes=size(AA);

for i=1:1:sizes(1)*sizes(2)
   distance(i)=sqrt((AA(i)*180/pi-source.a)^2+(DD(i)*180/pi-source.d)^2);
   overlap_6d_lin(i)=overlap_6d(i);
   overlap_9d_lin(i)=overlap_9d(i);
   overlap_15d_lin(i)=overlap_15d(i);
end
j=1
for res=0.01:0.01:1.01
    ii=find(distance>= res-0.01 & distance<=res);
    overlap_plot_6d(j)=max(overlap_6d_lin(ii));
    overlap_plot_9d(j)=max(overlap_9d_lin(ii));
    overlap_plot_15d(j)=max(overlap_15d_lin(ii));
    distance_plot(j)=res-0.01;
    j=j+1;
end

sizes=size(AA_30d);

for i=1:1:sizes(1)*sizes(2)
   distance_30(i)=sqrt((AA_30d(i)*180/pi-source.a)^2+(DD_30d(i)*180/pi-source.d)^2);
   overlap_30d_lin(i)=overlap_30d(i);
end

j=1
for res=max(distance_30)/100:max(distance_30)/100:max(distance_30)
    ii=find(distance_30>= res-max(distance_30)/100 & distance_30<=res);
    overlap_plot_30d(j)=max(overlap_30d_lin(ii));
    distance_plot_30d(j)=res-max(distance_30)/100;
    j=j+1;
end

sizes=size(AA_180d);

for i=1:1:sizes(1)*sizes(2)
   distance_180(i)=sqrt((AA_180d(i)*180/pi-source.a)^2+(DD_180d(i)*180/pi-source.d)^2);
   overlap_180d_lin(i)=overlap_180d(i);
end

j=1
for res=max(distance_180)/100:max(distance_180)/100:max(distance_180)
    ii=find(distance_180>= res-max(distance_180)/100 & distance_180<=res);
    overlap_plot_180d(j)=max(overlap_180d_lin(ii));
    distance_plot_180d(j)=res-max(distance_180)/100;
    j=j+1;
end

sizes=size(AA_365d);

for i=1:1:sizes(1)*sizes(2)
   distance_365(i)=sqrt((AA_365d(i)*180/pi-source.a)^2+(DD_365d(i)*180/pi-source.d)^2);
   overlap_365d_lin(i)=overlap_365d(i);
end

j=1
for res=max(distance_365)/100:max(distance_365)/100:max(distance_365)
    ii=find(distance_365>= res-max(distance_365)/100 & distance_365<=res);
    overlap_plot_365d(j)=max(overlap_365d_lin(ii));
    distance_plot_365d(j)=res-max(distance_365)/100;
    j=j+1;
end
