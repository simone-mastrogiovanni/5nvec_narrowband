disp('single nothing filter');
msgbox('single nothing filter');
ff_struct.n=1;
ff_struct.capt='single nothing filter';
ff_struct.tau=10;
ff_struct.sfilt=struct('rlfft',{1},'type',{1},...
   'capt',{'nothing filter'});
ff_struct.pfilt='nothing';