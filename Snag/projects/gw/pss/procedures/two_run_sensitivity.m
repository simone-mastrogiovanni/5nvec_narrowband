% template m file two_run_sensitivity
%

% some coefficients computed with pss_run_basic_analysis.xls

tobs_c6=12;
tobs_c7=3;
redcoeff_c6=2.21;
redcoeff_c7=2.09;

% from two h_dens of two runs

xx=x_gd(h6);
yy1=redcoeff_c6*(y_gd(h6)*2.4E-3)*(120/tobs_c6)^0.25.*(xx/100).^0.125;
yy2=redcoeff_c7*(y_gd(h7)*2.4E-3)*(120/tobs_c7)^0.25.*(xx/100).^0.125;

yy=max(yy1,yy2);

sens=h6;
sens=edit_gd(sens,'y',yy,'capt','pss sensitivity');

sds_writegd('','c6-c7_coinc_sens.sds',sens)