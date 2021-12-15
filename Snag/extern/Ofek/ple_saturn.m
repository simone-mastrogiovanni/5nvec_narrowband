function [L,B,R]=ple_saturn(Date)
%------------------------------------------------------------------------------
% ple_saturn function                                                    ephem
% Description: Low accuracy planetray ephemeris for Saturn. Calculate
%              Saturn heliocentric longitude, latitude and radius
%              vector referred to mean ecliptic and equinox of date.
%              Accuarcy: ~1' in long/lat, ~0.001 au in dist.
% Input  : - matrix of dates, [D M Y frac_day] per line,
%            or JD per line. In TT time scale.
% Output : - Longitude in radians.
%          - Latitude in radians.
%          - Radius vector in au.
% Reference: VSOP87
% See also: ple_planet.m
% Tested : Matlab 5.3
%     By : Eran O. Ofek                   October 2001
%    URL : http://wise-obs.tau.ac.il/~eran/matlab.html
% Reliable: 2
%------------------------------------------------------------------------------


RAD = 180./pi;

FunTPI = inline('(X./(2.*pi) - floor(X./(2.*pi))).*2.*pi','X');

SizeDate = size(Date);
N        = SizeDate(1);
ColN     = SizeDate(2);

if (ColN==4),
   JD = julday(Date).';
elseif (ColN==1),
   JD = Date;
else
   error('Illigal number of columns in date matrix');
end

Tau = (JD - 2451545.0)./365250.0;

SumL0 = 87401354 ...
   + 11107660.*cos(3.96205090 + 213.29909544.*Tau) ...
   + 1414151.*cos(4.5858152 + 7.1135470.*Tau) ...
   + 398379.*cos(0.521120 + 206.185548.*Tau) ...
   + 350769.*cos(3.303299 + 426.598191.*Tau) ...
   + 206816.*cos(0.246584 + 103.092774.*Tau) ...
   + 79271.*cos(3.84007 + 220.41264.*Tau) ...
   + 23990.*cos(4.66977 + 110.20632.*Tau) ...
   + 16574.*cos(0.43719 + 419.48464.*Tau) ...
   + 15820.*cos(0.93809 + 632.78374.*Tau) ...
   + 15054.*cos(2.71670 + 639.89729.*Tau) ...
   + 14907.*cos(5.76903 + 316.39187.*Tau) ...
   + 14610.*cos(1.56519 + 3.93215.*Tau) ...
   + 13160.*cos(4.44891 + 14.22709.*Tau) ...
   + 13005.*cos(5.98119 + 11.04570.*Tau) ...
   + 10725.*cos(3.12940 + 202.25340.*Tau) ...
   + 6126.*cos(1.7633 + 277.0350.*Tau) ...
   + 5863.*cos(0.2366 + 529.6910.*Tau) ...
   + 5228.*cos(4.2078 + 3.1814.*Tau) ...
   + 5020.*cos(3.1779 + 433.7117.*Tau) ...
   + 4593.*cos(0.6198 + 199.0720.*Tau) ...
   + 4006.*cos(2.2448 + 63.7359.*Tau) ...
   + 3874.*cos(3.2228 + 138.5175.*Tau) ...
   + 3269.*cos(0.7749 + 949.1756.*Tau) ...
   + 2954.*cos(0.9828 + 95.9792.*Tau) ...
   + 2461.*cos(2.0316 + 735.8765.*Tau) ...
   + 1758.*cos(3.2658 + 522.5774.*Tau) ...
   + 1640.*cos(5.5050 + 846.0828.*Tau) ...
   + 1581.*cos(4.3727 + 309.2783.*Tau) ...
   + 1391.*cos(4.0233 + 323.5054.*Tau) ...
   + 1124.*cos(2.8373 + 415.5525.*Tau) ...
   + 1087.*cos(4.1834 + 2.4477.*Tau) ...
   + 1017.*cos(3.7170 + 227.5262.*Tau);

