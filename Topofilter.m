%% Monte Carlo Simulation fashioned after GLUE analysis
%%Calculate SDRf from all cells i draining to each reach segment j and
%%calculate SDRs from each reach segment j to watershed outlet

%Set model domain & dimensions
Lat=size(Lf,1);
Lon=size(Lf,2); %1452 for UL
reachN=size(reachdata,1); %number of reaches in watershed
density=1.3; %Mg/m3 of mud

%set up SDRs output variable arrays
SI_reach=zeros(reachN,n); %sediment input at reach =SLf + netNCS loading
SDRs_reach=zeros(reachN,n); %SDRs at reach_j
SL_reach=zeros(reachN,n); %sediment loading from reach_j of SEDSB j
SDs_reach=zeros(reachN,n); %sediment deposition in mass
SDs_mm_reach=zeros(reachN,n); %sediment deposition in volume
SDRf_reachDA=zeros(reachN,n);%meanSDRf of SEDSB
SLf_soilloss_reachDA=zeros(reachN,n);%SDRf_i =SLf_i/soilloss_i of SEDSB
SLf_reachDA=zeros(reachN,n); %sediment loading of SEDSB
SDf_reachDA=zeros(reachN,n); %sediment deposition (Mg) of SEDSB
SDf_mm_reachDA=zeros(reachN,n); %sediment deposition (mm) of SEDSB
SL_wat=zeros(1,n); %sediment loading from the Topowat
SL_wat_err=zeros(1,n); %residual error of computed SL against observed data
SDRfb=zeros(reachN,n); %SDRf in the buffer zone where Lf<100m
SLfb=zeros(reachN,n); %Sediment loading from buffer zone
SDRff=zeros(reachN,n); %SDRf in the rest of the field
SLff=zeros(reachN,n); %SL from the rest of the field


h=waitbar(0,'Full MC simulation running...'); %display simulation progress
tic %computation time ticker
for i=1:n 
    waitbar(i/n)    

    %%set the follwoing to zeros so for each MC run
    SEb=zeros(reachN,1);
    SEf=zeros(reachN,1);
    %set up SDRf outputs vars
    cellstoreach=zeros(reachN,1);
    soilloss_reachDA=zeros(reachN,1); %soil loss in the reach DA
    SDRs_reach_mean=zeros(reachN,1);
    cellsb=zeros(reachN,1);
    cellsf=zeros(reachN,1);
    
    %calculate SDR for all cells in watershed
    SDRf=exp(a1(i).*(dEf./Lf).^b1(i).*Lf);
    SLf=SDRf.*soilloss; %sediment loading from frield
    SDf=(1-SDRf).*soilloss; %sediment deposition on field
    
    %set the NaN cells to zero
    soilloss(isnan(soilloss))=0;
    SDRf(isnan(SDRf))=0;
    SLf(isnan(SLf))=0;
    SDf(isnan(SDf))=0;

    for j=1:reachN
        cellstoreach(j)=0;
        cellsb(j)=0;
        cellsf(j)=0;
        
        for k=1:Lat %for each watershed cell in each column
        for l=1:Lon % for each watersehd cell in each row
           
            if reachdata(j,3)==reachDA(k,l) %check if the cell drains to the reach_j(=SEDSB_j)
                cellstoreach(j)=cellstoreach(j)+1;
                %cal sediment delivery from field to reach_j
                soilloss_reachDA(j)=soilloss_reachDA(j)+soilloss(k,l);
                %SDRf_reachDA(j,i)=SDRf_reachDA(j,i)+SDRf(k,l); 
                SLf_reachDA(j,i)=SLf_reachDA(j,i)+SLf(k,l); %sediment loading from field in stream
                SDf_reachDA(j,i)=SDf_reachDA(j,i)+SDf(k,l); %Sed deposited in field                
                
                %cal SDRfb, SDRff
                if Lf(k,l)<=100
                    %SDRfb(j,i)=SDRfb(j,i)+SDRf(k,l); %SDRf in the buffer zone but calculated this from SLfb/SEb
                    SEb(j)=SEb(j)+soilloss(k,l); %Soil erosion in the buffer zone
                    SLfb(j,i)=SLfb(j,i)+SLf(k,l); %sed loading from buffer zone 
                    cellsb(j)=cellsb(j)+1;
                else
                    %SDRff(j,i)=SDRff(j,i)+SDRf(k,l);
                    SEf(j)=SEf(j)+soilloss(k,l);
                    SLff(j,i)=SLff(j,i)+SLf(k,l);
                    cellsf(j)=cellsf(j)+1;
                end
            end     
        end
        end
        
        %calc sediment delivery from field to reach
        %SLf_soilloss_reachDA(j,i)=SLf_reachDA(j,i)/soilloss_reachDA(j);%SDRfmean=SLf_j/soilloss_j        
        SDRf_reachDA(j,i)=SLf_reachDA(j,i)/soilloss_reachDA(j); %SDRf_reachDA(j,i)/cellstoreach(j); %mean over calculated SDRf_j
        SDf_mm_reachDA(j,i)=SDf_reachDA(j,i)/(density*cellstoreach(j)*30^2)*1000; %sediment deposition in mm   
        
        SDRfb(j,i)=SLfb(j,i)/SEb(j);%SDRfb(j,i)/cellsb(j);
        SDRff(j,i)=SLff(j,i)/SEf(j);%SDRff(j,i)/cellsf(j);
        
        %calc sediment deliver from reach_j to watershed outlet
        SI_reach(j,i)=reachdata(j,22)+reachdata(j,24)+reachdata(j,25)+SLf_reachDA(j,i); 

        %reachdata(j,26)+SLf_reachDA(j,i); %Sediment input at reach j = (Net NCS loading) + (Sediment Loading from field)
        
        SDRs_reach(j,i)=exp(a2(i)*reachdata(j,15)*(reachdata(j,17)/reachdata(j,14))^b2(i)); %SDRs=exp(ac(dE/dL)^b*dL*B)
        
        SL_reach(j,i)=SI_reach(j,i)*SDRs_reach(j,i); %sediment Loading from each reach [Mg/yr]
        SDs_reach(j,i)=SI_reach(j,i)*(1-SDRs_reach(j,i)); %sediment deposit [Mg/yr]
        SDs_mm_reach(j,i)=SDs_reach(j,i)/(density*reachdata(j,10))*1000; %sediment deposit on floodplain accomodation area
        
        SL_reach(isnan(SL_reach))=0;
        SDRs_reach_mean(j)=SDRs_reach_mean(j)+SDRs_reach(j,i);  
        SL_wat(i)=SL_wat(i)+SL_reach(j,i);%<--for LO %sum up sediment loading from all reaches in watersehd for MC i
        
    end %end reach loop SEDSB_j
    
    SL_wat_err(i)=(SL_wat(i)-SLobs)/SLobs*100;

