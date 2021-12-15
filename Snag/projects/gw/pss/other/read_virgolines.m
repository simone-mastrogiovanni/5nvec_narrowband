function fr=read_virgolines(minfreq,maxfreq)

if ~exist('minfreq','var')
    minfreq=10;
end
if minfreq == 0
    minfreq=0;
end
if ~exist('maxfreq','var')
    maxfreq=2000;
end
if maxfreq == 0
    maxfreq=10^9;
end

file=selfile(' ','File with lines ?');

fid=fopen(file);
k=0;

while ~feof(fid)
    line=fgets(fid);
    if line(1) ~= '%' && length(line) > 4
        A=sscanf(line,' %f',[2,1]);
        if length(A) == 2 && A(1) <= maxfreq && A(1) >= minfreq
            k=k+1;
            fr(k,1)=A(1);
            fr(k,2)=A(2)*2;
            fr(k,3)=1;
            fr(k,4)=0;
        end
    end
end
        
        