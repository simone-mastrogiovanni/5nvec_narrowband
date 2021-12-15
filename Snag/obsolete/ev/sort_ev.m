function eo=sort_ev(ei)
%SORT_EV  sorts events on starting time

for i = 1:length(ei)
    t(i)=ei(i).t;
end
[t,t]=sort(t);
eo=ei(t);
