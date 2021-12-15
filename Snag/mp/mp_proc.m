%MP_PROC   multiple plot processing

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


str1=cell(mp.nch+5,1);

str1{1}='Replot';
str1{2}=' ';
str1{3}='Quick power spectrum';
str1{4}='Quick histograms';
str1{5}=' ';
str1{6}='Save to a gd';
str1{7}=' ';
str1{8}='Correlation with channel 1';

for i = 2:mp.nch
   str1{i+7}=sprintf('Correlation with channel %d',i);
end

[which1,whok]=listdlg('PromptString','Further processing ?',...
	'Name','MultiPlot',...
   'SelectionMode','single',...
   'ListString',str1);

which=which1;

if which >= 8
   which=8;
   which1=which1-7;
end

switch which
case 1
   mp_plot(mp);
case 3
   for i = 1:mp.nch
   	mp.ch(i).y=abs(fft(mp.ch(i).y));
   	npl=length(mp.ch(i).x);
   	tobs=(mp.ch(i).x(npl)-mp.ch(i).x(1))*npl/(npl-1);
      mp.ch(i).x=(0:npl-1)./tobs;
      mp.ch(i).y=mp.ch(i).y.*(tobs/npl);
   end
   mp_plot(mp,3)
case 4
   for i = 1:mp.nch
      figure
      norm=1;
      yYy=mp.ch(i).y;
      while max(yYy)-min(yYy) < 10^-15
         norm=norm*10^10;
         yYy=yYy*norm;
      end
      fprintf(' *** Histogram %d abscissa value multiplied by %d ! \n',i,norm);
   	hist(yYy,100);
   end
case 6
   for i = 1:mp.nch
      out_mp=gd(mp.ch(i).y);
      dx=mp.ch(i).x(2)-mp.ch(i).x(1);
      capt=mp.ch(i).name;
      out_mp=edit_gd(out_mp,'dx',dx,'capt',capt);
      answ=inputdlg({['Name of the gd of ' capt ' ?']},...
   		'Renaming the output object',1,{'out_mp'});
      eval([answ{1} '=out_mp']);
   end
case 8
   for i = 1:mp.nch
      mp.ch(i).y=fft(mp.ch(i).y);
   end
   y=mp.ch(which1).y;
   for i = 1:mp.nch
      nout=length(mp.ch(i).y);
      y1=uniresamp(y,nout);
      size(mp.ch(i).y),size(y1)
      mp.ch(i).y=mp.ch(i).y.*conj(y1);
      mp.ch(i).y=real(ifft(mp.ch(i).y));
      npl=length(mp.ch(i).x);
      mp.ch(i).y=rota(mp.ch(i).y,npl/2);
      tobs=(mp.ch(i).x(npl)-mp.ch(i).x(1))*npl/(npl-1);
      mp.ch(i).x=mp.ch(i).x-tobs/2;
   end
   mp_plot(mp)
end