SumL1 = 21354295596 ...
   + 1296855.*cos(1.8282054 + 213.2990954.*Tau) ...
   + 564348.*cos(2.885001 + 7.113547.*Tau) ...
   + 107679.*cos(2.277699 + 206.185548.*Tau) ...
   + 98323.*cos(1.08070 + 426.59819.*Tau) ...
   + 40255.*cos(2.04128 + 220.41264.*Tau) ...
   + 19942.*cos(1.27955 + 103.09277.*Tau) ...
   + 10512.*cos(2.74880 + 14.22709.*Tau) ...
   + 6939.*cos(0.4049 + 639.8973.*Tau) ...
   + 4803.*cos(2.4419 + 419.4846.*Tau) ...
   + 4056.*cos(2.9217 + 110.2063.*Tau) ...
   + 3769.*cos(6.6497 + 3.9322.*Tau) ...
   + 3385.*cos(2.4169 + 3.1814.*Tau) ...
   + 3302.*cos(1.2626 + 433.7117.*Tau) ...
   + 3071.*cos(2.3274 + 199.0720.*Tau) ...
   + 1953.*cos(3.5639 + 11.0457.*Tau) ...
   + 1249.*cos(2.6280 + 95.9792.*Tau) ...
   + 922.*cos(1.961 + 227.526.*Tau) ...
   + 706.*cos(4.417 + 529.691.*Tau) ...
   + 650.*cos(6.174 + 202.253.*Tau) ...
   + 628.*cos(6.111 + 309.278.*Tau);

SumL2 = 116441.*cos(1.179879 + 7.113547.*Tau) ...
   + 91921.*cos(0.07425 + 213.29910.*Tau) ...
   + 90592 ...
   + 15277.*cos(4.06492 + 206.18555.*Tau) ...
   + 10631.*cos(0.25778 + 220.41264.*Tau) ...
   + 10605.*cos(5.40964 + 426.59819.*Tau) ...
   + 4265.*cos(1.0460 + 14.2271.*Tau) ...
   + 1216.*cos(2.9186 + 103.0928.*Tau) ...
   + 1165.*cos(4.6094 + 639.8973.*Tau) ...
   + 1082.*cos(5.6913 + 433.7117.*Tau) ...
   + 1045.*cos(4.0421 + 199.0720.*Tau) ...
   + 1020.*cos(0.6337 + 3.1814.*Tau) ...
   + 634.*cos(4.388 + 419.485.*Tau) ...
   + 549.*cos(5.573 + 3.932.*Tau) ...
   + 457.*cos(1.268 + 110.206.*Tau) ...
   + 425.*cos(0.209 + 227.526.*Tau);

SumL3 = 16039.*cos(5.73945 + 7.11355.*Tau) ...
   + 4250.*cos(4.5854 + 213.2991.*Tau) ...
   + 1907.*cos(4.7608 + 220.4126.*Tau) ...
   + 1466.*cos(5.9133 + 206.1855.*Tau) ...
   + 1162.*cos(5.6197 + 14.2271.*Tau) ...
   + 1067.*cos(3.6082 + 426.5982.*Tau) ...
   + 239.*cos(3.861 + 433.712.*Tau) ...
   + 237.*cos(5.768 + 199.072.*Tau) ...
   + 166.*cos(5.116 + 3.181.*Tau) ...
   + 151.*cos(2.736 + 639.897.*Tau) ...
   + 131.*cos(4.743 + 227.526.*Tau);

SumL4 = 1662.*cos(3.9983 + 7.1135.*Tau) ...
   + 257.*cos(2.984 + 220.413.*Tau) ...
   + 236.*cos(3.902 + 14.227.*Tau) ...
   + 149.*cos(2.741 + 213.299.*Tau) ...
   - 114 ...
   + 110.*cos(1.515 + 206.186.*Tau) ...
   + 68.*cos(1.72 + 426.60.*Tau);

SumL5 = 124.*cos(2.259 + 7.114.*Tau) ...
   + 34.*cos(2.16 + 14.23.*Tau) ...
   + 28.*cos(1.20 + 220.41.*Tau);


L = SumL0 + SumL1.*Tau + SumL2.*Tau.^2 ...
          + SumL3.*Tau.^3 + SumL4.*Tau.^4 + SumL5.*Tau.^5;
L = L.*1e-8;

L = FunTPI(L);

SumB0 = 4330678.*cos(3.6028443 + 213.2990954.*Tau) ...
   + 240348.*cos(2.852385 + 426.598191.*Tau) ...
   + 84746 ... 
   + 34116.*cos(0.57297 + 206.18555.*Tau) ...
   + 30863.*cos(3.48442 + 220.41264.*Tau) ...
   + 14734.*cos(2.11847 + 639.89729.*Tau) ...
   + 9917.*cos(5.7900 + 419.4846.*Tau) ...
   + 6994.*cos(4.7360 + 7.1135.*Tau) ...
   + 4808.*cos(5.4331 + 316.3919.*Tau) ...
   + 4788.*cos(4.9651 + 110.2063.*Tau) ...
   + 3432.*cos(2.7326 + 433.7117.*Tau) ...
   + 1506.*cos(6.0130 + 103.0928.*Tau) ...
   + 1060.*cos(5.6310 + 529.6910.*Tau);

