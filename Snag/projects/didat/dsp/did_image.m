% did_image

nim=512;
par=[[1 1];[1 1];[nim nim]];
parc=[par;[200 300];[50 56]]
parn=[par;[0 1]]
nois=gd_image(parn,'gaussnoise',1);
circ=gd_image(parc,'circle',1);

snr=0.25;
cn=snr*circ+nois;

sp_circ=(abs(fft2(circ)).^2)/nim^2;

ac_circ=ifft2(sp_circ);

fil_circ=ifft2(fft2(cn).*sp_circ/max(sp_circ(:)));

circ1=gd_image([par;[100 150];[50 56]],'circle',1);
circ2=gd_image([par;[250 180];[50 56]],'circle',1);
circ3=gd_image([par;[300 300];[50 56]],'circle',1);
circ4=gd_image([par;[80 420];[50 56]],'circle',1);
circ5=gd_image([par;[420 100];[50 56]],'circle',1);

circn=circ1+circ2+circ3+circ4+circ5;
cnn=snr*circn+nois;

fil_circn=ifft2(fft2(cnn).*sp_circ/max(sp_circ(:)));

ccirc=im_torus_rot(circ,300,200);
fccirc=fft2(ccirc);
fccircC=conj(fccirc);
mf=ifft2(fft2(cnn).*fccircC);
mf1=mf.*abs(mf).^3;
mff=ifft2(fft2(mf1).*fccircC);
