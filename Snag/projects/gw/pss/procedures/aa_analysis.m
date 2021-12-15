% aa_analysis

nspet=1;
lfft=16384;
freq=640;
% freq=200;

% Benoit

g1=gd_sin('freq',freq,'len',1000000,'dt',0.00005);
s1=gd_pows(g1,'pieces',nspet,'resolution',4,'window',2,'short');
[g5,frfilt]=gd_decim(g1,5,lfft,1);

g5a=gd_sin('freq',freq,'len',200000,'dt',0.00025);

d5=g5-g5a;
dd5=y_gd(d5);
dd5=dd5(1601:198400);
dd5=gd(dd5);
dd5=edit_gd(dd5,'dx',0.00025,'ini',0.00025*1600);
sd5=gd_pows(dd5,'pieces',nspet,'resolution',4,'window',2,'short');

gg5=y_gd(g5);
gg5=gg5(1601:198400);
gg5=gd(gg5);
gg5=edit_gd(gg5,'dx',0.00025,'ini',0.00025*1600);
ss5=gd_pows(gg5,'pieces',nspet,'resolution',4,'window',2,'short');

gg5a=y_gd(g5a);
gg5a=gg5a(1601:198400);
gg5a=gd(gg5a);
gg5a=edit_gd(gg5a,'dx',0.00025,'ini',0.00025*1600);
ss5a=gd_pows(gg5a,'pieces',nspet,'resolution',4,'window',2,'short');

% Passuelo

freps=0.1;
% freps=0.5;
amp=1;
% amp=0.001;

b1=gd_sin('freq',freq+freps,'len',1000000,'dt',0.00005);
b1=amp*b1+g1;
sb1=gd_pows(b1,'pieces',nspet,'resolution',4,'window',2,'short');
[b5,frfilt]=gd_decim(b1,5,lfft,1);

b5a=gd_sin('freq',freq+freps,'len',200000,'dt',0.00025);
b5a=b5a+g5a;

bb5=y_gd(b5);
bb5=bb5(1601:198400);
bb5=gd(bb5);
bb5=edit_gd(bb5,'dx',0.00025,'ini',0.00025*1600);
sb5=gd_pows(bb5,'pieces',1,'resolution',4,'window',2,'short');

bb5a=y_gd(b5a);
bb5a=bb5a(1601:198400);
bb5a=gd(bb5a);
bb5a=edit_gd(bb5a,'dx',0.00025,'ini',0.00025*1600);
sb5a=gd_pows(bb5a,'pieces',1,'resolution',4,'window',2,'short');

% ramp

r1=0:0.2:199999;
r1=gd(r1);
r1=edit_gd(r1,'dx',0.2);

[r5,frfilt]=gd_decim(r1,5,lfft,1);
r5=gd(r5);

r5a=0:199999;
r5a=gd(r5a);
