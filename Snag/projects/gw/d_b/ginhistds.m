% ginhistds   gui for d_b_rhist

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

answ=inputdlg({'Type (0->single, 1->total, 2-> autoregressive',...
   'tau (only for autoregressive histogram)',...
   'Number of bins',...
   'Lower limit (low=high -> automatic)',...
   'Higher limit',...
   'Only last (0 -> no, 1 -> yes)'},...
   'Histogram parameters',1,...
   {'1','6','200','0','0','0'});

ichist=eval(answ{1});
tau=answ{2};
nbin=eval(answ{3});
lowlimit=eval(answ{4});
highlimit=eval(answ{5});
onlyl=eval(answ{6});
pause(1)

strichist='';
switch ichist
case 0
   strichist='''single'',';
case 1
   strichist='''total'',';
case 2
   strichist='''ar'',tau,';
end

stronlyl='';
if onlyl == 1
   stronlyl='''onlylast'',';
end

strlimit='';
if lowlimit < highlimit
   strlimit='''limit'',lowlimit,highlimit,';
end

strnbin='''nbin'',nbin);';

strhist=[strichist stronlyl strlimit strnbin];
