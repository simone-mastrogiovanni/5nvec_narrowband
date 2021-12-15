function [ch_absc_sum,ch_absc_mult]=ch_absc(xfig1)
%CH_ABSC  changes abscissa unit for plots
%
%  Input abscissa are normally mjd days or gps s

k=menu('Change abscissa unit',...
    'unchanged',...
    'day -> s',...
    'day -> minute',...
    'day -> hour',...
    'day -> year',...
    's -> minute',...
    's -> hour',...
    's -> day',...
    's -> year')

switch k
    case 1
        ch_absc_sum=0;
        ch_absc_mult=1;
    case 2
        ch_absc_mult=86400;
        ch_absc_sum=-floor(xfig1*ch_absc_mult);
    case 3
        ch_absc_mult=1440;
        ch_absc_sum=-floor(xfig1*ch_absc_mult);
    case 4
        ch_absc_mult=24;
        ch_absc_sum=-floor(xfig1*ch_absc_mult);
    case 5
        ch_absc_mult=1/365.2445;
        ch_absc_sum=-floor(xfig1*ch_absc_mult);
    case 6
        ch_absc_mult=1/60;
        ch_absc_sum=-floor(xfig1*ch_absc_mult);
    case 7
        ch_absc_mult=1/3600;
        ch_absc_sum=-floor(xfig1*ch_absc_mult);
    case 8
        ch_absc_mult=1/86400;
        ch_absc_sum=-floor(xfig1*ch_absc_mult);
    case 9
        ch_absc_mult=1/(86400*365.2445);
        ch_absc_sum=-floor(xfig1*ch_absc_mult);
end