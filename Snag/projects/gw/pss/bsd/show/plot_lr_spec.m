function out=plot_lr_spec(lrspst)
% plotting low res spectral data structure
%
%   lrspst    low res spectral data structure

% Snag Version 2.0 - August 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

frs=lrspst.frs;

figure,semilogy(frs,lrspst.whdens),grid on
title('wienerized spectrum'),xlabel('Hz')

figure,semilogy(frs,lrspst.whdens_med),grid on
title('median wienerized spectrum'),xlabel('Hz')

figure,semilogy(frs,lrspst.whdens0),grid on
title('raw wienerized spectrum'),xlabel('Hz')

figure,semilogy(frs,lrspst.rhdens),grid on
title('raw spectrum'),xlabel('Hz')

figure,semilogy(frs,mean(lrspst.whdens_med'),'c.'),grid on,hold on
semilogy(frs,mean(lrspst.whdens0'),'g'),semilogy(frs,mean(lrspst.rhdens'),'r'),
semilogy(frs,mean(lrspst.whdens'))
title('mean spectra: w blue, wmed red dot, w0 green, r red,'),xlabel('Hz')

figure,semilogy(frs,lrspst.meanw),grid on
title('wiener filter: mean'),xlabel('Hz')

figure,semilogy(frs,lrspst.stdw),grid on
title('wiener filter: std'),xlabel('Hz')

figure,plot(frs,lrspst.non0w(1:length(frs),:),'.'),grid on
title('non-zero fraction'),xlabel('Hz')

inib=lrspst.inibands;
figure,plot(inib,lrspst.lfft(1,:),'.'),grid on
title('lfft'),xlabel('Initial band frequency (Hz)')

figure,plot(inib,lrspst.npeaks,'.'),grid on
title('Number of peaks'),xlabel('Initial band frequency (Hz)')

figure,semilogy(inib,lrspst.mi_abs_lev,'.'),grid on
title('Logarithmize level'),xlabel('Initial band frequency (Hz)')