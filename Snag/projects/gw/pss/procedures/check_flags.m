% check_flags
%
%  seg1=read_Vsegments(-1); % per file V1_SEGMENTS_CAT1.txt
%  
%  segSM=read_Vsegments(0); % per file V1_ITF_SCIENCEMODE_VSR1_v1.txt

x=x_gd(gwC);
dt=dx_gd(gwC);
y=real(y_gd(gwC));
ii=find(y==0);
y0=y*0;
y1=y0;y2=y0;
t0=cont_gd(gwC);
ma=max(y);
y0(ii)=1;

figure,hold on
plot(gC,'y')
plot(x,y,'c')
plot(x,y0*ma,'LineWidth',2),grid on

for i = 2:length(seg1)
    t1=(seg1(2,i-1)-t0)*86400/dt+1;
    t2=(seg1(1,i)-t0)*86400/dt+1;
    if t1 > 0
        plot([t1 t1],[0 0.98]*ma,'r','LineWidth',2)
        plot([t1 t2],[0.98 0.98]*ma,'r','LineWidth',2)
        plot([t2 t2],[0 0.98]*ma,'r','LineWidth',2)
        y1(round(t1):round(t2))=1;
    end
end

for i = 1:length(segSM)
    t1=(segSM(1,i)-t0)*86400/dt+1;
    t2=(segSM(2,i)-t0)*86400/dt+1;
    if t1 > 0
        plot([t1 t1],[0 0.96]*ma,'g','LineWidth',2)
        plot([t1 t2],[0.96 0.96]*ma,'g','LineWidth',2)
        plot([t2 t2],[0 0.96]*ma,'g','LineWidth',2)
        y2(round(t1):round(t2))=1;
    end
end

N=length(y0);
