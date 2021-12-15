function out=tit_underscore(in)

ifin=strfind(in,'_');
if length(ifin) <= 0
    out=in;
    return
end
n=length(in);
i1=1;
j1=1;
out=[];

for i = 1:length(ifin)
    i2=ifin(i)-1;
    j2=j1+i2-i1;
    out(j1:j2)=in(i1:i2);
    out(j2+1:j2+2)='\_';
    i1=i2+2;
    j1=j2+3;
end

n1=n-i2-1;
out(j1:j1+n1-1)=in(i1:n);
out=char(out);