% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%
% %%% A questo punto suddivido l'intervallo di frequenze dato
% %%% in sottointervalli e costruisco lo spettro di 
% %%% energia del segnale che voglio rivelare nelle varie bande.
% %%% Gli spettri di potenza che costruisco sono delle gaussiane
% %%% (entro la banda di frequenza date) 
% %%% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% 
% %%% Le bande di frequenza (iniziali) in cui mi costruisco gli 
% %%% spettri di energia del segnale che voglio rivelare sono:
% %%%
% %%% 20-40 Hz , 40-80 Hz , 80-160 Hz , 160-320 Hz , 320-640 Hz , 640-1280 Hz
% %%% 1280 - 2560 Hz, 2560 - 5000 Hz (-----> non vado oltre 5000!)
% %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%% Primo intervallo "investigato"  20 - 40 Hz!
% 
% %%% PS1_signal(omega) e' lo spettro di energia (ipotizzato!)del segnale
% %%% che voglio rivelare, in questa banda! 
% %%%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% 
% dim_finestra=dim/4;
% dim_interlac=dim_finestra/4;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%
% %%% Problema del finestramento!!
% %%%
% %%% Per evitare fenomeni di discontinuita', il finestramento nella
% %%% banda della frequenza deve essere fatto nel modo seguente:
% %%% 
% %%% Siano bin0, bin1, bin2, ....... bin(2^k)
% %%% i vari bin di frequenza della finestra,
% %%% deve essere:
% %%%
% %%% bin0 = unico e reale 
% %%% bin1 = bin(2^k - 1)
% %%% bin2 = bin(2^k - 2)
% %%% bin3 = bin(2^k - 3)
% %%%
% %%% ......
% %%% bin(2^k-1) = 0
% %%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% Definisco la funzione window:
% 
% Window=1:dim_finestra;
% Window(1)=1.0;
% Window(dim_finestra)=0.0;
% for k=2:dim_finestra/2
%     Window(k)=Window(dim_finestra-1);
% end
% figure(9999)
% plot(Window)
% 
% PS1=1:dim_finestra;
% sigma1=2.2;
% const1=(1.0/sqrt(2.0*pi))*sigma1;
% mu1=30.0;
% coeff=dim/dim_finestra;
% k=1:dim_finestra;
% for j=1:dim_finestra
%     if(j==1)
%        k(j)=freq_resol*coeff;
%     else
%        k(j)=freq_resol*coeff+k(j-1);
%     end
% end
% PS1_signal=const1*exp(-((k-mu1).*(k-mu1))/(2.0*sigma1^2));
% PS1_signal=scale_factor*PS1_signal;
% figure(4)
% bar(k,PS1_signal)
% PS1_signal=sqrt(PS1_signal);
% axis([0 50 0 1])
% scale_factor=10e-12;
% 
% matched=1:dim_finestra;
% output_matched=1:dim_finestra;
% pulse_matched=1:dim_finestra;
% N_finestre=dim/dim_finestra;
% N_interlac=dim_finestra/dim_interlac;
% p=(N_finestre-1)*N_interlac;
% output1=p:dim_finestra;
% for h=1:p
%     for i=j:dim_finestra
%          if(j<=dim_finestra)
%              n=(h-1)*dim_interlac+j;
%              matched(j)=PS1_signal(j)*white_factor(n);
%              if(j==1)
%                  pulse_matched(j)=freq_resol;
%              elseif(j>1 & j<dim_finestra)
%                  pulse_matched(j)=freq_resol+pulse_matched(j-1);
%              elseif(i==dim_finestra)
%                  pulse_matched(j)=freq_resol+pulse_matched(j-1);
%                  max_pulse=pulse_matched(j);
%              end    
%          end
%          if(j<=dim_finestra)
%              n=(h-1)*dim_interlac+j;
%              output_matched(j)=matched(j)*h_recon_freq(n);
%              output1(h,j)=output_matched(j);
%          end
%      end
% %      figure(100+h)
% %      loglog(pulse_matched,matched)
% %      axis([0 max_pulse 10e-20 10e-3])
% %      figure(1000+h)
% %      loglog(pulse_matched,output_matched)
% %      axis([0 max_pulse 10e-20 10e-3])
%  end
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Secondo intervallo investigato 40-80 Hz
% 
% PS2=1:dim_finestra;
% sigma2=3.8;
% const2=(1.0/sqrt(2.0*pi))*sigma2;
% mu2=60.0;
% coeff=dim/dim_finestra;
% k=1:dim_finestra;
% for j=1:dim_finestra
%     if(j==1)
%        k(j)=freq_resol*coeff;
%     else
%        k(j)=freq_resol*coeff+k(j-1);
%     end
% end
% PS2_signal=const2*exp(-((k-mu2).*(k-mu2))/(2.0*sigma2^2));
% PS2_signal=scale_factor*PS2_signal;
% figure(5)
% PS2_signal=sqrt(PS2_signal);
% bar(k,PS2_signal)
% axis([30 90 0 1])
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% p=(N_finestre-1)*N_interlac;
% output2=p:dim_finestra;
% for h=1:p
%     for i=j:dim_finestra
%          if(j<=dim_finestra)
%              n=(h-1)*dim_interlac+j;
%              matched(j)=PS1_signal(j)*white_factor(n);
%              if(j==1)
%                  pulse_matched(j)=freq_resol;
%              elseif(j>1 & j<dim_finestra)
%                  pulse_matched(j)=freq_resol+pulse_matched(j-1);
%              elseif(i==dim_finestra)
%                  pulse_matched(j)=freq_resol+pulse_matched(j-1);
%                  max_pulse=pulse_matched(j);
%              end    
%          end
%          if(j<=dim_finestra)
%              n=(h-1)*dim_interlac+j;
%              output_matched(j)=matched(j)*h_recon_freq(n);
%              output2(h,j)=output_matched(j);
%          end
%      end
% %      figure(200+h)
% %      loglog(pulse_matched,matched)
% %      axis([0 max_pulse 10e-20 10e-3])
% %      figure(2000+h)
% %      loglog(pulse_matched,output_matched)
% %      axis([0 max_pulse 10e-20 10e-3])
%  end
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% % Terzo intervallo 80-160 Hz!!
% 
% 
% PS3=1:dim_finestra;
% sigma3=6.5;
% const3=(1.0/sqrt(2.0*pi))*sigma3;
% mu3=120.0;
% coeff=dim/dim_finestra;
% k=1:dim_finestra;
% for j=1:dim_finestra
%     if(j==1)
%        k(j)=freq_resol*coeff;
%     else
%        k(j)=freq_resol*coeff+k(j-1);
%     end
% end
% PS3_signal=const3*exp(-((k-mu3).*(k-mu3))/(2.0*sigma3^2));
% PS3_signal=scale_factor*PS3_signal;
% PS3_signal=sqrt(PS3_signal);
% figure(6)
% bar(k,PS3_signal)
% axis([60 180 0 1])
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% p=(N_finestre-1)*N_interlac;
% output3=p:dim_finestra;
% for h=1:p
%     for i=j:dim_finestra
%          if(j<=dim_finestra)
%              n=(h-1)*dim_interlac+j;
%              matched(j)=PS1_signal(j)*white_factor(n);
%              if(j==1)
%                  pulse_matched(j)=freq_resol;
%              elseif(j>1 & j<dim_finestra)
%                  pulse_matched(j)=freq_resol+pulse_matched(j-1);
%              elseif(i==dim_finestra)
%                  pulse_matched(j)=freq_resol+pulse_matched(j-1);
%                  max_pulse=pulse_matched(j);
%              end    
%          end
%          if(j<=dim_finestra)
%              n=(h-1)*dim_interlac+j;
%              output_matched(j)=matched(j)*h_recon_freq(n);
%              output3(h,j)=output_matched(j);
%          end
%      end
% %      figure(300+h)
% %      loglog(pulse_matched,matched)
% %      axis([0 max_pulse 10e-20 10e-3])
% %      figure(3000+h)
% %      loglog(pulse_matched,output_matched)
% %      axis([0 max_pulse 10e-20 10e-3])
%  end
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %
% % Quarto intervallo investigato 160-320 Hz!!
% 
% 
% PS4=1:dim_finestra;
% sigma4=8.5;
% const4=(1.0/sqrt(2.0*pi))*sigma4;
% mu4=240.0;
% coeff=dim/dim_finestra;
% k=1:dim_finestra;
% for j=1:dim_finestra
%     if(j==1)
%        k(j)=freq_resol*coeff;
%     else
%        k(j)=freq_resol*coeff+k(j-1);
%     end
% end
% PS4_signal=const4*exp(-((k-mu4).*(k-mu4))/(2.0*sigma4^2));
% PS4_signal=scale_factor*PS4_signal;
% PS4_signal=sqrt(PS4_signal);
% figure(7)
% bar(k,PS4_signal)
% axis([140 340 0 1])
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% p=(N_finestre-1)*N_interlac;
% output4=p:dim_finestra;
% for h=1:p
%     for i=j:dim_finestra
%          if(j<=dim_finestra)
%              n=(h-1)*dim_interlac+j;
%              matched(j)=PS1_signal(j)*white_factor(n);
%              if(j==1)
%                  pulse_matched(j)=freq_resol;
%              elseif(j>1 & j<dim_finestra)
%                  pulse_matched(j)=freq_resol+pulse_matched(j-1);
%              elseif(i==dim_finestra)
%                  pulse_matched(j)=freq_resol+pulse_matched(j-1);
%                  max_pulse=pulse_matched(j);
%              end    
%          end
%          if(j<=dim_finestra)
%              n=(h-1)*dim_interlac+j;
%              output_matched(j)=matched(j)*h_recon_freq(n);
%              output4(h,j)=output_matched(j);
%          end
%      end
% %      figure(400+h)
% %      loglog(pulse_matched,matched)
% %      axis([0 max_pulse 10e-20 10e-3])
% %      figure(4000+h)
% %      loglog(pulse_matched,output_matched)
% %      axis([0 max_pulse 10e-20 10e-3])
%  end
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% %
% % Quinto intervallo investigato 320-640 Hz!!
% 
% 
% PS5=1:dim_finestra;
% sigma5=12.5;
% const5=(1.0/sqrt(2.0*pi))*sigma5;
% mu5=480.0;
% coeff=dim/dim_finestra;
% k=1:dim_finestra;
% for j=1:dim_finestra
%     if(j==1)
%        k(j)=freq_resol*coeff;
%     else
%        k(j)=freq_resol*coeff+k(j-1);
%     end
% end
% PS5_signal=const5*exp(-((k-mu5).*(k-mu5))/(2.0*sigma5^2));
% PS5_signal=scale_factor*PS5_signal;
% PS5_signal=sqrt(PS5_signal);
% figure(8)
% bar(k,PS5_signal)
% axis([300 660 0 1])
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% p=(N_finestre-1)*N_interlac;
% output5=p:dim_finestra;
% for h=1:p
%     for i=j:dim_finestra
%          if(j<=dim_finestra)
%              n=(h-1)*dim_interlac+j;
%              matched(j)=PS1_signal(j)*white_factor(n);
%              if(j==1)
%                  pulse_matched(j)=freq_resol;
%              elseif(j>1 & j<dim_finestra)
%                  pulse_matched(j)=freq_resol+pulse_matched(j-1);
%              elseif(i==dim_finestra)
%                  pulse_matched(j)=freq_resol+pulse_matched(j-1);
%                  max_pulse=pulse_matched(j);
%              end    
%          end
%          if(j<=dim_finestra)
%              n=(h-1)*dim_interlac+j;
%              output_matched(j)=matched(j)*h_recon_freq(n);
%              output5(h,j)=output_matched(j);
%          end
%      end
% %      figure(500+h)
% %      loglog(pulse_matched,matched)
% %      axis([0 max_pulse 10e-20 10e-3])
% %      figure(5000+h)
% %      loglog(pulse_matched,output_matched)
% %      axis([0 max_pulse 10e-20 10e-3])
%  end
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% % Sesto intervallo investigato 640-1280 Hz!!
% %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% 
% PS6=1:dim_finestra;
% sigma6=20.5;
% const6=(1.0/sqrt(2.0*pi))*sigma6;
% mu6=960.0;
% coeff=dim/dim_finestra;
% k=1:dim_finestra;
% for j=1:dim_finestra
%     if(j==1)
%        k(j)=freq_resol*coeff;
%     else
%        k(j)=freq_resol*coeff+k(j-1);
%     end
% end
% PS6_signal=const6*exp(-((k-mu6).*(k-mu6))/(2.0*sigma6^2));
% PS6_signal=scale_factor*PS6_signal;
% PS6_signal=sqrt(PS6_signal);
% figure(9)
% bar(k,PS6_signal)
% axis([600 1300 0 1])
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% p=(N_finestre-1)*N_interlac;
% output6=p:dim_finestra;
% for h=1:p
%     for i=j:dim_finestra
%          if(j<=dim_finestra)
%              n=(h-1)*dim_interlac+j;
%              matched(j)=PS1_signal(j)*white_factor(n);
%              if(j==1)
%                  pulse_matched(j)=freq_resol;
%              elseif(j>1 & j<dim_finestra)
%                  pulse_matched(j)=freq_resol+pulse_matched(j-1);
%              elseif(i==dim_finestra)
%                  pulse_matched(j)=freq_resol+pulse_matched(j-1);
%                  max_pulse=pulse_matched(j);
%              end    
%          end
%          if(j<=dim_finestra)
%              n=(h-1)*dim_interlac+j;
%              output_matched(j)=matched(j)*h_recon_freq(n);
%              output6(h,j)=output_matched(j);
%          end
%      end
% %      figure(600+h)
% %      loglog(pulse_matched,matched)
% %      axis([0 max_pulse 10e-20 10e-3])
% %      figure(6000+h)
% %      loglog(pulse_matched,output_matched)
% %      axis([0 max_pulse 10e-20 10e-3])
%  end
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%% Premesso che manca ancora una banda di frequenza da investigare, 
% %%% il passo successivo da fare e' fare l'antitrasformata delle singole
% %%% finestre, e sulle antitrasformate fissare delle soglie (NEL 
% %%% DOMINIO DEL TEMPO!!!!!)
% %%% per fare questo mi cosruisco i rapporti critici
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
