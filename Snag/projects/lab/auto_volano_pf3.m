% auto_volano_pf3

[t,s,dt,n]=leggi_pasco;

% answ=inputdlg('Incertezza sulle misure ?');
% unc=eval(answ{1});
unc=0.001
kk=find_volano_pieces(s);

data=data_polyfit(t,s,unc,0,-3,kk);

for i = 1:length(data)
    disp('____________________________________')
    str=sprintf(' pezzo %d  coefficienti ',i);
    for j = 1:length(data(i).a)
        str1=sprintf(' %f,  ',data(i).a(j));
        str=[str str1];
    end
    disp(str)
    
    str=sprintf('             incertezze ',i);
    for j = 1:length(data(i).a)
        str1=sprintf(' %f,  ',data(i).aunc(j));
        str=[str str1];
    end
    disp(str)
    
    prob=1-chi2cdf(data(i).chiq,data(i).ndof);
    str=sprintf('    chi quadro %f   N.g.l. %d    probabilità = %f ',...
        data(i).chiq,data(i).ndof,prob);
    disp(str)
end

disp(' i  inix icsal   t s=0     v s=0     t v=0     a v=0   c3')
for i = 1:length(data)
    icsal=1;
    if data(i).y(1) > data(i).y(length(data(i).y))
        icsal=0;
    end
    xmin=min(data(i).x);
    xmax=max(data(i).x);
    spos=data(i).a;
    ts0=roots(spos);
    zer=roots(spos);
    vel=polyder(spos);
    acc=polyder(vel);
    tv0=roots(vel);
    if icsal == 1
        s0a=xmin;
        v0a=xmax;
    else
        v0a=xmin;
        s0a=xmax;
    end
    [aa,ii]=min(abs(ts0-s0a));
    ts0=ts0(ii);
    velins0=polyval(vel,ts0);
    [aa,ii]=min(abs(tv0-s0a));
    tv0=tv0(ii);
    accinv0=polyval(acc,tv0);
    str=sprintf(' %d   %f   %d   %f  %f  %f  %f    %f',i,xmin,icsal,ts0,velins0,tv0,accinv0,spos(1));
    disp(str)
    volfit(i).xmin=xmin;
    volfit(i).icsal=icsal;
    volfit(i).spos=spos;
    volfit(i).vel=[ts0 velins0];
    volfit(i).acc=[tv0 accinv0];
end

