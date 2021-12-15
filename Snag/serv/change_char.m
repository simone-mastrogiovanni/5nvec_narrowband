function strout=change_char(strin,ch1,ch2)
% CHANGE_CHAR  changes a character in a string, example: '\' in '/'
%
%      strout=change_char(strin,ch1,ch2)
%
%    strin   input string
%    ch1     character to be changed with ch2

k=strfind(strin,ch1);
strout=strin;

strout(k)=ch2;