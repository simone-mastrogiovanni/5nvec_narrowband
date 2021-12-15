%IREADASCII   interactive access to readascii

prompt={'File name ?' 'Number of comment lines to skip ?' ...
      'Number of columns ?' 'Double array name ?'};
defa={'?','0','1' 'y'};
answ=inputdlg(prompt,'Read an ASCII data file to a double array',1,defa);

file=answ{1};
ncomments=eval(answ{2});
ncol=eval(answ{3});

str=[answ{4} '=readascii(file,ncomments,ncol);'];
eval(str);
