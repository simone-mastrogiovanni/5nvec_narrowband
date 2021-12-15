function show_spec_lines(sp,tit,flags)
%
%  sp        spectrum gd
%  tit       title
%  flags(3)  1 no lines, 2 lines, 3 zoom [1-flags(3) 1+flags(3)]
%              default [1 0 0.05]

W=1/7;            % Week
S1=1;             % Solar day
O1=13.943036/15;  % Lunar principal
P1=14.958931/15;  % Solar principal
K1=15.041069/15;  % Declinational (Sidereal)
N2=28.439730/15;  % Lunar elliptic
M2=28.984104/15;  % Lunar Principal
S2=30/15;         % Solar Principal
K2=2*15.041069/15;% Half Sidereal
S3=45/15;         % Solar third harmonic
K3=3*15.041069/15;% Half third harmonic

if ~exist('tit','var')
    tit='Low frequency pseudo-spectrum';
end

if ~exist('flags','var')
    flags=[1 0 0.05];
end

ini=ini_gd(sp);
dx=dx_gd(sp);
n=n_gd(sp);
inim=max(ini,W/2);
inii=floor((inim-ini)/dx+1);
mm=max(sp(inii:n));
mi=min(x_gd(sp));
ma=max(x_gd(sp));

if flags(1) > 0
    figure,plot(sp)
    xlim([mi ma])
    ylim([0 mm*1.05])
    title(tit),xlabel('days^{-1}')
end

if flags(2) > 0
    figure,plot(sp),hold on
    plot([W W],[0 mm],'r--')
    plot([S1 S1],[0 mm],'r--')
    plot([K1 K1],[0 mm],'g')
    plot([M2 M2],[0 mm],'c')
    plot([S2 S2],[0 mm],'r')
    plot([O1 O1],[0 mm],'c:')
    plot([P1 P1],[0 mm],'g--')
    plot([N2 N2],[0 mm],'c:')
    plot([K2 K2],[0 mm],'g--')
    plot([S3 S3],[0 mm],'r--')
    plot([K3 K3],[0 mm],'g--')
    plot(sp)
    xlim([mi ma])
    ylim([0 mm*1.05])
    title(tit),xlabel('days^{-1}')
end

if flags(3) > 0ini=ini_gd(sp);
    sp1=cut_gd(sp,[1-flags(3) 1+flags(3)]);
    dx=dx_gd(sp1);
    n=n_gd(sp1);
    mm=max(sp1);
    mi=min(x_gd(sp1));
    ma=max(x_gd(sp1));
    figure,plot(sp1),hold on
    plot([W W],[0 mm],'r--')
    plot([S1 S1],[0 mm],'r--')
    plot([K1 K1],[0 mm],'g')
    plot([M2 M2],[0 mm],'c')
    plot([S2 S2],[0 mm],'r')
    plot([O1 O1],[0 mm],'c:')
    plot([P1 P1],[0 mm],'g--')
    plot([N2 N2],[0 mm],'c:')
    plot([K2 K2],[0 mm],'g--')
    plot([S3 S3],[0 mm],'r--')
    plot([K3 K3],[0 mm],'g--')
    plot(sp1)
    xlim([mi ma])
    ylim([0 mm*1.05])
    title(tit),xlabel('days^{-1}')
end