end %end MC loop i
SDRs_reach_mean=SDRs_reach_mean/n;
toc
close(h)

%%Generate additional output variables
%Output stats
SLbar=mean(SL_wat);
SLmedian=median(SL_wat);
SLf_wat=sum(SLf_reachDA);
%Transpose output variables
SDRf_ReachDA_T=transpose(SDRf_reachDA);
SDRs_Reach_T=transpose(SDRs_reach);
SDRfb_T=transpose(SDRfb);
SDRff_T=transpose(SDRff);

%%Returen model output summary
disp(['Observed SL          =' num2str(SLobs)])
disp(['Average simulated SL =' num2str(SLbar)])
disp(['Median simulated SL  =' num2str(SLmedian)])
%disp(['Average simulated STD=' num2str(SLstd)])
disp(['Average simulated SLf=' num2str(mean(SLf_wat))])
%disp(['Average simulated SDRf=' num2str(mean(nansum(SDRf_reachDA)./reachN))])
disp(['Average simulated SDRs=' num2str(mean(sum(SDRs_reach)./reachN))])

%% Topofilter output figure generator
%Dotty plots of the parameters vs. simulated sediment loading (Figure 10)
%Dotty plots of the parameter vs. residual error (Figure 11)
%Histogram of frequency distribution of simulated sediment loading values(Figure 20)

figure(10)
subplot(1,4,1)
title('|error| vs. parameters')
plot(a1,abs(SL_wat_err),'.','MarkerSize',4)
xlabel('a1')
ylabel('rel.err.(%)')
subplot(1,4,2)
plot(b1,abs(SL_wat_err),'.','MarkerSize',4)
xlabel('b1')
subplot(1,4,3)
plot(a2,abs(SL_wat_err),'.','MarkerSize',4)
xlabel('a2')
subplot(1,4,4)
plot(b2,abs(SL_wat_err),'.','MarkerSize',4)
xlabel('b2')

figure(11)
subplot(1,4,1)
title('|SL| vs. parameters')
plot(a1,abs(SL_wat),'.','MarkerSize',4)
xlabel('a1')
ylabel('SL (Mg)')
subplot(1,4,2)
plot(b1,abs(SL_wat),'.','MarkerSize',4)
xlabel('b1')
subplot(1,4,3)
plot(a2,abs(SL_wat),'.','MarkerSize',4)
xlabel('a2')
subplot(1,4,4)
plot(b2,abs(SL_wat),'.','MarkerSize',4)
xlabel('b2')

figure(20)
subplot(2,1,1)
histogram(SLf_wat)
title('PDF of sediment input from field to stream');
xlabel('Sediment Input [Mg/yr]')
ylabel('Frequency of MC realization' )
legend('simulated SI_F')
subplot(2,1,2)
histogram(SL_wat)
title('PDF of sediment loading at the Toposhed outlet');
line([SLbar,SLbar],ylim,'Color','k')
line([SLobs,SLobs],ylim,'Color','k','LineStyle','--')
xlabel('Sediment loading [Mg/yr]')
ylabel('Frequency of MC realization' )
legend('simulated SL_T','Average SL_T','Observed SL_T')

