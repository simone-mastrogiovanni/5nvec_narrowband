% crea_shape_1

x1=readascii('D:\SF_DatAn\burst\info\sinegaussian_width_0.01038_sigma_0.00519_Q_15_f0_460_hrss_1_sampling_20000.txt',0,1);
[aa ii]=max(x1);
sfr=20000;
shape1=gd(x1);
shape1=edit_gd(shape1,'dx',1/sfr,'ini',-(ii-1)/sfr);

x1=readascii('D:\SF_DatAn\burst\info\sinegaussian_width_0.00519_sigma_0.002595_Q_15_f0_920_hrss_1_sampling_20000.txt',0,1);
[aa ii]=max(x1);
sfr=20000;
shape2=gd(x1);
shape2=edit_gd(shape2,'dx',1/sfr,'ini',-(ii-1)/sfr);

x1=readascii('D:\SF_DatAn\burst\info\gaussian_width_0.002_sigma_0.001_hrss_1_sampling_20000.txt',0,1);
[aa ii]=max(x1);
sfr=20000;
shape3=gd(x1);
shape3=edit_gd(shape3,'dx',1/sfr,'ini',-(ii-1)/sfr);




