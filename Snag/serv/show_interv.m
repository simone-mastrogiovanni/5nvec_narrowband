function [t0 tot]=show_interv(yesint)
% show_interv shows interval data yesint(2,n)

t0=floor(yesint(1,1));
yes=yesint-t0;

[n1 n]=size(yes);

tot=sum(yes(2,:))-sum(yes(1,:));

fprintf('start at %f  total on %d \n',t0,tot)

figure

for i = 1:n
    plot([yes(1,i) yes(1,i)],[0 1]),hold on
    plot([yes(1,i) yes(2,i)],[1 1],'r')
    plot([yes(2,i) yes(2,i)],[0 1])
end

grid on, xlim([0 ceil(yes(2,n))]),ylim([0 1.1])