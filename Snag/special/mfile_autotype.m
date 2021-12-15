function fil=mfile_autotype

stmfile993=dbstack;
n=length(stmfile993);
fil=stmfile993(n).file;
eval(['type ' fil])
