%rsdo  resonance double oscillator
%   produces a gd named gr

r=rs(2);
r=set_rs(r,'fr',[10 12],'tau',[2 2],'dt',0.01);
[r,gr]=run_rs(r,10000);
