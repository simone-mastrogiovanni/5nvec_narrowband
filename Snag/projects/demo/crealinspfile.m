% crealinspfile
snag_local_symbols
lenspec=4096;
perspec=32;
spec=sin((1:lenspec)/perspec);
spec=fft(spec);
spec=spec.*conj(spec);

specname='roughline';
roughline=gd(spec);
save([specdir 'roughline'],'roughline','specname')

spec0=tdwin(spec,'sqrt','real','hhole');
specname='linespectd0';
linespectd0=gd(spec0);
save([specdir 'linespectd0'],'linespectd0','specname')
  
spec1=tdwin(spec,'sqrt','real','hhole','amplitude',0.1);  

specname='linespectd';
linespectd=gd(spec1);
save([specdir 'linespectd'],'linespectd','specname')

spec2=spec_2l(spec);  

specname='linespecs2l';
linespecs2l=gd(spec2);
save([specdir 'linespecs2l'],'linespecs2l','specname')