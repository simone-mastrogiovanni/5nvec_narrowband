function [t v]=resume_deca_pm(decadir,dir1,fil1,level)
% RESUME_ DECA_PM checks the deca pm structures, with resumé and creation of a sbl file.
%                  Works only with Type 2 peakmap files
%
%   decadir   directory containing the decades
%   dir1      first directory
%   fil1      first file
%   level     >0 creates file with spectra
%
%  e.g.  [t v]=resume_deca_pm('Y:\pss\virgo\pm\VSR1-v2','deca_20070518','pm_VSR1_20070518-1.vbl',1)

% Version 2.0 - September 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

disp(['directory ' decadir])
eval(['cd ' decadir])

file=[dir1 '\' fil1]

vbl_=vbl_open(file);

if vbl_.nch ~= 5
    disp(' *** Not type 2 peakmap file !')
    return
end

lenx=vbl_.ch(3).lenx;
dx=vbl_.ch(3).dx;
DT=1/(dx*2);

t=zeros(50000,1);
v=zeros(50000,3);
sbhead=[0 0];

if level > 0
    sbl_.nch=3;
    sbl_.len=0;
    sbl_.capt='spec from pm files';
    ch(1)=vbl_.ch(1);
    ch(2)=vbl_.ch(2);
    ch(3)=vbl_.ch(3);
    sbl_.ch=ch;
    sbl_.t0=vbl_.t0;
    sbl_=sbl_openw('deca_spec.sbl',sbl_);
end

ii=0;
tim0=0;

while 1
    vbl_=vbl_nextbl(vbl_);
    if vbl_.eof > 0
        fclose(vbl_.fid);
        file=[vbl_.filppost '\' vbl_.filspost]
        vbl_=vbl_open(file);
        if vbl_.eof == 2
            break
        end
        vbl_=vbl_nextbl(vbl_);
    end
    
    ii=ii+1;
    t(ii)=vbl_.bltime;
    vbl_.ch0.next=-1;
    vbl_=vbl_nextch(vbl_);
    vv=fread(vbl_.fid,3,'double');
    v(ii,:)=vv;
    vbl_=vbl_nextch(vbl_);
    sp=fread(vbl_.fid,vbl_.ch0.lenx,'float'); % figure,semilogy(sp)
    sp(length(sp)+1:vbl_.ch0.lenx)=0;
    splen=vbl_.ch0.lenx;
    vbl_=vbl_nextch(vbl_);
    ind=fread(vbl_.fid,vbl_.ch0.lenx,'int32');
    vbl_=vbl_nextch(vbl_);
    ind(splen+1)=vbl_.ch0.lenx;
    dind=diff(ind); % figure,plot(dind)
    if tim0 > 0
        if abs((t(ii)-tim0)*86400-DT)>1
            hole=(t(ii)-tim0)*86400-DT; %hole=(t(ii)-tim0)*86400,dx
        end
    end
    tim0=t(ii);
    
    if level > 0
        sbl_headblw(sbl_.fid,ii,tim0);
        sbl_write(sbl_.fid,sbhead,6,vv);%size(vv)
        sbl_write(sbl_.fid,sbhead,4,sp);%size(sp)
        sbl_write(sbl_.fid,sbhead,3,dind);%size(dind)
    end
end

t=t(1:ii);
v=v(1:ii,:);

if level > 0
    nbl=ii
    fseek(sbl_.fid,24,'bof');
    fwrite(sbl_.fid,nbl,'uint32');
    fclose(sbl_.fid);
end

