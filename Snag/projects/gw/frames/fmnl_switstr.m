function [nsh,numsr]=fmnl_switstr(fid,len,class,swp,listsh,nsh,numsr,file)

% FMNL_SWITSTR  Reads structure according to its type
%
%               fid -> file identifier 
%               len -> length of structure
%               class -> structure class
%               swp -> screen output switch ( 0 off , 1 on) 
%               listsh -> list of frame type names
%               
%               nsh -> vector containing structures' classtype
%               numsr -> number of structures of every classtype according the order of nsh
%
%
% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


switch class
      case 1
      [namefr,classtype]=fmnl_readsh(fid,len,class,swp);
      x=strmatch(cellstr(namefr),listsh,'exact');
      nsh(x)=classtype;
      numsr(1)=numsr(1)+1;
      
      case 2
      fmnl_readse(fid,len,class,swp);  
      numsr(2)=numsr(2)+1;
      
      case nsh(1)
      fmnl_readfrh(fid,len,class,swp);
      numsr(3)=numsr(3)+1;
      
      case nsh(2)
      fmnl_readfradc(fid,len,class,swp);
      numsr(4)=numsr(4)+1;
      
      case nsh(3)
      fmnl_readfrdet(fid,len,class,swp);
      numsr(5)=numsr(5)+1;      
      
      case nsh(4)
      fmnl_readfreof(fid,len,class,swp);
      numsr(6)=numsr(6)+1;
      
      case nsh(5)
      fmnl_readfrmsg(fid,len,class,swp);
      numsr(7)=numsr(7)+1;
      
      case nsh(6)
      fmnl_readfrhist(fid,len,class,swp);
      numsr(8)=numsr(8)+1;      
      
      case nsh(7)
      fmnl_readfrraw(fid,len,class,swp);
      numsr(8)=numsr(8)+1;     
      
      case nsh(8)
      fmnl_readfrproc(fid,len,class,swp);
      numsr(10)=numsr(10)+1;      
      
      case nsh(9)
      fmnl_readfrsimd(fid,len,class,swp);
      numsr(11)=numsr(11)+1;     
      
      case nsh(10)
      fmnl_readfrserdata(fid,len,class,swp);
      numsr(12)=numsr(12)+1;  
      
      case nsh(11)
      fmnl_readfrstatdata(fid,len,class,swp);
      numsr(13)=numsr(13)+1;   
      
      case nsh(12)
      fmnl_readfrvect(fid,len,class,swp);
      numsr(14)=numsr(14)+1;     
      
      case nsh(13)
      fmnl_readfrtrig(fid,len,class,swp);
      numsr(15)=numsr(15)+1;    
      
      case nsh(14)
      fmnl_readfrsumm(fid,len,class,swp);
      numsr(16)=numsr(16)+1;      
      
      case nsh(15)
      fmnl_readfrtable(fid,len,class,swp);
      numsr(17)=numsr(17)+1;
      
      case nsh(16)
      fmnl_readfrtoc(fid,len,class,swp);
      numsr(18)=numsr(18)+1;     
      
      case nsh(17)
      fmnl_readfreofile(fid,len,class,file,swp);
      numsr(19)=numsr(19)+1;
      
      end % Switch