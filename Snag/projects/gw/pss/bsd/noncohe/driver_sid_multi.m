% driver_sid_multi

p3=new_posfr(pulsar_3,57859);

bsdsstr(1).addr='I:';
bsdsstr(1).ant='ligol';
bsdsstr(1).runame='O2';
bsdsstr(2).addr='I:';
bsdsstr(2).ant='ligoh';
bsdsstr(2).runame='O2';

[sids,bsds]=sid_sweep_multi(bsdsstr,p3.f0,p3,[10 5])

% [sids,bsds]=sid_sweep_multi(bsds,p3.f0,p3,[10 5])