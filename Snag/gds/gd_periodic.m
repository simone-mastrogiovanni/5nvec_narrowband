function y=gd_periodic(per,dt,amp,len,typ,par1,par2)
%GD_PERIODIC  creates periodic signals
%
%   per      period
%   dt       sampling time
%   amp      amplitude
%   len      length
%   typ      type: 'triang', 'rect', ...
%   par1,2   parameters
%            'triang' -> par1 perc peak, par2 bias
%            'rect'   -> par1 perc pos, par2 bias
%            'drect'  -> double rectangle, par1 perc tot width, par2 bias

y=zeros(len,1);

nn=per/dt;
nn1=nn*par1;
x=0;
ifi=round(nn1);
ini=x+1;

if strcmp(typ,'drect')
    nn2=ceil(nn1/2);
    while ifi < len
        y(ini:ini+nn2-1)=1;
        y(ini+nn2:ifi)=-1;
        x=x+nn;
        ini=round(x+1);
        ifi=round(x+nn1);
    end
    
    y(ini:len)=1;
    bias=par1;
    y=(y-bias);
else
    while ifi < len
        y(ini:ifi)=1;
        x=x+nn;%disp([ini ifi])
        ini=round(x+1);
        ifi=round(x+nn1);
    end
    y(ini:len)=1;

    bias=par1;

    if strcmp(typ,'rect')
        y=(y-bias);
    end
    if strcmp(typ,'triang')
        y=y-bias;
        y=cumsum(y);
    end
end

a=max(y)-min(y);
y=y*amp/a+par2;
y=gd(y);
y=edit_gd(y,'dx',dt,'capt',typ);