% driver_noncohe_cross
%

pp=new_posfr(pulsar_3,57859);

% iout=[8615,8616,8617];  % pulsar_0
% iout=8569:8658;         % pulsar_1
% iout=[8616,8617];       % pulsar_2
iout=[8616,8617];       % pulsar_3
% iout=[8569:8658];       % pulsar_4
% iout=[8615,8616];       % pulsar_5
% iout=[8569:8658];       % pulsar_6
% iout=[8569:8658];       % pulsar_7
% iout=[8569:8658];       % pulsar_8
% iout=[8616,8617];       % pulsar_9
% iout=8600:8625;         % pulsar_10
% iout=[8616,8617];       % pulsar_11
% iout=[];  % pulsar_12
% iout=[8600:8625];       % pulsar_13
% iout=[8616,8617];       % pulsar_14

clear bsdsstr
bsdsstr(1).addr='I:';
bsdsstr(1).ant='ligol';
bsdsstr(1).runame='O2';
bsdsstr(2).addr='I:';
bsdsstr(2).ant='ligoh';
bsdsstr(2).runame='O2';
% bsdsstr(3).addr='I:';
% bsdsstr(3).ant='virgo';
% bsdsstr(3).ant='ligol';
% bsdsstr(3).runame='O2';

[sids,bsds]=sid_sweep_multi(bsdsstr,pp.f0,pp,[10 5],iout,48)

ncout=noncohe_cross(sids)