% run_date

% S5
S5_ini='04-Nov-2005';
S5_fin='20-Sep-2007';
S5_iniN=s2mjd(S5_ini);
S5_finN=s2mjd(S5_fin);
S5_iniN0=datenum(S5_ini);
S5_finN0=datenum(S5_fin);

% S6
S6_ini='07-Jul-2009';
S6_fin='20-Oct-2010';
S6_iniN=s2mjd(S6_ini);
S6_finN=s2mjd(S6_fin);
S6_iniN0=datenum(S6_ini);
S6_finN0=datenum(S6_fin);

% VSR1
VSR1_ini='18-May-2007';
VSR1_fin='01-Oct-2007';
VSR1_iniN=s2mjd(VSR1_ini);
VSR1_finN=s2mjd(VSR1_fin);
VSR1_iniN0=datenum(VSR1_ini);
VSR1_finN0=datenum(VSR1_fin);

% VSR2
VSR2_ini='07-Jul-2009';
VSR2_fin='08-Jan-2010';
VSR2_iniN=s2mjd(VSR2_ini);
VSR2_finN=s2mjd(VSR2_fin);
VSR2_iniN0=datenum(VSR2_ini);
VSR2_finN0=datenum(VSR2_fin);

% VSR3
VSR3_ini='11-Ago-2010'; 
VSR3_fin='19-Oct-2010';
VSR3_iniN=s2mjd(VSR3_ini);
VSR3_finN=s2mjd(VSR3_fin);
VSR3_iniN0=datenum(VSR3_ini);
VSR3_finN0=datenum(VSR3_fin);

% VSR4
VSR4_ini='03-Jun-2011';
VSR4_fin='05-Sep-2011';
VSR4_iniN=s2mjd(VSR4_ini);
VSR4_finN=s2mjd(VSR4_fin);
VSR4_iniN0=datenum(VSR4_ini);
VSR4_finN0=datenum(VSR4_fin);

figure,plot([S5_iniN0 S5_finN0],[1 1],'r','LineWidth',4),datetick('x',12)
hold on, grid on,ylim([0.5 1.3]),title('Ligo (red) and Virgo (green) Science Runs')
text((S5_iniN0+S5_finN0)/2-50,1.05,'S5')
plot([S6_iniN0 S6_finN0],[1 1],'r','LineWidth',4),datetick('x',12)
text((S6_iniN0+S6_finN0)/2-50,1.05,'S6')
plot([VSR1_iniN0 VSR1_finN0],[0.75 0.75],'g','LineWidth',4),datetick('x',12)
text(VSR1_iniN0-20,0.80,'VSR1')
plot([VSR2_iniN0 VSR2_finN0],[0.75 0.75],'g','LineWidth',4),datetick('x',12)
text(VSR2_iniN0-10,0.80,'VSR2')
plot([VSR3_iniN0 VSR3_finN0],[0.75 0.75],'g','LineWidth',4),datetick('x',12)
text(VSR3_iniN0-60,0.80,'VSR3')
plot([VSR4_iniN0 VSR4_finN0],[0.75 0.75],'g','LineWidth',4),datetick('x',12)
text(VSR4_iniN0-50,0.80,'VSR4')
