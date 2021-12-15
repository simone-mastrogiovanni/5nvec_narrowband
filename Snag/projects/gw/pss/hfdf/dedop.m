function peaks=dedop(peaks,factdop)

n_of_ff=length(peaks);
ii=find(diff(peaks(1,:)));
ii=[ii n_of_ff];
nt=length(ii);

if length(factdop) ~= nt
    disp(sprintf(' *** factdop error: length %d expected %d',length(factdop),nt))
%     return
end

ii0=1;

for it = 1:nt
    peaks(2,ii0:ii(it))=peaks(2,ii0:ii(it))*factdop(it);
    ii0=ii(it)+1;
end
