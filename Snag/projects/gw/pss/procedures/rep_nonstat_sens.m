% rep_nonstat_sens

cd D:\_SF\SF_DatAn\pss_datan\Quality\Sensitivities
load_sens

[ligH ligL]=parall_gd(LHO_S5,LLO_S5,0.5);

[vir ligH]=parall_gd(SensitivityH_WSR9,ligH,0.5);
figure,loglog(vir,'r',ligH,'g',ligL,'c'),grid on
title('Virgo and Ligo antenna noise')
xlabel('Hz')
xlim([10 7000])
ylim([10^-23 10^-16])

sens(1).h=vir;
sens(1).tobs=200;
sens(2).h=ligH;
sens(2).tobs=200;
sens(3).h=ligL;
sens(3).tobs=200;

sens1=sens(1);
sens2=sens(2);
sens3=sens(3);
[s1 eq1]=pss_ns_sens(sens1,3.8);
[s2 eq2]=pss_ns_sens(sens2,3.8);
[s3 eq3]=pss_ns_sens(sens3,3.8);
[s eq_nois]=pss_ns_sens(sens,3.8);

% figure,loglog(vir,'r',ligH,'g',ligL,'c',eq_nois,'k'),grid on
figure,loglog(eq1,'r',eq2,'g',eq3,'c',eq_nois,'k'),grid on
title({'Virgo and Ligo antenna noise and equivalent noise' ...
    sprintf('T_V=%d, T_L_H=%d, T_L_L=%d days',sens1.tobs,sens2.tobs,sens3.tobs)})
xlabel('Hz')
xlim([10 7000])
ylim([10^-23 10^-16])
figure,loglog(s1,'r',s2,'g',s3,'c',s,'k'),grid on
title({'PS Sensitivity - opt T_c_o_h' ...
    sprintf('T_V=%d, T_L_H=%d, T_L_L=%d days',sens1.tobs,sens2.tobs,sens3.tobs)})
xlabel('Hz')
xlim([10 7000])
ylim([10^-26 10^-19])

s1l=pss_ns_sens(sens1,3.8,3600*6);
s2l=pss_ns_sens(sens2,3.8,3600*6);
s3l=pss_ns_sens(sens3,3.8,3600*6);
sl=pss_ns_sens(sens,3.8,3600*6);

figure,loglog(s1l,'r',s2l,'g',s3l,'c',sl,'k'),grid on
title({'PS Sensitivity - T_c_o_h=6 hours' ...
    sprintf('T_V=%d, T_L_H=%d, T_L_L=%d days',sens1.tobs,sens2.tobs,sens3.tobs)})
xlabel('Hz')
xlim([10 7000])
ylim([10^-26 10^-19])

sensopt(1)=sens1;
sensopt(1).tobs=sens1;
sensopt(2)=sens2;
sensopt(1).tobs=100;
sensopt(2).tobs=100;
sensopt1=sensopt(1);
sensopt2=sensopt(2);

[sopt eq_noisopt]=pss_ns_sens(sensopt,3.8);
[s11 eq11]=pss_ns_sens(sensopt(1),3.8);
[s22 eq22]=pss_ns_sens(sensopt(2),3.8);

figure,loglog(eq11,'r',eq22,'g',eq_noisopt,'k'),grid on
title({'Virgo and Ligo antenna noise and equivalent noise' ...
    sprintf('T_V=%d, T_L_H=%d',sensopt(1).tobs,sensopt(2).tobs)})
xlabel('Hz')
xlim([10 7000])
ylim([10^-23 10^-16])