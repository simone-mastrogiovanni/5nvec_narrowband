function ntot=cerca_flutt(tobs,nev,nin,nore,n)
%CERCA_FLUTT   cerca fluttuazioni
%
%  si generano nev eventi in tobs(1) <-> tobs(2), si analizzano i casi in
%  cui ce ne siano almeno nin in nore ore solari successive. Si cercano n casi
%  positivi

npos=0;
ntot=0;

while npos < n
    t=rand(nev,1)*(tobs(2)-tobs(1))+tobs(1);
    h=(t-floor(t))*24;
    hi=hist(h,24);
    ntot=ntot+1;
    
    for i = 1:24
        ii(1)=i;
        for j = 2:nore
            ii(j)=i+j-1;
            if ii(j) > 24
                ii(j)=ii(j)-24;
            end
        end
        if sum(hi(ii)) >= nin
            npos=npos+1;
            if n < 10
                t=sort(t);
                ev_period(t,[1 1],0,'sold',24,0,0);
                ev_spec(t,[0 1],0,0,4,12);
            end
        end
    end
end
    