function [dt ddt]=dt_spindown(f0,df0,ddf0,ts)
%
%    f0,df0,ddf0   source parameters
%    ts            time after f0 (s)
%
%    dt            delay (s)
%    ddt           variation of dt (s/s)

dt=-(df0*ts.^2/2+ddf0*ts.^3/6)/f0;
ddt=-(df0*ts+ddf0*ts.^2/2)/f0;