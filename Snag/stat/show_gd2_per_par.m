function show_gd2_per_par(perpar,meanper,gencapt,capt)
% show_gd2_per_par  plots from gd2_period
%
%   perpar,meanper  from gd2_period
%   gencapt         title preamble
%   capt            caption structure
%                    .spec
%                    .amp
%                    .phase
%                    .aphase
%                    .epfold
%                   for each one:
%                       .title
%                       .xlabel
%                       .ylabel
%                   if absent, use default

if ~exist('gencapt','var')
    gencapt='';
end

if ~exist('capt','var')
    capt.spec.title='spectral density';
    capt.spec.xlabel='Hz';
    capt.spec.ylabel='h/sqrt(Hz)';
    capt.amp.title='periodicity amplitude';
    capt.amp.xlabel='Hz';
    capt.amp.ylabel='fraction of the mean value';
    capt.phase.title='phase of the maximum';
    capt.phase.xlabel='Hz';
    capt.phase.ylabel='hours';
    capt.aphase.title='phase of the minimum';
    capt.aphase.xlabel='Hz';
    capt.aphase.ylabel='hours';
    capt.epfold.title='epoch folding with smoothing';
    capt.epfold.xlabel='hours';
    capt.epfold.ylabel='fraction of the mean value';
end

if max(perpar(2,:))/min(perpar(2,:)) < 10
    figure,plot(perpar(1,:),perpar(2,:)),grid on
else
    figure,semilogy(perpar(1,:),perpar(2,:)),grid on
end
title(capt.spec.title),xlabel(capt.spec.xlabel),ylabel(capt.spec.ylabel)
xlim([min(perpar(1,:)) max(perpar(1,:))]);

figure,plot(perpar(1,:),perpar(3,:)),grid on
title([gencapt ' - ' capt.amp.title]),xlabel(capt.amp.xlabel),ylabel(capt.amp.ylabel)
xlim([min(perpar(1,:)) max(perpar(1,:))]);

figure,plot(perpar(1,:),perpar(4,:)),grid on,hold on,plot(perpar(1,:),perpar(4,:),'r.')
title([gencapt ' - ' capt.phase.title]),xlabel(capt.phase.xlabel),ylabel(capt.phase.ylabel)
xlim([min(perpar(1,:)) max(perpar(1,:))]);

figure,plot(perpar(1,:),perpar(5,:)),grid on,hold on,plot(perpar(1,:),perpar(5,:),'r.')
title([gencapt ' - ' capt.aphase.title]),xlabel(capt.aphase.xlabel),ylabel(capt.aphase.ylabel)
xlim([min(perpar(1,:)) max(perpar(1,:))]);

figure,plot(meanper(1,:),meanper(2,:)),hold on,plot(meanper(1,:),meanper(3,:),'r'),grid on
title([gencapt ' - ' capt.epfold.title]),xlabel(capt.epfold.xlabel),ylabel(capt.epfold.ylabel)
xlim([min(meanper(1,:)) max(meanper(1,:))]);