SumB1 = 397555.*cos(5.332900 + 213.299095.*Tau) ...
   - 49479 ...
   + 18572.*cos(6.09919 + 426.59819.*Tau) ...
   + 14801.*cos(2.30586 + 206.18555.*Tau) ...
   + 9644.*cos(1.6967 + 220.4126.*Tau) ...
   + 3757.*cos(1.2543 + 419.4846.*Tau) ...
   + 2717.*cos(5.9117 + 639.8973.*Tau) ...
   + 1455.*cos(0.8516 + 433.7117.*Tau) ...
   + 1291.*cos(2.9177 + 7.1135.*Tau) ...
   + 853.*cos(0.436 + 316.392.*Tau);

SumB2 = 20630.*cos(0.50482 + 213.29910.*Tau) ...
   + 3720.*cos(3.9983 + 206.1855.*Tau) ...
   + 1627.*cos(6.1819 + 220.4126.*Tau) ...
   + 1346 ...
   + 706.*cos(3.039 + 419.485.*Tau) ...
   + 365.*cos(5.099 + 426.598.*Tau) ...
   + 330.*cos(5.279 + 433.712.*Tau);

SumB3 = 666.*cos(1.990 + 213.299.*Tau) ...
   + 632.*cos(5.698 + 206.186.*Tau) ...
   + 398 ...
   + 188.*cos(4.338 + 220.413.*Tau);

SumB4 = 80.*cos(1.12 + 206.19.*Tau) ...
   + 32.*cos(3.12 + 213.30.*Tau) ...
   + 17.*cos(2.48 + 220.41.*Tau) ...
   -12;

SumB5 = 8.*cos(2.82 + 206.19.*Tau);

B = SumB0 + SumB1.*Tau + SumB2.*Tau.^2 ...
          + SumB3.*Tau.^3 + SumB4.*Tau.^4 + SumB5.*Tau.^5;
B = B.*1e-8;

%B = FunTPI(B);

SumR0 = 955758136 ...
   + 52921382.*cos(2.39226220 + 213.29909544.*Tau) ...
   + 1873680.*cos(5.2354961 + 206.1855484.*Tau) ...
   + 1464664.*cos(1.6476305 + 426.5981909.*Tau) ...
   + 821891.*cos(5.935200 + 316.391870.*Tau) ...
   + 547507.*cos(5.015326 + 103.092774.*Tau) ...
   + 371684.*cos(2.271148 + 220.412642.*Tau) ...
   + 361778.*cos(3.139043 + 7.113547.*Tau) ...
   + 140618.*cos(5.704067 + 632.783739.*Tau) ...
   + 108975.*cos(3.293136 + 110.206321.*Tau) ...
   + 69007.*cos(5.94100 + 419.48464.*Tau) ...
   + 61053.*cos(0.94038 + 639.89729.*Tau) ...
   + 48913.*cos(1.55733 + 202.25340.*Tau) ...
   + 34144.*cos(0.19519 + 277.03499.*Tau) ...
   + 32402.*cos(5.47085 + 949.17561.*Tau) ...
   + 20937.*cos(0.46349 + 735.87651.*Tau) ...
   + 20839.*cos(1.52103 + 433.71174.*Tau) ...
   + 20747.*cos(5.33256 + 199.07200.*Tau) ...
   + 15298.*cos(3.05944 + 529.69097.*Tau) ...
   + 14296.*cos(2.60434 + 323.50542.*Tau) ...
   + 12884.*cos(1.64892 + 138.51750.*Tau) ...
   + 11993.*cos(5.98051 + 846.08283.*Tau) ...
   + 11380.*cos(1.73106 + 522.57742.*Tau) ...
   + 9796.*cos(5.2048 + 1265.5675.*Tau) ...
   + 7753.*cos(5.8519 + 95.9792.*Tau) ...
   + 6771.*cos(3.0043 + 14.2271.*Tau) ...
   + 6466.*cos(0.1773 + 1052.2684.*Tau) ...
   + 5850.*cos(1.4552 + 415.5525.*Tau) ...
   + 5307.*cos(0.5974 + 63.7359.*Tau);

