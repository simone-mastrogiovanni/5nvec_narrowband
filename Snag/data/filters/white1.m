disp('single whitening filter');
msgbox('single whitening filter');
ff_struct.n=1;
ff_struct.capt='single whitening filter';
ff_struct.tau=10;
ff_struct.sfilt=struct('rlfft',{1},...
   'capt',{'whitening filter'});
ff_struct.pfilt='whitening';