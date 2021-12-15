function mp_plot(mp,typ,styp,tits)
%MP_PLOT   multiple plot
%
% mp structure (multiplot):
%
%     mp.nch
%     mp.ch(i).name
%             .n        dimension of x,y
%             .x        ... ; if dim x is 1, x(1) is the beginning and mp.ch(i).dx
%                       is the sampling period
%             .dx       ...
%             .y        ...
%             .unitx    ...
%             .unity    ...
%             .ch       ch number (primary key for chstr - optional)
%     mp.x              abscissa (equal for all channels) if ch(i).x is absent
%                       if dim x is 1, x(1) is the beginning and mp.dx is the
%                       sampling period
%     mp.dx             ...
%     mp.unitx          ...
%
%    typ    type of plot (1 lin, 2 logx, 3 logy, 4 loglog)
%    styp   character as '.', '+', and so on for point plot
%    tits   eval expression for titles and other (ex.: title='title(''ROC'')')

% Version 2.0 - October 1999 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('typ','var')
   typ=1;
end

point=0;
if exist('styp','var')
    point=1;
else
    styp='';
end

if ~exist('tits','var')
   tits='';
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
    if isfield(mp.ch(i),'x')
        if length(mp.ch(i).x) > 1
            x=mp.ch(i).x;
        else
            x=mp.ch(i).x+(0:length(mp.ch(i).y)-1)*mp.ch(i).dx;
        end
    else
        if length(mp.x) > 1
            x=mp.x;
        else
            x=mp.x+(0:length(mp.ch(i).y)-1)*mp.dx;
        end
    end
    
    tcol=tricol(i,mp.nch);
	switch typ
	case 1
        plot(x,mp.ch(i).y,styp,'color',tcol);
	case 2
        semilogx(x,mp.ch(i).y,styp,'color',tcol);
	case 3
        semilogy(x,mp.ch(i).y,styp,'color',tcol);
	case 4
        loglog(x,mp.ch(i).y,styp,'color',tcol);
    end
    eval(tits);
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
        if isfield(mp.ch(i),'x')
            if length(mp.ch(i).x) > 1
                x=mp.ch(i).x;
            else
                x=mp.ch(i).x+(0:length(mp.ch(i).y)-1)*mp.ch(i).dx;
            end
        else
            if length(mp.x) > 1
                x=mp.x;
            else
                x=mp.x+(0:length(mp.ch(i).y)-1)*mp.dx;
            end
        end
        
      	subplot(nrow,ncol,i);
   		name{i}=us2minus(mp.ch(i).name);
   	    tcol=tricol(i,mp.nch);
        subplot(nrow,ncol,i);
        switch typ
      	case 1
        	plot(x,mp.ch(i).y,styp,'color',tcol);
      	case 2
         	semilogx(x,mp.ch(i).y,styp,'color',tcol);
      	case 3
         	semilogy(x,mp.ch(i).y,styp,'color',tcol);
      	case 4
         	loglog(x,mp.ch(i).y,styp,'color',tcol);
      	end

    	   hold on;grid on;zoom on;
    	   legend(name{i},2);
      end
	else
      for i = 1:mp.nch
        if isfield(mp.ch(i),'x')
            if length(mp.ch(i).x) > 1
                x=mp.ch(i).x;
            else
                x=mp.ch(i).x+(0:length(mp.ch(i).y)-1)*mp.ch(i).dx;
            end
        else
            if length(mp.x) > 1
                x=mp.x;
            else
                x=mp.x+(0:length(mp.ch(i).y)-1)*mp.dx;
            end
        end
        
        figure
        name{i}=us2minus(mp.ch(i).name);
        tcol=tricol(i,mp.nch);
        switch typ
      	case 1
        	plot(x,mp.ch(i).y,styp);
      	case 2
         	semilogx(x,mp.ch(i).y,styp);
      	case 3
         	semilogy(x,mp.ch(i).y,styp);
      	case 4
         	loglog(x,mp.ch(i).y,styp);
      	end
    	   hold on;grid on;zoom on;
    	   legend(name{i},2);
      end
   end
end

mp_stat(mp);

