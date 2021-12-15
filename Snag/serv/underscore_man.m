function out=underscore_man(in)
% underscore_man  underscore management on strings, typically for titles
%                 
%  converts "_" in "\_" and "._" to "_"

k=strfind(in,'_');
n=length(k);

ii=1;
out1='';

for i = 1:n
    out1=[out1 in(ii:k(i)-1)];
    out1=[out1 '\_'];
    ii=k(i)+1;
end

out1=[out1 in(ii:length(in))];

k=strfind(out1,'.\_');
n=length(k);

ii=1;
out='';

for i = 1:n
    out=[out out1(ii:k(i)-1)];
    out=[out '_'];
    ii=k(i)+3;
end

out=[out out1(ii:length(out1))];