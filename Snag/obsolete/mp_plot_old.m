function mp_plot(mp,typ)
%MP_PLOT   multiple plot
%
% mp structure (multiplot):
%
%     mp.nch
%     mp.ch(i).name
%             .n
%             .x
%             .y
%             .unitx
%             .unity
%
%    typ   type of plot (1 lin, 2 logx, 3 logy, 4 loglog)

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('typ')
   typ=1;
end
   
[which,whok]=listdlg('PromptString','Multiplot type ?',...
	'Name','MultiPlot',...
   'SelectionMode','single',...
   'ListString',{'Single figure' 'Single figure autonormalized'...
      'Single figure, many subplots' 'Multiple figures'});

if which <=2
   figure
   
   if which == 2
      for i = 1:mp.nch
         maxmp=max(mp.ch(i).y);
         minmp=min(mp.ch(i).y);
         dif=maxmp-minmp;
         mp.ch(i).y=mp.ch(i).y./dif-minmp;
      end
   end

	for i = 1:mp.nch
   	name{i}=us2minus(mp.ch(i).name);
      tcol=rotcol(i);
      switch typ
      case 1
         plot(mp.ch(i).x,mp.ch(i).y,'color',tcol);
      case 2
         semilogx(mp.ch(i).x,mp.ch(i).y,'color',tcol);
      case 3
         semilogy(mp.ch(i).x,mp.ch(i).y,'color',tcol);
      case 4
         loglog(mp.ch(i).x,mp.ch(i).y,'color',tcol);
      end
   	hold on;
	end

	grid on,zoom on

	switch mp.nch
	case 1
  		legend(name{1},2)
	case 2
  		legend(name{1},name{2},2)
	case 3
  		legend(name{1},name{2},name{3},2)
	case 4
  		legend(name{1},name{2},name{3},name{4},2)
	case 5
  		legend(name{1},name{2},name{3},name{4},...
  			name{5},2)
	case 6
   	legend(name{1},name{2},name{3},name{4},...
   		name{5},name{6},2)
	case 7
   	legend(name{1},name{2},name{3},name{4},...
   		name{5},name{6},name{7},2)
	case 8
   	legend(name{1},name{2},name{3},name{4},...
   		name{5},name{6},name{7},name{8},2)
	case 9
   	legend(name{1},name{2},name{3},name{4},...
 	     name{5},name{6},name{7},name{8},...
   	   name{9},2)
	case 10
   	legend(name{1},name{2},name{3},name{4},...
      	name{5},name{6},name{7},name{8},...
      	name{9},name{10},2)
	case 11
   	legend(name{1},name{2},name{3},name{4},...
      	name{5},name{6},name{7},name{8},...
      	name{9},name{10},name{11},2)
	case 12
   	legend(name{1},name{2},name{3},name{4},...
   		name{5},name{6},name{7},name{8},...
   		name{9},name{10},name{11},name{12},2)
   end
else if which == 3
      npl=mp.nch;
      ncol=1;
      nrow=npl;
      if npl == 4 | npl == 6 | npl == 8 | npl == 10
         ncol=2;
         nrow=npl/2;
      elseif npl == 9
         ncol=3;
         nrow=3;
      end
      figure;
   	for i = 1:mp.nch
      	subplot(nrow,ncol,i);
   		name{i}=us2minus(mp.ch(i).name);
   		tcol=rotcol(i);
         subplot(nrow,ncol,i);
         switch typ
      	case 1
        	   plot(mp.ch(i).x,mp.ch(i).y,'color',tcol);
      	case 2
         	semilogx(mp.ch(i).x,mp.ch(i).y,'color',tcol);
      	case 3
         	semilogy(mp.ch(i).x,mp.ch(i).y,'color',tcol);
      	case 4
         	loglog(mp.ch(i).x,mp.ch(i).y,'color',tcol);
      	end

    	   hold on;grid on;zoom on;
    	   legend(name{i},2);
      end
	else
      for i = 1:mp.nch
         figure
         name{i}=us2minus(mp.ch(i).name);
         tcol=rotcol(i);
         switch typ
      	case 1
        	   plot(mp.ch(i).x,mp.ch(i).y);
      	case 2
         	semilogx(mp.ch(i).x,mp.ch(i).y);
      	case 3
         	semilogy(mp.ch(i).x,mp.ch(i).y);
      	case 4
         	loglog(mp.ch(i).x,mp.ch(i).y);
      	end
    	   hold on;grid on;zoom on;
    	   legend(name{i},2);
      end
   end
end

mp_stat(mp);

str1=cell(mp.nch+5,1);

str1{1}='nothing';
str1{2}=' ';
str1{3}='Quick power spectrum';
str1{4}='Quick histograms';
str1{5}=' ';
str1{6}='Correlation with channel 1';

for i = 2:mp.nch
   str1{i+5}=sprintf('Correlation with channel %d',i);
end

[which1,whok]=listdlg('PromptString','Further processing ?',...
	'Name','MultiPlot',...
   'SelectionMode','single',...
   'ListString',str1);

which=which1;

if which >= 6
   which=6;
   which1=which1-5;
end

switch which
case 1
   return
case 3
   for i = 1:mp.nch
   	mp.ch(i).y=abs(fft(mp.ch(i).y));
   	npl=length(mp.ch(i).x);
   	tobs=(mp.ch(i).x(npl)-mp.ch(i).x(1))*npl/(npl-1);
   	xpl=(0:npl-1)./tobs;
      mp.ch(i).y=mp.ch(i).y.*(tobs/npl);
   end
   mp_plot(mp,3)
case 4
   for i = 1:mp.nch
      figure
   	hist(mp.ch(i).y,100);
   end
   mp_plot(mp)
%case 6
%   for i = 1:mp.nch
%      out_mp=gd(mp.ch(i).y);
%      dx=mp.ch(i).x(2)-mp.ch(i).x(1);
%      capt=mp.ch(i).name;
%      out_mp=edit_gd(out_mp,'dx',dx,'capt',capt);
%      answ=inputdlg({['Name of the gd of ' capt ' ?']},...
%   		'Renaming the output object',1,{'out_mp'});
%      eval([answ{1} '=out_mp']);
%      eval(['varargout{i}=' answ{1}]);
%   end
case 6
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
