% show_optmap

ND=10;

[x1,b1]=pss_optmap_new(ND);

figure,plot(x1(:,1),x1(:,2),'.'),grid on,title('Ecliptical coordinates')

[al del]=astro_coord_fix('ecl','equ',x1(:,1),x1(:,2));
figure,plot(al,del,'.'),grid on,title('Equatorial coordinates')
