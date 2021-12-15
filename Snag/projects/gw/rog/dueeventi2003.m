%dueeventi2003
%
% Nautilus:
% 2003 12 2 22 45  43.8423004  3.41759992 -0.365999997  13.2200003 1243
%  2.7420001 41 0  0.0450000018  0.00170000002  36.5740013
%  28   36.5740       926.3609       941.5413    37955.9484636562    37955.9484636600
%
% Explorer
% 2003 12 2 22 45  47.2342987  0.0320000015  0.377999991  7.39099979 13
%  0.731000006 6 0  0.104000002  0.00520000001  31.6369991
%   4   31.6370       903.3588       926.0908    37955.9484637303    37955.9484637300
%

cd D:\Data\Rog\DueEventi
   
load -ascii data_hg0312D021_31.dat
load -ascii data_hn0312D002_31.dat
ndat=data_hn0312D002_31(:,3);
gdat=data_hg0312D021_31(:,3);
figure
plot(ndat)
hold on
plot(gdat,'r')
grid on
clear data_hn0312D002_31 data_hg0312D021_31

dt=0.0032;
gdn=gd(ndat);
gdn=edit_gd(gdn,'dx',dt);
gdg=gd(gdat);
gdg=edit_gd(gdg,'dx',dt);

gdn0=gd(ndat(1541:1590));
gdn0=edit_gd(gdn0,'dx',dt);
gdg0=gd(gdat(1541:1590));
gdg0=edit_gd(gdg0,'dx',dt);

agdn=gd(abs(ndat));
agdn=edit_gd(agdn,'dx',dt);
agdg=gd(abs(gdat));
agdg=edit_gd(agdg,'dx',dt);

agdn0=gd(abs(ndat(1541:1590)));
agdn0=edit_gd(agdn0,'dx',dt);
agdg0=gd(abs(gdat(1541:1590)));
agdg0=edit_gd(agdg0,'dx',dt);

agdn01=gd(abs(ndat(1500:1650)));
agdn01=edit_gd(agdn01,'dx',dt);
agdg01=gd(abs(gdat(1500:1650)));
agdg01=edit_gd(agdg01,'dx',dt);