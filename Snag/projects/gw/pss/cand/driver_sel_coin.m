% driver_sel_coin

i=0;
numerosity=[4 1 10];
ncand=2;   % number of spotted  candidates per s.b.
Aoh=1;     % sort on A (1) or h (2)
outvar='num_secoin';

eval([outvar '=struct([]);'])

[selind bsel spotind]=sel_coin(coin_1_010030_ref,{[1,0.3 1],[2,0.9],[3,0.10,0,1],numerosity,[10,Aoh],[12,1.0],[20 1]},ncand);
i=i+1
eval([outvar '(i).selind=selind;'])
eval([outvar '(i).bsel=bsel;'])
eval([outvar '(i).spotind=spotind;'])
pause(5)

[selind bsel spotind]=sel_coin(coin_1_030040_ref,{[1,0.3 1],[2,0.9],[3,0.10,0,1],numerosity,[10,Aoh],[12,1.0],[20 1]},ncand);
i=i+1
eval([outvar '(i).selind=selind;'])
eval([outvar '(i).bsel=bsel;'])
eval([outvar '(i).spotind=spotind;'])
pause(5)

[selind bsel spotind]=sel_coin(coin_1_040050_ref,{[1,0.3 1],[2,0.9],[3,0.10,0,1],numerosity,[10,Aoh],[12,1.0],[20 1]},ncand);
i=i+1
eval([outvar '(i).selind=selind;'])
eval([outvar '(i).bsel=bsel;'])
eval([outvar '(i).spotind=spotind;'])
pause(5)

[selind bsel spotind]=sel_coin(coin_1_050060_ref,{[1,0.3 1],[2,0.9],[3,0.10,0,1],numerosity,[10,Aoh],[12,1.0],[20 1]},ncand);
i=i+1
eval([outvar '(i).selind=selind;'])
eval([outvar '(i).bsel=bsel;'])
eval([outvar '(i).spotind=spotind;'])
pause(5)

[selind bsel spotind]=sel_coin(coin_1_060070_ref,{[1,0.3 1],[2,0.9],[3,0.10,0,1],numerosity,[10,Aoh],[12,1.0],[20 1]},ncand);
i=i+1
eval([outvar '(i).selind=selind;'])
eval([outvar '(i).bsel=bsel;'])
eval([outvar '(i).spotind=spotind;'])
pause(5)

[selind bsel spotind]=sel_coin(coin_1_070080_ref,{[1,0.3 1],[2,0.9],[3,0.10,0,1],numerosity,[10,Aoh],[12,1.0],[20 1]},ncand);
i=i+1
eval([outvar '(i).selind=selind;'])
eval([outvar '(i).bsel=bsel;'])
eval([outvar '(i).spotind=spotind;'])
pause(5)

[selind bsel spotind]=sel_coin(coin_1_080090_ref,{[1,0.3 1],[2,0.9],[3,0.10,0,1],numerosity,[10,Aoh],[12,1.0],[20 1]},ncand);
i=i+1
eval([outvar '(i).selind=selind;'])
eval([outvar '(i).bsel=bsel;'])
eval([outvar '(i).spotind=spotind;'])
pause(5)

[selind bsel spotind]=sel_coin(coin_1_090100_ref,{[1,0.3 1],[2,0.9],[3,0.10,0,1],numerosity,[10,Aoh],[12,1.0],[20 1]},ncand);
i=i+1
eval([outvar '(i).selind=selind;'])
eval([outvar '(i).bsel=bsel;'])
eval([outvar '(i).spotind=spotind;'])
pause(5)

[selind bsel spotind]=sel_coin(coin_1_100110_ref,{[1,0.3 1],[2,0.9],[3,0.10,0,1],numerosity,[10,Aoh],[12,1.0],[20 1]},ncand);
i=i+1
eval([outvar '(i).selind=selind;'])
eval([outvar '(i).bsel=bsel;'])
eval([outvar '(i).spotind=spotind;'])
pause(5)

[selind bsel spotind]=sel_coin(coin_1_110120_ref,{[1,0.3 1],[2,0.9],[3,0.10,0,1],numerosity,[10,Aoh],[12,1.0],[20 1]},ncand);
i=i+1
eval([outvar '(i).selind=selind;'])
eval([outvar '(i).bsel=bsel;'])
eval([outvar '(i).spotind=spotind;'])
pause(5)

[selind bsel spotind]=sel_coin(coin_1_120130_ref,{[1,0.3 1],[2,0.9],[3,0.10,0,1],numerosity,[10,Aoh],[12,1.0],[20 1]},ncand);
i=i+1
eval([outvar '(i).selind=selind;'])
eval([outvar '(i).bsel=bsel;'])
eval([outvar '(i).spotind=spotind;'])