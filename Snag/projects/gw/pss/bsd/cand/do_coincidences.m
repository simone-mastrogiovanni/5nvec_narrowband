%do_conincidences
%use the info from cand_tab produced by Orn_info_cand
%load the tables Hcand_tab and Lcand_tab and epochs end candtot
kepoch=0;
dist=2

nbands=height(Hcand_tab);

jo=jobinfH(:,2); 
bands=unique(jo); %[10:10:700]

inH.epoch=epochH
inL.epoch=epochL


cointot_candH=[]
cointot_candL=[]
coininfo=[]

for i = 1:nbands
    
   inH.dsd=Hcand_tab.dsd(i)
   inH.dfr=Hcand_tab.dfr(i)
    
   inL.dsd=Lcand_tab.dsd(i)
   inL.dfr=Lcand_tab.dsd(i)
   
    ii=find(candtotH(1,:) >= bands(i) & candtotH(1,:) < bands(i)+10);
    candH=candtotH(:,ii);
    
    ii=find(candtotL(1,:) >= bands(i) & candtotL(1,:) < bands(i)+10);
    candL=candtotL(:,ii);
    
    coin=coin_candidates_direc(inH,inL,candH,candL,dist,kepoch);
    
    if ~isempty(coin.cand1)
        eval(['coin_' num2str(i) '= coin;']);
        cointot_candH=[cointot_candH,coin.cand1]; %H
        cointot_candL=[cointot_candL,coin.cand2]; %L
        coininfo=[coininfo, coin];
    end
    
    
end