SumR1 = 6182981.*cos(0.2584352 + 213.2990954.*Tau) ...
   + 506578.*cos(0.711147 + 206.185548.*Tau) ...
   + 341394.*cos(5.796358 + 426.598191.*Tau) ...
   + 188491.*cos(0.472157 + 220.412642.*Tau) ...
   - 186262 ...
   + 143891.*cos(1.407449 + 7.113547.*Tau) ...
   + 49621.*cos(6.01744 + 103.09277.*Tau) ...
   + 20928.*cos(5.09246 + 639.89729.*Tau) ...
   + 19953.*cos(1.17560 + 419.48464.*Tau) ...
   + 18840.*cos(1.60820 + 110.20632.*Tau) ...
   + 13877.*cos(0.75886 + 199.07200.*Tau) ...
   + 12893.*cos(5.94330 + 433.71174.*Tau) ...
   + 5397.*cos(1.2885 + 14.2271.*Tau) ...
   + 4869.*cos(0.8679 + 323.5054.*Tau) ...
   + 4247.*cos(0.3930 + 227.5262.*Tau) ...
   + 3252.*cos(1.2585 + 95.9792.*Tau) ...
   + 3081.*cos(3.4366 + 522.5774.*Tau) ...
   + 2909.*cos(4.6068 + 202.2534.*Tau) ...
   + 2856.*cos(2.1673 + 735.8765.*Tau);

SumR2 = 436902.*cos(4.786717 + 213.299095.*Tau) ...
   + 71923.*cos(2.50070 + 206.18555.*Tau) ...
   + 49767.*cos(4.97168 + 220.41264.*Tau) ...
   + 43221.*cos(3.86940 + 426.59819.*Tau) ...
   + 29646.*cos(5.96310 + 7.11355.*Tau) ...
   + 4721.*cos(2.4753 + 199.0720.*Tau) ...
   + 4142.*cos(4.1067 + 433.7117.*Tau) ...
   + 3789.*cos(3.0977 + 639.8973.*Tau) ...
   + 2964.*cos(1.3721 + 103.0928.*Tau) ...
   + 2556.*cos(2.8507 + 419.4846.*Tau) ...
   + 2327 ...
   + 2208.*cos(6.2759 + 110.2063.*Tau) ...
   + 2188.*cos(5.8555 + 14.2271.*Tau) ...
   + 1957.*cos(4.9245 + 227.5262.*Tau) ...
   + 924.*cos(5.464 + 323.505.*Tau) ...
   + 706.*cos(2.971 + 95.979.*Tau) ...
   + 546.*cos(4.129 + 412.371.*Tau) ...
   + 431.*cos(5.178 + 522.577.*Tau);

SumR3 = 20315.*cos(3.02187 + 213.29910.*Tau) ...
   + 8924.*cos(3.1914 + 220.4126.*Tau) ...
   + 6909.*cos(4.3517 + 206.1855.*Tau) ...
   + 4087.*cos(4.2241 + 7.1135.*Tau) ...
   + 3879.*cos(2.0106 + 426.5982.*Tau) ...
   + 1071.*cos(4.2036 + 199.0720.*Tau) ...
   + 907.*cos(2.283 + 433.712.*Tau) ...
   + 606.*cos(3.175 + 227.526.*Tau) ...
   + 597.*cos(4.135 + 14.227.*Tau) ...
   + 483.*cos(1.173 + 639.897.*Tau) ...
   + 393 ...
   + 229.*cos(4.698 + 419.485.*Tau);

SumR4 = 1202.*cos(1.4150 + 220.4126.*Tau) ...
   + 708.*cos(1.162 + 213.299.*Tau) ...
   + 516.*cos(6.240 + 206.186.*Tau) ...
   + 427.*cos(2.469 + 7.114.*Tau) ...
   + 268.*cos(0.187 + 426.598.*Tau) ...
   + 170.*cos(5.959 + 199.072.*Tau);

SumR5 = 129.*cos(5.913 + 220.413.*Tau) ...
   + 32.*cos(0.69 + 7.11.*Tau) ...
   + 27.*cos(5.91 + 227.53.*Tau);

R = SumR0 + SumR1.*Tau + SumR2.*Tau.^2 ...
          + SumR3.*Tau.^3 + SumR4.*Tau.^4 + SumR5.*Tau.^5;
R = R.*1e-8;
