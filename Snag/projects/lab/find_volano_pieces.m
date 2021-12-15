function ii=find_volano_pieces(s)
% FIND_VOLANO_PIECES in volano data 
%

toll=0.05;
itoll=5;
lenmin=20;
smin=min(s)+toll;
smax=max(s)-toll;
n=length(s);
isal0=1; 
isal=0; % salita 1, discesa -1
mxrel=s(1);
iii=0;

for i = itoll+1:n-itoll
    a1=s(i-itoll);
    a2=s(i);
    a3=s(i+itoll);
    if (a1-a2)*(a2-a3) < 0
        mxrel=a2;
        if isal0 > 0
            isal0=0;
            ii(iii,2)=i;
            if ii(iii,2)-ii(iii,1) < lenmin
                iii=iii-1;
            end
        end
    else
        isal=sign(a3-a1);
    end
    if isal ~= isal0
        if isal < 0
            if a2 < mxrel-toll
                isal0=isal;
                iii=iii+1;
                ii(iii,1)=i-itoll;
            end
        else
            if a2 < smin
                isal0=isal;
                iii=iii+1;
                ii(iii,1)=i;
            end
        end
    else
        if isal < 0
            if a2 < smin
                isal0=0;
                ii(iii,2)=i;
                if ii(iii,2)-ii(iii,1) < lenmin
                    iii=iii-1;
                end
            end
        end
    end
end

% if ii(iii,2) <= 0
%     iii=iii-1;
% end
iii=iii-1;

ii=ii(1:iii,:);               
            