function out=notyetout(str)

strin=sprintf(' %s feature not yet implemented',str);
h=warndlg(strin, 'Work in progress');
set(h,'Color',[0.8,0.8,1]);
out=0;