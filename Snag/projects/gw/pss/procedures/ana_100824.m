% ana_100824

gin=rough_clean(velaraw,-0.5,0.5,60)
gdcell=multi_extr(gin,[0.2 0.3;0.35 0.45; 0.5 0.6])
gin1=gin(1:9446400)
gin2=gin(9446401:16011028)

gdcell1=multi_extr(gin1,[0.2 0.3;0.35 0.45; 0.5 0.6])
gdcell2=multi_extr(gin2,[0.2 0.3;0.35 0.45; 0.5 0.6])