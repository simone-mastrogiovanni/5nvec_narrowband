function reduce_post(inmat2,step,path)
 % This program take the output file from  pss2 not reduced and find the
 % local maxima eache sub-bands with a lenght decided by the user
 %inmat2: Name of the file in output from pss2 (SM version)
 % step: The length of each sub-band
 % path: where to save the reduced files
 %OUTPUT
 % outfile: contain the local maxima over a given sub-band
 %   r_Sfft: Maximum value of the detection statistic in any sub-band
 %   r_fra: Frequency associated to the maximum of the DS
 %   r_hvectors: Estimators associated to the maximums of DS
 %   info: Information struct about freq bins etc...

 load(inmat2,'Sfft','Sfftshifted','fra','info','hvectors','count_sd')
 step=floor(step/info.binfsid)*info.binfsid; % Rescale the sub-band length to match with the grid 
 step_len=round(step/info.binfsid);
 fprintf('It will be selected a maximum every %e Hz \n', step);

% Select the maximum DS between the half-bin and the normal one%%%%%%%  
 is=find(Sfft>=Sfftshifted); 
 isf=find(Sfftshifted>Sfft);
 Sfull(is)=Sfft(is);
 Sfull(isf)=Sfftshifted(isf);
 frafull(is)=fra(is);
 frafull(isf)=fra(isf)+0.5*info.binfsid; % Find the frequency
 hvectorsfull.hplusfft(is)=hvectors.hplusfft(is);
 hvectorsfull.hcrossfft(is)=hvectors.hcrossfft(is);
 hvectorsfull.hplusfft(isf)=hvectors.hplusfftshifted(isf);
 hvectorsfull.hcrossfft(isf)=hvectors.hcrossfftshifted(isf);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%% Adapat the Array length to the frequency grid %%%%%%%%%%%%%%%%%%%%
 new_length=floor(length(Sfft)/step_len)*step_len;
 Sfull=Sfull(1:new_length);
 frafull=frafull(1:new_length);
 hvectorsfull.hplusfft=hvectorsfull.hplusfft(1:new_length);
 hvectorsfull.hcrossfft=hvectorsfull.hcrossfft(1:new_length);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 Sfull_m=reshape(Sfull,step_len,length(Sfull)/step_len);
 frafull_m=reshape(frafull,step_len,length(Sfull)/step_len);
 hvectorsfull_m.hplusfft=reshape(hvectorsfull.hplusfft,step_len,length(Sfull)/step_len);
 hvectorsfull_m.hcrossfft=reshape(hvectorsfull.hcrossfft,step_len,length(Sfull)/step_len);
 
 [nonmiservi,imax_reduce]=max(Sfull_m);
 
 r_Sfft=zeros(1,length(Sfull)/step_len);
 r_fra=zeros(1,length(Sfull)/step_len);
 r_hvectors.hplusfft=zeros(1,length(Sfull)/step_len);
 r_hvectors.hcrossfft=zeros(1,length(Sfull)/step_len);
     
 for i=1:1:length(Sfull)/step_len
     r_Sfft(i)=Sfull_m(imax_reduce(i),i);
     r_fra(i)=frafull_m(imax_reduce(i),i);
     r_hvectors.hplusfft(i)=hvectorsfull_m.hplusfft(imax_reduce(i),i);
     r_hvectors.hcrossfft(i)=hvectorsfull_m.hcrossfft(imax_reduce(i),i);
     
     
 end
 
 
%  for c_band=(frafull(1)+0.5*step):step:(frafull(end)-0.5*step) % Select the maximum in each sub band
%     iff=find(frafull>=(c_band-0.5*step) & frafull<=(c_band+0.5*step));
%     [maxS,pos]=max(Sfull(iff));
%     r_Sfft(count)=maxS;
%     r_fra(count)=frafull(iff(pos));
%     r_hvectors.hplusfft(count)=hvectorsfull.hplusfft(iff(pos));
%     r_hvectors.hcrossfft(count)=hvectorsfull.hcrossfft(iff(pos));
%     count=count+1;    
%  end
 [pathstr,name,ext] = fileparts(inmat2);
 save(fullfile(path,['reduced_',name,ext]),'r_Sfft','r_fra','r_hvectors','info','count_sd','step');
 
 
end
