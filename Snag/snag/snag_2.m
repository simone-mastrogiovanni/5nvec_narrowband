%Snag principal window - Modified
%
%                    Theory
%
% The data can be put in 
%  - a GD (group of data), if their number is finite (see class constructor gd)
%  - a DS (data stream), if their number is infinite (see class constructor ds)
%
% ....

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998-99  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

% snag_local_symbols;

strpr1='1 gd processing';
strpr2='2 gd processing';

% switch snagos
% case 'unix'
%    strpr1='1 gd proc';
%    strpr2='2 gd proc';
% end
   
figNumber=figure( ...
    'Name','Snag', ...
    'NumberTitle','off', ...
    'Color',[1 1 0.7],...
    'MenuBar','none',...
    'Visible','off');

%===================================
% Set up the Snag Window
top=0.95;
left=0.05;
right=0.75;
bottom=0.20;
labelHt=0.05;
spacing=0.005;
promptStr=str2mat(' ',' % Press the update button', ...
    ' to have updated gd list');
% First, the Snag Window frame
frmBorder=0.02;
frmPos=[left-frmBorder bottom-frmBorder ...
    (right-left)+2*frmBorder (top-bottom)+2*frmBorder];
uicontrol( ...
    'Style','frame', ...
    'Units','normalized', ...
    'Position',frmPos, ...
    'BackgroundColor',[0.50 0.50 1]);
% Then the text label
labelPos=[left top-labelHt (right-left) labelHt];
uicontrol( ...
    'Style','text', ...
    'Units','normalized', ...
    'Position',labelPos, ...
    'BackgroundColor',[0.50 0.50 1], ...
    'ForegroundColor',[1 1 1], ...
    'String','Snag gd''s window');
% Then the text field
mcwPos=[left bottom (right-left) top-bottom-labelHt-spacing];
mcwHndl=uicontrol( ...
    'Style','text', ...
    'HorizontalAlignment','left', ...
    'Units','normalized', ...
    'Max',10, ...
    'BackgroundColor',[1 1 1], ...
    'Position',mcwPos, ...
    'String',promptStr);
% Save this handle for future use
set(gcf,'UserData',mcwHndl);

%====================================
% Information for all buttons
labelColor=[0.8 0.8 0.8];
top=0.95;
left=0.80;
btnWid=0.15;
btnHt=0.08;
% Spacing between the button and the next command's label
spacing=0.027;

