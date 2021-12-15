disp('single Wiener filter');
msgbox('single Wiener filter');
ff_struct.n=1;
ff_struct.capt='single Wiener filter';
ff_struct.tau=10;
ff_struct.sfilt=struct('rlfft',{1},...
   'capt',{'Wiener filter'});
ff_struct.pfilt='wiener';