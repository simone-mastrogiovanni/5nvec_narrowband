function out_det=test_det_5vec(ant,sour,snr,n)
% mc on a 5-vect
%
%  ant   antenna
%  sour  source
%  snr   linear signal-to-noise ratio
%  n     mc dimension

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[L0 L45 CL CR v Hp Hc]=sour_ant_2_5vec(sour,ant,1);

out_det.ant=ant;
out_det.sour=sour;
out_det.snr=snr;
out_det.n=n;

A0=L0/norm(L0)^2;
A45=L0/norm(L45)^2;
B0=L0/norm(L0);
B45=L0/norm(L45);

V=v/norm(v);

for i = 1:n
    vn=(randn(1,5)+1j*randn(1,5))/sqrt(10);
    X=V*snr+vn;
    ha0(i)=X*A0';
    ha45(i)=X*A45';
    ha(i)=sqrt(abs(X*A45')^2+abs(X*A0')^2);
    hb0(i)=X*B0';
    hb45(i)=X*B45';
    hb(i)=sqrt(abs(X*B45')^2+abs(X*B0')^2);
    co=compare_5vec(V,X,0);
    loss(i)=co.loss;
    iloss(i)=1./co.loss;
end
  
out_det.ha0=ha0;   
out_det.ha45=ha45;   
out_det.hb0=hb0;   
out_det.hb45=hb45;
out_det.ha=ha;   
out_det.hb=hb;   
out_det.loss=loss;   
out_det.iloss=iloss;  