%====================================
% The CONSOLE frame
frmBorder=0.02;
yPos=0.05-frmBorder;
frmPos=[left-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
uicontrol( ...
    'Style','frame', ...
    'Units','normalized', ...
    'Position',frmPos, ...
    'BackgroundColor',[0.50 0.50 1]);

%====================================
% The PROC1 button
btnNumber=1;
yPos=top-(btnNumber-1)*(btnHt+spacing);
labelStr=strpr1;
callbackStr='uiproc1gd';

% Generic popup button information
btnPos=[left yPos-btnHt btnWid btnHt];
uicontrol( ...
    'Style','pushbutton', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',[0.80 0.80 1], ...
    'String',labelStr, ...
    'Callback',callbackStr);

%====================================
% The PROC2 button
btnNumber=2;
yPos=top-(btnNumber-1)*(btnHt+spacing);
labelStr=strpr2;
callbackStr='uiproc2gd';

% Generic popup button information
btnPos=[left yPos-btnHt btnWid btnHt];
uicontrol( ...
    'Style','pushbutton', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',[0.80 0.80 1], ...
    'String',labelStr, ...
    'Callback',callbackStr);
 
top=yPos-1.7*spacing-btnHt;

%====================================
% The PLOT button
btnNumber=1;
yPos=top-(btnNumber-1)*(btnHt+spacing);
labelStr='gd Plot';
callbackStr='gd_plot';

% Generic popup button information
btnPos=[left yPos-btnHt btnWid btnHt];
uicontrol( ...
    'Style','pushbutton', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',[0.70 0.70 1], ...
    'String',labelStr, ...
    'Callback',callbackStr);

%====================================
% The CPLOT button
btnNumber=2;
yPos=top-(btnNumber-1)*(btnHt+spacing);
labelStr='gd C-plot';
callbackStr='gd_cplot';

% Generic popup button information
btnPos=[left yPos-btnHt btnWid btnHt];
uicontrol( ...
    'Style','pushbutton', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',[0.70 0.70 1], ...
    'String',labelStr, ...
    'Callback',callbackStr);

%====================================
% The STAT button
btnNumber=3;
yPos=top-(btnNumber-1)*(btnHt+spacing);
labelStr='gd Stat';
callbackStr='gd_stat';   

% Generic popup button information
btnPos=[left yPos-btnHt btnWid btnHt];
uicontrol( ...
    'Style','pushbutton', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',[0.70 0.70 1], ...
    'String',labelStr, ...
    'Callback',callbackStr);
 
top=yPos-1.7*spacing-btnHt;

%====================================
% The MORE button
btnNumber=1;
yPos=top-(btnNumber-1)*(btnHt+spacing);
labelStr='More';
callbackStr='moresnag';   

% Generic popup button information
btnPos=[left yPos-btnHt btnWid btnHt];
uicontrol( ...
    'Style','pushbutton', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',[0.80 0.80 1], ...
    'String',labelStr, ...
    'Callback',callbackStr);
 
top=yPos-1.7*spacing-btnHt;

%====================================
% The APPLICATION button
btnNumber=1;
yPos=top-(btnNumber-1)*(btnHt+spacing);
labelStr='Applications';
callbackStr='uiapplication';

% Generic popup button information
btnPos=[left yPos-btnHt btnWid btnHt];
uicontrol( ...
    'Style','pushbutton', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',[0.70 0.70 1], ...
    'String',labelStr, ...
    'Callback',callbackStr);

%====================================
% The DEMO button
btnNumber=2;
yPos=top-(btnNumber-1)*(btnHt+spacing);
labelStr='Demo';
callbackStr='uidemo';

% Generic popup button information
btnPos=[left yPos-btnHt btnWid btnHt];
uicontrol( ...
    'Style','pushbutton', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',[0.70 0.70 1], ...
    'String',labelStr, ...
    'Callback',callbackStr);

%====================================
% The bottom buttons

left=0.04;
yPos=0.05;
%btnWid1=btnWid*0.8
showgdoltot={' '};

btnPos=[left yPos btnWid btnHt];
%callbackStr=strcat('listgd;a=showol(gdol);',...
%   'set(mcwHndl,''string'',a);');
callbackStr=strcat('showgdoltotset;',...
   'set(mcwHndl,''string'',showgdoltot);');

uicontrol( ...
    'Style','pushbutton', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',[1 0.70 0.7], ...
    'String','Update', ...
    'Callback',callbackStr);
 
left=left+btnWid+0.04;
btnPos=[left yPos btnWid btnHt];
callbackStr='newgdgui';

uicontrol( ...
    'Style','pushbutton', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',[0.80 0.80 1], ...
    'String','New gd', ...
    'Callback',callbackStr);
  
left=left+btnWid+0.04;
btnPos=[left yPos btnWid btnHt];
callbackStr='deletegd;';

uicontrol( ...
    'Style','pushbutton', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',[0.80 0.80 1], ...
    'String','Delete gd', ...
    'Callback',callbackStr);
 
left=left+btnWid+0.04;
btnPos=[left yPos btnWid btnHt];
callbackStr='web([snagdir ''doc/snag/snaggui.htm'']);';

uicontrol( ...
    'Style','pushbutton', ...
    'Units','normalized', ...
    'Position',btnPos, ...
    'BackgroundColor',[0.70 1 0.70], ...
    'String','Help', ...
    'Callback',callbackStr);
 
% Now uncover the figure
set(figNumber,'Visible','on');



