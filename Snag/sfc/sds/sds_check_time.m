function [ck,dtim,kper]=sds_check_time(tim0,tim1,pers)
%SDS_CHECK_TIME  checks the bounds of a time interval
%
%      tim0,tim1  interval bounds
%         pers    (n,2) array containing the start and stop time of the n allowed periods
%
%          ck     = 0 -> completely external 
%                 = 1 -> beginning internal, end external
%                 = 2 -> beginning external, end internal
%                 = 3 -> completely internal
%                 = 4 -> embedding one or more periods 
%                        (beginning and end external, but enbedding)
%         dtim    time inside
%         kper    number of chosen period

[n,dum]=size(pers);
if dum < 2
    error('error in the pers array');
end
i0=0;
i1=0;
kper=0;
dtim=0;

for i = 1:n
    t0=pers(i,1);
    t1=pers(i,2);
    if tim0 >= t0 & tim0 <= t1
        i0=1;
        kper=i;
        t0=tim0;
        if tim1 >= pers(i,1) & tim1 <= pers(i,2)
            i1=1;
            dtim=tim1-tim0;
        else
            dtim=t1-tim0;
        end
    end
end

if kper == 0
    for i = 1:n
        t0=pers(i,1);
        t1=pers(i,2);
        if tim1 >= t0 & tim1 <= t1
            i1=1;
            kper=i
            dtim=tim1-t0;
        end
	end
end

ck=i0+2*i1;

if ck == 0
    dtim=0;
    for i = 1:n
        t0=pers(i,1);
        t1=pers(i,2);
        if tim0 <= t0 & tim1 >= t1
            ck=4;
            kper=i;
            dtim=dtim+t1-t0;
        end
	end
end