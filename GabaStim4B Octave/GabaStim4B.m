function [] = GabaStim4B(ExpDate, file, Unitn, SamplingRate, a, b, c, d, e, atd, ard, val_SaveDataSelect, val_PlotDataSelect, PPR_check, peak_1_threshold, peak_2_threshold)
% Written by Cedric 22-07-2008
% update:25-09-2008
% WORKING WELL


 

%% load data

%%%%%%% ATTENTION %%%%%%% fill ExpDate (ex: '2008_07_03')
%%%%%%% ATTENTION %%%%%%% and file (ex: 'GBST_1_18')

% ExpDate='20080826'
% file='GBST_2_04_30'
% Unitn= 'U03'
% 
% SamplingRate = 50 %50us
% a= 20000 % pre test pulse (ex:20ms)
% b= 10000 % test pulse duration (ex:10ms)
% c= 100000 % post test pulse(ex:100ms)
% d= 150000 % post stim1 (ex:150ms)
% e= 150000 % post stim2 (ex:150ms)
% atd= 50 %artefact theoretical duration (ex:0.05 ms)
% ard= 1400 %artefact real duration 500us to adjust acordingly
% val_SaveDataSelect= 0 or 1


%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
display ('SELECTING NEW FILE...')
x{1}=[ExpDate, file];
ExpDateUnitFile=x{1}


load (ExpDate)

rawdatatable = ExpUnitName.(ExpDate).data.(file).RawDataTable{1,1};

sweepnumber= ExpUnitName.(ExpDate).data.(file).RawDataTable{1,4};
% sweepnumber=30

[m,n] =size (rawdatatable);

rawdatatable(:, n+1)= mean (rawdatatable(:, 1:n), 2);

tt=0;
for i=1:m
    rawdatatable(i, n+2)= tt;
    tt=tt+SamplingRate;
end


%% TIME Points SCALE
time(1,1)=0;
time(2,1)= a-500;
time(3,1)= a-5000;
time(4,1)= a+(b./2);
time(5,1)= a+b-500;
time(6,1)= a+b+(b./2);
time(7,1)= a+b+10000;
time(8,1)= a+b+c-10000;
time(9,1)= a+b+c-11000;
time(10,1)= a+b+c-1000;
time(11,1)= a+b+c; %stim 1
time(12,1)= a+b+c+ard;
time(13,1)= a+b+c+30000;
time(14,1)= a+b+c+d+atd-11000;
time(15,1)= a+b+c+d+atd-1000;
time(16,1)= a+b+c+d; %stim 2
time(17,1)= a+b+c+d+ard;
time(18,1)= a+b+c+d+atd+30000;
time(19,1)= a+b+c+d+atd+atd+e-11000;
time(20,1)= a+b+c+d+atd+atd+e-1000;



%pretest baseline
TimePoints (1, 1)= 1;
TimePoints (2, 1)= time(2,1)./SamplingRate;

%Rs_1
TimePoints (3, 1)= time(3,1)./SamplingRate;
TimePoints (4, 1)= time(4,1)./SamplingRate;
 
%Rs_2
TimePoints (5, 1)= time(5,1)./SamplingRate;
TimePoints (6, 1)= time(6,1)./SamplingRate;
 
%Baseline
TimePoints (7, 1)= time(7,1)./SamplingRate;
TimePoints (8, 1)= time(8,1)./SamplingRate;
 
%Baseline prestim_1
TimePoints (9, 1)= time(9,1)./SamplingRate;
TimePoints (10, 1)= time(10,1)./SamplingRate;
 
%Artefact_1
TimePoints (11, 1)= time(11,1)./SamplingRate;
TimePoints (12, 1)= time(12,1)./SamplingRate;
%Peak_1
TimePoints (13, 1)= time(13,1)./SamplingRate;
 
%Baseline prestim_2
TimePoints (14, 1)= time(14,1)./SamplingRate;
TimePoints (15, 1)= time(15,1)./SamplingRate;
 
%Artefact_2
TimePoints (16, 1)= time(16,1)./SamplingRate;
TimePoints (17, 1)= time(17,1)./SamplingRate;
%Peak_2
TimePoints (18, 1)= time(18,1)./SamplingRate;
 
%Baseline PostStim
TimePoints (19, 1)= time(19,1)./SamplingRate;
TimePoints (20, 1)= time(20,1)./SamplingRate;


 
  
%% Baselines Table
% Column 1:n= sweeps
% Column n+1= sweeps averaged
% Row 1: BaselinePretest = mean(datanalysed (1:290, 1:n+1));
% Row 2: Baseline = mean(datanalysed (700:2950, 1:n+1));
% Row 3: BaselinePrestim_1 = mean(datanalysed (2700:2990, 1:n+1));
% Row 4: BaselinePrestim_2 = mean(datanalysed (5700:5990, 1:n+1));
% Row 5: BaselinePoststim = mean(datanalysed (8110:8400, 1:n+1));
% Row 6: BaselineMax= max(rawdatatable (TimePoints (7, 1):TimePoints (8,1), 1:n+1))
% BaselinesTable = [BaselinePretest; Baseline; BaselinePrestim_1; BaselinePrestim_2; BaselinePoststim]
 
BaselinesTable = [mean(rawdatatable (TimePoints (1, 1):TimePoints (2, 1), 1:n+1)); mean(rawdatatable (TimePoints (7, 1):TimePoints (8, 1), 1:n+1));mean(rawdatatable (TimePoints (9, 1):TimePoints (10, 1), 1:n+1));mean(rawdatatable (TimePoints (14, 1):TimePoints (15, 1), 1:n+1)); mean(rawdatatable (TimePoints (19, 1):TimePoints (20, 1), 1:n+1)); max(rawdatatable (TimePoints (7, 1):TimePoints (8,1), 1:n+1))];
 
 
%% Test Pulse Resistances
% resistanceTable: resistances in mega Ohm (10^6 Ohm)
    % row 1: Rs (resistance series or access)
    % Row 2: Rm (Membrane resistance)
 
U_testpulse = zeros(1,n+1);
for i=1:n+1;
    U_testpulse(1, i)= 0.005;
end
 
 
Is= abs(min(rawdatatable(TimePoints (3, 1):TimePoints (4, 1), 1:n+1))-BaselinesTable(1, :) );

Rs = zeros(1,n+1);
Rs=(U_testpulse./Is)./1000000;
Rm = (abs(U_testpulse./(mean(rawdatatable (TimePoints (3, 1):TimePoints (5, 1), 1:n+1))))-BaselinesTable(1, :) )./1000000;
ResistancesTable (1, :) = Rs;
ResistancesTable (2, :) = Rm;
 
 
%% Measure_peak_amplitude_time delay of evoked_responses, and Paired Pulse ratios (PPR)

%%%%% Evoked Response_1 %%%%%%
 
%Artefact
ArtefactAmp(1,:)= ((max(rawdatatable(TimePoints (11, 1):TimePoints (12, 1), 1:n+1)) - BaselinesTable(2, :)));
for i=1:n+1;for j=TimePoints (11, 1):TimePoints (12, 1);
        if rawdatatable(j, i)==(max(rawdatatable(TimePoints (11, 1):TimePoints (12, 1), i)));
        ArtefactTime(1,i)=rawdatatable(j,n+2);end; end; end
    
%Peak Amplitude
PeaksAmp(1,:)= ((max(rawdatatable(TimePoints (12, 1):TimePoints (13, 1), 1:n+1))) - BaselinesTable(2, :));

%Peak Time delay
for i=1:n+1;for j=TimePoints (12, 1):TimePoints (13, 1);
        if rawdatatable(j,i)==(max(rawdatatable(TimePoints (12, 1):TimePoints (13, 1), i)));
        PeaksTime(1,i)=rawdatatable(j,n+2);end; end; end


%%%%% Evoked Response_2 %%%%%%
 
%Artefact
ArtefactAmp(2,:)= ((max(rawdatatable(TimePoints (16, 1):TimePoints (17, 1), 1:n+1)) - BaselinesTable(2, :)));
for i=1:n+1;for j=TimePoints (16, 1):TimePoints (17, 1);
        if rawdatatable(j, i)==(max(rawdatatable(TimePoints (16, 1):TimePoints (17, 1), i)));
        ArtefactTime(2,i)=rawdatatable(j,n+2); end; end; end
    
%Peak Amplitude
PeaksAmp(2,:)= ((max(rawdatatable(TimePoints (17, 1):TimePoints (18, 1), 1:n+1))) - BaselinesTable(2, :));
 
%Peak Time delay (en us)
for i=1:n+1;for j=TimePoints (17, 1):TimePoints (18, 1);
        if rawdatatable(j, i)==(max(rawdatatable(TimePoints (17, 1):TimePoints (18, 1), i)));
        PeaksTime(2,i)=rawdatatable(j,n+2);end; end; end
   
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PPR =PeaksAmp(2,:)./PeaksAmp(1,:);
PeaksDelay=PeaksTime-ArtefactTime;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

%% statistical variability: exclusion criterium
if val_PlotDataSelect == 1;figure;  end
%subplot (2,2,1); 

RsSD=std(ResistancesTable(1,1:n));
RmSD=std(ResistancesTable(2,1:n));
BaselineSD= std(BaselinesTable(2,1:n));
BaselinepostSD= std(BaselinesTable(5,1:n));
Baselineprestim2SD = std(BaselinesTable(4,1:n));

PeaksDelaySD_1=std(PeaksDelay(1,1:n));
PeaksDelaySD_2=std(PeaksDelay(2,1:n));
 f=1;
 j=1;
 k=1;
 g=1;
for i=1:n
%     if    or((  or(  (   or(or(((abs(ResistancesTable (1, i)-ResistancesTable (1, n+1)))>(RsSD*3)), ((abs(BaselinesTable (2, i)-BaselinesTable (2, n+1))) >(BaselineSD*3))), ((abs (BaselinesTable(4, i)-BaselinesTable(4, n+1)))>(Baselineprestim2SD*3)) )   ),   ( (abs(BaselinesTable (5, i)- BaselinesTable (5, n+1)))>(BaselinepostSD*3)  )   )),(BaselinesTable (6, i)-BaselinesTable (2, i)>(10*10^-12)));
%         if val_PlotDataSelect == 1;
%         plot (rawdatatable(:,n+2), rawdatatable(:,i),'-g');end;
%             sweepWrong(1,g)=i;
%             g=g+1;
    
            % Artefacts
    if (min(rawdatatable (TimePoints(11, 1)+3000/SamplingRate:TimePoints (15,1), i)) - BaselinesTable (2, i)) <(-10*10^-12)
        if val_PlotDataSelect == 1;    
        plot (rawdatatable(:,n+2), rawdatatable(:,i),'-g');end;
            sweepWrong(1,g)=i;
            g=g+1;
    
            %%%%%% include the following elseif only for PPR analysis
            %%%%%% artefact
            elseif (PPR_check == 1 &&(min(rawdatatable (TimePoints(16, 1)+3000/SamplingRate:TimePoints (19,1), i)) - BaselinesTable (2, i)) <(-10*10^-12))
        if val_PlotDataSelect == 1;    
        plot (rawdatatable(:,n+2), rawdatatable(:,i),'-g');end;
            sweepWrong(1,g)=i;
            g=g+1;
            %%%%%%%%
            
    elseif (max(rawdatatable (TimePoints(4, 1)+3000/SamplingRate:TimePoints (5,1), i)) - BaselinesTable (2, i)) > 10*10^-12
            if val_PlotDataSelect == 1;    
            plot (rawdatatable(:,n+2), rawdatatable(:,i),'-g');end;
                sweepWrong(1,g)=i;
                g=g+1;
            
     %%% peak 1 treshold       
    elseif or((PeaksAmp(1,i)<(BaselineSD*2)),(PeaksAmp(1,i)<(BaselinesTable (6, i)-BaselinesTable (2, i)+(peak_1_threshold)) ))
%          elseif ((PeaksAmp(1,i)<(BaselinesTable (6, i)-BaselinesTable (2, i)+(0*10^-12)) ))

        if val_PlotDataSelect == 1;
        plot (rawdatatable(:,n+2), rawdatatable(:,i),'-b');hold on;plot(PeaksTime(1,i), PeaksAmp(1,i), 'ob'); end; 
        sweepfailure(1,k)=i;
        k=k+1;

%%%%%% include the following elseif only for PPR analysis
%%%%%% peak 2 treshold
    elseif (PPR_check == 1 && or((PeaksAmp(2,i)<(BaselineSD*2)),(PeaksAmp(2,i)<(BaselinesTable (6, i)-BaselinesTable (2, i)+(peak_2_threshold)) )) )
        if val_PlotDataSelect == 1;plot (rawdatatable(:,n+2), rawdatatable(:,i),'-c');hold on;plot(PeaksTime(2,i), PeaksAmp(2,i), 'oc');end;
        sweepfailure2(1,f)=i;
        f=f+1;
% %%%%%

%         
%     elseif or (((abs(PeaksDelay (1, i)-PeaksDelay (1, n+1)))>(PeaksDelaySD_1*2)),((abs(PeaksDelay (2, i)-PeaksDelay (2, n+1)))>(PeaksDelaySD_2*2)));
%                if val_PlotDataSelect == 1;
%             plot (rawdatatable(:,n+2), rawdatatable(:,i),'-y');hold on; plot(PeaksTime(1,i), PeaksAmp(1,i), 'oy');hold on;plot(PeaksTime(2,i), PeaksAmp(2,i), 'oy');end
%         sweepWrong(1,g)=i;
%             g=g+1;




    else
        if val_PlotDataSelect == 1;
            plot (rawdatatable(:,n+2), rawdatatable(:,i), '-k');end
        sweepselect(1,j)= i;
        j=j+1;
    end
   if val_PlotDataSelect == 1; hold on; end
    
end
if val_PlotDataSelect == 1;hold off;
legend('green: wrong (resistances or baseline more then 2std)', 'blue: failure (peak amp 1 less than 2std baseline)', 'yellow: wrong (time peak more than 2std)', 'black: selected');
title({ExpDate; file});
xlabel('Time (us)')
ylabel('current (A)')
end




%% Measure of variables for selected and failure data
% Variables definition:
% PeaksAmpSelect: nSelect+1 is peak of the mean trace
%                 nSelect+2 is the average of the peaks of the selected sweeps  
nSelect=j-1;
if nSelect>0
for i=1:nSelect;
    RawdataSelect(:,i)=rawdatatable(:,sweepselect(1,i));
    dataSelect(:,i)=RawdataSelect(:,i)-BaselinesTable(2, sweepselect(1,i));
    
end   
RawdataSelect(:,nSelect+1)= mean (RawdataSelect(:, 1:nSelect), 2);
RawdataSelect(:,nSelect+2)=rawdatatable(:,n+2);
dataSelect(:,nSelect+1) = mean (dataSelect(:, 1:nSelect), 2);
dataSelect(:,nSelect+2)=rawdatatable(:,n+2);

for i=1:nSelect;
    PeaksAmpSelect(:,i) = PeaksAmp(:,sweepselect(1,i));
    BaselinesTableSelect(:,i) = BaselinesTable(1:5,sweepselect(1,i));
    ResistancesTableSelect(:,i) = ResistancesTable(:,sweepselect(1,i));
    PeaksDelaySelect(:,i) = PeaksDelay(:,sweepselect(1,i));
    PPRselect(:,i) = PPR(:,sweepselect(1,i));
    PeaksTimeSelect(:,i) = PeaksTime(:,sweepselect(1,i));
    ArtefactAmpSelect(:,i)=ArtefactAmp(:,sweepselect(1,i));
    ArtefactTimeSelect(:,i) = ArtefactTime(:,sweepselect(1,i));
end   


    PeaksAmpSelect(1,nSelect+1) = max(dataSelect(TimePoints (12, 1):TimePoints (13, 1), nSelect+1));
    PeaksAmpSelect(2,nSelect+1) = max(dataSelect(TimePoints (17, 1):TimePoints (18, 1), nSelect+1));
    PeaksAmpSelect(:,nSelect+2) = mean (PeaksAmpSelect(:,1:nSelect),2);
    PeaksAmpSelect(1,nSelect+3) = std (PeaksAmpSelect(1,1:nSelect));
    PeaksAmpSelect(2,nSelect+3) = std (PeaksAmpSelect(2,1:nSelect));
    PeaksAmpSelect(:,nSelect+4) = PeaksAmpSelect(:,nSelect+3)./(sqrt(nSelect));
    
%     ; max(RawdataSelect (TimePoints (7, 1):TimePoints (8,1), 1:nSelect+1))
    BaselinesTableSelect(:,nSelect+1) = [mean(RawdataSelect (TimePoints (1, 1):TimePoints (2, 1), nSelect+1)); mean(RawdataSelect (TimePoints (7, 1):TimePoints (8, 1), nSelect+1));mean(RawdataSelect (TimePoints (9, 1):TimePoints (10, 1), nSelect+1));mean(RawdataSelect (TimePoints (14, 1):TimePoints (15, 1), nSelect+1)); mean(RawdataSelect (TimePoints (19, 1):TimePoints (20, 1), nSelect+1))];
    BaselinesTableSelect(:,nSelect+2) = mean (BaselinesTableSelect(:,1:nSelect),2);
    BaselinesTableSelect(1,nSelect+3) = std (BaselinesTableSelect(1,1:nSelect));
    BaselinesTableSelect(2,nSelect+3) = std (BaselinesTableSelect(2,1:nSelect));
    BaselinesTableSelect(3,nSelect+3) = std (BaselinesTableSelect(3,1:nSelect));
    BaselinesTableSelect(4,nSelect+3) = std (BaselinesTableSelect(4,1:nSelect));
    BaselinesTableSelect(5,nSelect+3) = std (BaselinesTableSelect(5,1:nSelect));
%     BaselinesTableSelect(6,nSelect+3) = std (BaselinesTableSelect(6,1:nSelect));
    BaselinesTableSelect(:,nSelect+4) = BaselinesTableSelect(:,nSelect+3)./(sqrt(nSelect));
        
    U_testpulse_MeanSelect=0.005;
    Iss_MeanSelect(1,:)= abs(min(dataSelect(TimePoints (3, 1):TimePoints (4, 1), nSelect+1)));
    Iss_MeanSelect(2,:)= abs(max(dataSelect(TimePoints (5, 1):TimePoints (6, 1), nSelect+1)));
    Is_MeanSelect=mean(Iss_MeanSelect);
    Rs_MeanSelect=(U_testpulse_MeanSelect./Is_MeanSelect)./1000000;
    Rm_MeanSelect = (abs(U_testpulse_MeanSelect./mean(dataSelect (TimePoints (3, 1):TimePoints (5, 1), nSelect+1))))./1000000;
    ResistancesTableSelect (1, nSelect+1) = Rs_MeanSelect;
    ResistancesTableSelect (2, nSelect+1) = Rm_MeanSelect;
    ResistancesTableSelect (:, nSelect+2) = mean (ResistancesTableSelect(:,1:nSelect),2);
    ResistancesTableSelect (1, nSelect+3) = std (ResistancesTableSelect(1,1:nSelect));
    ResistancesTableSelect (2, nSelect+3) = std (ResistancesTableSelect(2,2:nSelect));
    ResistancesTableSelect (:, nSelect+4) = ResistancesTableSelect(:, nSelect+3)./(sqrt(nSelect));
    
    
    max(dataSelect(TimePoints (12, 1):TimePoints (13, 1), nSelect+1))
    
    for j=TimePoints (12, 1):TimePoints (13, 1);
    if dataSelect(j,nSelect+1)==(max(dataSelect(TimePoints (12, 1):TimePoints (13, 1), nSelect+1)));
        PeaksTimeSelect(1,nSelect+1)=dataSelect(j,nSelect+2);end; end;    
    for j=TimePoints (17, 1):TimePoints (18, 1);
    if dataSelect(j,nSelect+1)==(max(dataSelect(TimePoints (17, 1):TimePoints (18, 1), nSelect+1)));
        PeaksTimeSelect(2,nSelect+1)=dataSelect(j,nSelect+2);end; end;    
    PeaksTimeSelect(:,nSelect+2)=mean(PeaksTimeSelect(:,1:nSelect),2);
    PeaksTimeSelect(1,nSelect+3)=std(PeaksTimeSelect(1,1:nSelect));
    PeaksTimeSelect(2,nSelect+3)=std(PeaksTimeSelect(2,1:nSelect));
    PeaksTimeSelect(:,nSelect+4)=PeaksTimeSelect(:,nSelect+3)./(sqrt(nSelect));    
    
    PPRselect(:,nSelect+1)=PeaksAmpSelect(2,nSelect+1)./PeaksAmpSelect(1,nSelect+1);
    PPRselect(:,nSelect+2)=mean(PPRselect(:,1:nSelect),2);
    PPRselect(:,nSelect+3)=std(PPRselect(:,1:nSelect));
    PPRselect(:,nSelect+4)=PPRselect(:,nSelect+3)./(sqrt(nSelect));
    
    ArtefactAmpSelect(1,nSelect+1)= max(dataSelect(TimePoints (11, 1):TimePoints (12, 1), nSelect+1));
    ArtefactAmpSelect(2,nSelect+1)= max(dataSelect(TimePoints (16, 1):TimePoints (17, 1), nSelect+1));
    ArtefactAmpSelect(:,nSelect+2)= mean (ArtefactAmpSelect(:,1:nSelect),2);
    ArtefactAmpSelect(1,nSelect+3)= std (ArtefactAmpSelect(1,1:nSelect));
    ArtefactAmpSelect(2,nSelect+3)= std (ArtefactAmpSelect(2,1:nSelect));
    ArtefactAmpSelect(:,nSelect+4)= ArtefactAmpSelect(:,nSelect+3)./(sqrt(nSelect));
    
    for j=TimePoints (11, 1):TimePoints (12, 1);
    if dataSelect(j, nSelect+1)==(max(dataSelect(TimePoints (11, 1):TimePoints (12, 1), nSelect+1)));
       ArtefactTimeSelect(1,nSelect+1)= dataSelect(j,nSelect+2);end; end
    for j=TimePoints (16, 1):TimePoints (17, 1);
    if dataSelect(j, nSelect+1)==(max(dataSelect(TimePoints (16, 1):TimePoints (17, 1), nSelect+1)));
       ArtefactTimeSelect(2,nSelect+1)= dataSelect(j,nSelect+2);end; end
    ArtefactTimeSelect(:,nSelect+2)= mean (ArtefactTimeSelect(:,1:nSelect),2);
    ArtefactTimeSelect(1,nSelect+3)= std (ArtefactTimeSelect(1,1:nSelect));
    ArtefactTimeSelect(2,nSelect+3)= std (ArtefactTimeSelect(2,1:nSelect));
    ArtefactTimeSelect(:,nSelect+4)= ArtefactTimeSelect(:,nSelect+3)./(sqrt(nSelect));

    PeaksDelaySelect(1,nSelect+1)=PeaksTimeSelect(1,nSelect+1)-ArtefactTimeSelect(1,nSelect+1);
    PeaksDelaySelect(2,nSelect+1)=PeaksTimeSelect(2,nSelect+1)-ArtefactTimeSelect(2,nSelect+1);
    PeaksDelaySelect(:,nSelect+2)=mean(PeaksDelaySelect(:,1:nSelect),2);
    PeaksDelaySelect(1,nSelect+3)=std(PeaksDelaySelect(1,1:nSelect));
    PeaksDelaySelect(2,nSelect+3)=std(PeaksDelaySelect(2,1:nSelect));
    PeaksDelaySelect(:,nSelect+4)=PeaksDelaySelect(:,nSelect+3)./(sqrt(nSelect));
    
end   
%% Rise Time of peak 1
StartRise=[]; FinishRise=[]; RTi=[];RTt=[];

for i=1:nSelect+1;
pstart(1,i)=PeaksAmpSelect(1,i)*0.2;
pfinish(1,i)=PeaksAmpSelect(1,i)*0.8;
    for j=TimePoints (12, 1):TimePoints (13, 1)
        if dataSelect(j,i)>= pstart(1,i);StartRise(1,i)=dataSelect(j,nSelect+2);break; end; end 
    for j=TimePoints (12, 1):TimePoints (13, 1)
        if dataSelect(j,i)>= pfinish(1,i);FinishRise(1,i)=dataSelect(j,nSelect+2); break; end; end 
end
RTt(1,:) = [StartRise(1,nSelect+1), FinishRise(1,nSelect+1)];
RTi(1,:) = [pstart(1,nSelect+1), pfinish(1,nSelect+1)];

RiseTimeTable(1,:)=FinishRise(1,:)-StartRise(1,:);

%% Rise Time of peak 2
for i=1:nSelect+1;
pstart(2,i)=PeaksAmpSelect(2,i)*0.2;
pfinish(2,i)=PeaksAmpSelect(2,i)*0.8;
    for j=TimePoints (17, 1):TimePoints (18, 1)
        if dataSelect(j,i)>= pstart(2,i); StartRise(2,i)=dataSelect(j,nSelect+2);break; end;end;
    for j=TimePoints (17, 1):TimePoints (18, 1)
        if dataSelect(j,i)>= pfinish(2,i); FinishRise(2,i)=dataSelect(j,nSelect+2);break; end;end;         
end

RTt(2,:) = [StartRise(2,nSelect+1), FinishRise(2,nSelect+1)];
RTi(2,:) = [pstart(2,nSelect+1), pfinish(2,nSelect+1)];

RiseTimeTable(2,:)=FinishRise(2,:)-StartRise(2,:);

%% Decay times
% YDecay1=dataSelect(:, nSelect+1);
% TimeDecay1=dataSelect(:, nSelect+2);
% outliers = excludedata(TimeDecay1,YDecay1,'domain',[PeaksTimeSelect(1,nSelect+1) (TimePoints(15, 1).*SamplingRate)]);
% x=TimeDecay1(~outliers);
% x=x-x(1,1);
% Ydata=YDecay1(~outliers);
% %1) Define model and fit options
% mymodel = fittype('a*exp(b*x) + c*exp(d*x)'); opts = fitoptions(mymodel); 
% %To set initial values of fitting parameters:
% opts.Startpoint=[1.607e-09 -2.525e-05 5.025e-11 -9.718e-06]; %=[a,b,c,d]
% %To set allowed limits for the fitting parameters
% %(to constrain the fit choose finite values):
% opts.Lower=[-Inf -Inf -Inf -Inf]; opts.Upper=[Inf Inf Inf Inf]; 
% opts.TolFun=1e-30;
% opts.TolX=1e-30;
% %2) Do the fit
% %opts.weight=1./Ierr.^2;
% [ffit,gof]=fit(x,Ydata,mymodel,opts)
% 
% %3) retrieve fit parameters and confidence intervals
% fitparam=coeffvalues(ffit); fitcfi=confint(ffit); 
% %if required retrieve the derivative of the fit
% ffitder=differentiate(ffit,Ydata);
% 
% %4) To visualize the fit:
% %generate fitting Boltzmann function
% a=fitparam(1);b=fitparam(2) ;c=fitparam(3) ;d=fitparam(4);
% f=a*exp(b*x) + c*exp(d*x);
% 
% figure
% plot(x,Ydata,['o-k'],'markersize',11), hold on
% hold on, plot(x,f,'--r','linewidth',2)
% hold off



%% Decay times of Peak 1

display('beginning fitting of Peak 1...');

YDecay=dataSelect(:, nSelect+1);
TimeDecay=dataSelect(:, nSelect+2);
Yerror=std(dataSelect(:, 1:nSelect), 0, 2);
outliers = excludedata(TimeDecay,YDecay,'domain',[PeaksTimeSelect(1,nSelect+1) (TimePoints(15, 1).*SamplingRate)]);
outliers2 = excludedata(TimeDecay,Yerror,'domain',[PeaksTimeSelect(1,nSelect+1) (TimePoints(15, 1).*SamplingRate)]);
Yerror=Yerror(~outliers2);
x=TimeDecay(~outliers);
Ydata=YDecay(~outliers);
%1) Define model and fit options
mymodel = fittype('a*exp(b*x) + c*exp(d*x)'); opts = fitoptions(mymodel); 
%To set initial values of fitting parameters:
opts.Startpoint=[1.607e-09 -2.525e-05 5.025e-11 -9.718e-06]; %=[a,b,c,d]
%To set allowed limits for the fitting parameters
%(to constrain the fit choose finite values):
opts.Lower=[-Inf -Inf -Inf -Inf]; opts.Upper=[Inf Inf Inf Inf]; 
opts.TolFun=1e-30;
opts.TolX=1e-30;
opts.MaxFunEvals=1000;
%2) Do the fit
%opts.weight=1./Yerror.^2;
[ffit,gof]=fit(x,Ydata,mymodel,opts)

%3) retrieve fit parameters and confidence intervals
fitparam=coeffvalues(ffit); fitcfi=confint(ffit); 
%if required retrieve the derivative of the fit
ffitder=differentiate(ffit,Ydata);

%4) To visualize the fit:
%generate fitting Boltzmann function
a=fitparam(1);b=fitparam(2) ;c=fitparam(3) ;d=fitparam(4);
x1=x;
f1=a*exp(b*x1) + c*exp(d*x1);

% figure
% plot(x,Ydata,['o-k'],'markersize',11)
% hold on, plot(x,f,'--r','linewidth',2)
% hold off
Tau1_Decay1=(-1/b)*1e-03 %Tau1_Decay1 est en ms
Tau2_Decay1=(-1/d)*1e-03 %Tau2_Decay1 est en ms
rsquare_fit_Decay1=gof.rsquare



%% Decay times of Peak 2

display('beginning fitting of Peak 2...');

clear ('YDecay', 'TimeDecay', 'Yerror','x','Ydata','outliers') 

YDecay=dataSelect(:, nSelect+1);
TimeDecay=dataSelect(:, nSelect+2);
Yerror=std(dataSelect(:, 1:nSelect), 0, 2);

outliers = excludedata(TimeDecay,YDecay,'domain',[PeaksTimeSelect(2,nSelect+1) (TimePoints(20, 1).*SamplingRate)]);
outliers2 = excludedata(TimeDecay,Yerror,'domain',[PeaksTimeSelect(2,nSelect+1) (TimePoints(20, 1).*SamplingRate)]);
Yerror=Yerror(~outliers2);
x=TimeDecay(~outliers);
Ydata=YDecay(~outliers);
%1) Define model and fit options
mymodel = fittype('a*exp(b*x) + c*exp(d*x)'); opts = fitoptions(mymodel); 
%To set initial values of fitting parameters:
opts.Startpoint=[1.134e-06 -7.054e-05 6.5e-08 -2.312e-05]; %=[a,b,c,d]


%To set allowed limits for the fitting parameters
%(to constrain the fit choose finite values):
opts.Lower=[-Inf -Inf -Inf -Inf]; opts.Upper=[Inf Inf Inf Inf]; 
opts.TolFun=1e-30;
opts.TolX=1e-30;
opts.MaxFunEvals=1000;
%2) Do the fit
%opts.weight=1./Yerror.^2;
[ffit,gof]=fit(x,Ydata,mymodel,opts)

%3) retrieve fit parameters and confidence intervals
fitparam=coeffvalues(ffit); fitcfi=confint(ffit); 
%if required retrieve the derivative of the fit
ffitder=differentiate(ffit,Ydata);

%4) To visualize the fit:
%generate fitting Boltzmann function
a=fitparam(1);b=fitparam(2) ;c=fitparam(3) ;d=fitparam(4);
x2=x;
f2=a*exp(b*x2) + c*exp(d*x2);

% figure
% plot(x,Ydata,['o-k'],'markersize',11)
% hold on, plot(x,f,'--r','linewidth',2)
% hold off
Tau1_Decay2=(-1/b)*1e-03 %ms
Tau2_Decay2=(-1/d)*1e-03 %ms
rsquare_fit_Decay2=gof.rsquare


FitDecayTimeTableSelect =[Tau1_Decay1 Tau2_Decay1 rsquare_fit_Decay1; Tau1_Decay2 Tau2_Decay2 rsquare_fit_Decay2]



%% "Decay times" Test Pulse : CAPACITANCE

% display('beginning capacitance estimation...');
% 
% clear ('YDecay', 'TimeDecay', 'Yerror','x','Ydata','outliers') 
%  
% YDecay=dataSelect(:, nSelect+1);
% TimeDecay=dataSelect(:, nSelect+2);
% Yerror=std(dataSelect(:, 1:nSelect), 0, 2);
% 
% 
% %time when to begin the fit (here : 20% the gap)
% 
% indic_time_1 = 1 ;
% 
% while (dataSelect(indic_time_1, nSelect+2) < TimePoints(4, 1).*SamplingRate )
%     indic_time_1 = indic_time_1 + 1;
% end
%     
% [Y_value_min, array_index] = min([dataSelect(1:indic_time_1, nSelect+1)]);
% 
% indic_time_2 = indic_time_1 ;
% 
% while (dataSelect(indic_time_2, nSelect+2) < TimePoints(5, 1).*SamplingRate )
%     indic_time_2 = indic_time_2 + 1;
% end
%     
% Y_value_baseline = dataSelect(indic_time_2, nSelect+1);
% 
% index_time_fit_begin = array_index ;
% while ( dataSelect(index_time_fit_begin, nSelect+1) < (0.8*Y_value_min + Y_value_baseline*0.2 ))
%     index_time_fit_begin = index_time_fit_begin + 1;
% end
% 
% time_fit_begin=dataSelect(index_time_fit_begin, nSelect+2);
% 
% 
% %pour "fitter" jusqu'à un certain niveau du saut (ex : 99%)  
% 
% %index_time_fit_stop = indic_time_2 ;
% %while ( dataSelect(index_time_fit_stop, nSelect+1) > (0.01*Y_value_min + Y_value_baseline*0.99 ))
%     %index_time_fit_stop = index_time_fit_stop - 1;
% %end
% 
% %time_fit_stop=dataSelect(index_time_fit_stop, nSelect+2);
% 
% 
% outliers = excludedata(TimeDecay,YDecay,'domain',[time_fit_begin (TimePoints(5, 1).*SamplingRate)]);
% outliers2 = excludedata(TimeDecay,Yerror,'domain',[time_fit_begin (TimePoints(5, 1).*SamplingRate)]);
% 
% 
% Yerror=Yerror(~outliers2);
% x=TimeDecay(~outliers);
% Ydata=YDecay(~outliers);
% 
% % 1) Define model and fit options
% 
% %mymodel = fittype('a*exp(b*x) + c*exp(d*x)'); opts = fitoptions(mymodel);
% mymodel = fittype('a*exp(b*x) + c'); opts = fitoptions(mymodel);
% 
% % To set initial values of fitting parameters:
% 
% 
% opts.Startpoint=[-1e-2 -1.3e-3 -1e11]; %=[a,b,c]
% 
% % To set allowed limits for the fitting parameters
% % (to constrain the fit choose finite values):
% 
% %opts.Lower=[-Inf -Inf -Inf -Inf]; opts.Upper=[Inf Inf Inf Inf]; 
% opts.Lower=[-Inf -Inf -Inf]; opts.Upper=[Inf Inf Inf]; 
% 
% opts.TolFun=1e-30;
% opts.TolX=1e-30;
% opts.MaxFunEvals=10000;
% 
% % 2) Do the fit
% % opts.weight=1./Yerror.^2;
% [ffit,gof]=fit(x,Ydata,mymodel,opts)
%  
% % 3) retrieve fit parameters and confidence intervals
% fitparam=coeffvalues(ffit); fitcfi=confint(ffit); 
% % if required retrieve the derivative of the fit
% ffitder=differentiate(ffit,Ydata);
% % 
% % 4) To visualize the fit:
% % generate fitting Boltzmann function
% 
% %a=fitparam(1);b=fitparam(2) ;c=fitparam(3) ;d=fitparam(4);
% a=fitparam(1);b=fitparam(2) ;c=fitparam(3) ;
% 
% x3=x;
% 
% %f3=a*exp(b*x3) + c*exp(d*x3);
% f3=a*exp(b*x3)+ c;
% 
% f3ab=a*exp(b*x3);
% %f3cd=c*exp(d*x3);
% f3cd=c;
% 
% Tau1_TestPulse1=(-1/b)*1e-03 %ms
% %Tau2_TestPulse1=(-1/d)*1e-03 %ms
% rsquare_fit_TestPulse1=gof.rsquare
% 
% FitCapacitanceMeanSelect = rsquare_fit_TestPulse1 ;
% 
% %capacitance estimation
% 
% 
% CapacitanceMeanSelect = (Tau1_TestPulse1 / Rs_MeanSelect)* 1e3  %capa en pF
% 
% 
% 
% % if ( 0 < Tau2_TestPulse1 & 0 < Tau1_TestPulse1 )
% %     CapacitanceMeanSelect = min(Tau2_TestPulse1, Tau1_TestPulse1) / Rm_MeanSelect
% % 
% % elseif ( 0 < Tau2_TestPulse1 & 0 > Tau1_TestPulse1 )
% %     CapacitanceMeanSelect = Tau2_TestPulse1 / Rm_MeanSelect
% % 
% % elseif ( 0 > Tau2_TestPulse1 & 0 < Tau1_TestPulse1 )
% %     CapacitanceMeanSelect = Tau1_TestPulse1 / Rm_MeanSelect 
% %     
% % else display('fit error !');
% %       
% % end
% 
% Resistance_series=Rs_MeanSelect
% Rm_MeanSelect    




%% Half width

%%%%First peak
HalfWidthStart=[]; HalfWidthFinish=[];
for i=1:nSelect+1;
pHalfWidth(1,i)=PeaksAmpSelect(1,i)*0.5;
    for j=TimePoints (12, 1):TimePoints (13, 1)
        if dataSelect(j,i)>= pHalfWidth(1,i);
            HalfWidthStart(1,i)= dataSelect(j,nSelect+2); break; end;end;
            
    for j=(PeaksTimeSelect(1,i)./SamplingRate):(TimePoints (13, 1)+(70000./SamplingRate))
        if dataSelect(j,i)<= pHalfWidth(1,i);
            HalfWidthFinish(1,i)= dataSelect(j,nSelect+2);break; end;end;
end
 
HWt(1,:) = [HalfWidthStart(1,nSelect+1) HalfWidthFinish(1,nSelect+1)];
HWi(1,:) = [pHalfWidth(1,nSelect+1) pHalfWidth(1,nSelect+1)];

HalfWidthTableSelect(1,:)=HalfWidthFinish(1,:)-HalfWidthStart(1,:);


%%%second peak

for i=1:nSelect+1;
pHalfWidth(2,i)=PeaksAmpSelect(2,i)*0.5;
    for j=TimePoints (17, 1):TimePoints (18, 1)
        if dataSelect(j,i)>= pHalfWidth(2,i);
            HalfWidthStart(2,i)= dataSelect(j,nSelect+2); break; end;end;
            
    for j=(PeaksTimeSelect(2,i)./SamplingRate):(TimePoints (18, 1)+(70000./SamplingRate))
        if dataSelect(j,i)<= pHalfWidth(2,i);
            HalfWidthFinish(2,i)= dataSelect(j,nSelect+2);break; end;end;
end
 
HWt(2,:) = [HalfWidthStart(2,nSelect+1) HalfWidthFinish(2,nSelect+1)];
HWi(2,:) = [pHalfWidth(2,nSelect+1) pHalfWidth(2,nSelect+1)];

HalfWidthTableSelect(2,:)=HalfWidthFinish(2,:)-HalfWidthStart(2,:);
    HalfWidthTableSelect(:,nSelect+2)=mean(HalfWidthTableSelect(:,1:nSelect),2);
    HalfWidthTableSelect(1,nSelect+3)=std(HalfWidthTableSelect(1,1:nSelect));
    HalfWidthTableSelect(2,nSelect+3)=std(HalfWidthTableSelect(2,1:nSelect));
    HalfWidthTableSelect(:,nSelect+4)=HalfWidthTableSelect(:,nSelect+3)./(sqrt(nSelect));





%%
nFailure=k-1
if nFailure>0
for i=1:nFailure;
    dataFailure(:,i)=rawdatatable(:,sweepfailure(1,i));
    
    PeaksAmpFailure(:,i) = PeaksAmp(:,sweepfailure(1,i));
    BaselinesTableFailure(:,i) = BaselinesTable(:,sweepfailure(1,i));
    ResistancesTableFailure(:,i) = ResistancesTable(:,sweepfailure(1,i));
    PeaksDelayFailure(:,i) = PeaksDelay(:,sweepfailure(1,i));
    PPRFailure(:,i) = PPR(:,sweepfailure(1,i));
    PeaksTimeFailure(:,i) = PeaksTime(:,sweepfailure(1,i));
    ArtefactTimeFailure(:,i) = ArtefactTime(:,sweepfailure(1,i));
end
dataFailure(:,nFailure+1) = mean (dataFailure(:, 1:nFailure), 2);
dataFailure(:,nFailure+2)=rawdatatable(:,n+2);

end


dataRaw=rawdatatable;
nRaw=n;


%% plot mean sweeps over time
if nSelect>0
if val_PlotDataSelect == 1;
    figure
subplot (2,1,1);
plot(dataSelect(:,nSelect+2),dataSelect(:,1:nSelect), '-k')

hold on
plot (PeaksTimeSelect(1:2,1:nSelect),PeaksAmpSelect(1:2,1:nSelect),'bo')

% plot(rawdatatable(:,n+2), rawdatatable(:,n+1),'-r')
hold on
plot(dataSelect(:,nSelect+2), dataSelect(:,nSelect+1), '-r')

title({ExpDate; file; nSelect});
xlabel('Time (us)');
ylabel('current (A)');
hold off
else nSelect
end
end

%% various plots



if nFailure>0
FailureRate=nFailure./(nSelect+nFailure)
if val_PlotDataSelect == 1;
%hold on
% scatter (PeaksAmpFailure(1,:),PeaksAmpFailure(2,:), 'b')
%hold off
subplot (2,1,2);
plot(dataFailure(:,nFailure+2),dataFailure(:,1:nFailure), '-b')
title('dataFailure')
legend ('red: mean')
hold on
% plot(rawdatatable(:,n+2), rawdatatable(:,n+1),'-r')
% hold on
plot(dataFailure(:,nFailure+2), dataFailure(:,nFailure+1), '-r')
hold off
title({ExpDate;file; nFailure});
xlabel('Time (us)');
ylabel('current (A)');
end


%% Save workspace and important variables
ExpUnitName.(ExpDate).data.(file).DataFailure.dataFailure={dataFailure};
ExpUnitName.(ExpDate).data.(file).DataFailure.nFailure={nFailure};
ExpUnitName.(ExpDate).data.(file).DataFailure.sweepfailure={sweepfailure};
ExpUnitName.(ExpDate).data.(file).DataFailure.PeaksAmpFailure={PeaksAmpFailure};
ExpUnitName.(ExpDate).data.(file).DataFailure.PPRFailure={PPRFailure};
ExpUnitName.(ExpDate).data.(file).DataFailure.BaselinesTableFailure={BaselinesTableFailure};
ExpUnitName.(ExpDate).data.(file).DataFailure.ResistancesTableFailure={ResistancesTableFailure};
ExpUnitName.(ExpDate).data.(file).DataFailure.PeaksDelayFailure={PeaksDelayFailure};
ExpUnitName.(ExpDate).data.(file).DataFailure.ArtefactTimeFailure={ArtefactTimeFailure};
ExpUnitName.(ExpDate).data.(file).DataFailure.PeaksTimeFailure={PeaksTimeFailure};

% save ('DataFailure', 'dataFailure', 'nFailure', 'sweepfailure', 'PeaksAmpFailure', 'BaselinesTableFailure', 'ResistancesTableFailure', 'PeaksDelayFailure', 'PPRFailure', 'PeaksTimeFailure', 'ArtefactTimeFailure')

else 
FailureRate=0
end
%% PPR scatter
% if nSelect>0
% if val_PlotDataSelect == 1;
% figure
% scatter (PeaksAmpSelect(1,1:nSelect),PeaksAmpSelect(2,1:nSelect), 'k')
% title ('PPR')
% legend ('black: selected, blue: failure')
% hold on
% scatter (PeaksAmpSelect(1,nSelect+1),PeaksAmpSelect(2,nSelect+1), 'r')
% title({ExpDate;file});
% xlabel('Amplitude First peak (A)');
% ylabel('Amplitude Second peak (A)');
% end
% end

%% plot mean select trace

if nSelect>0

    if val_PlotDataSelect == 1;
figure 
plot (dataSelect(:,nSelect+2),dataSelect(:,nSelect+1), 'k')
hold on

scatter (dataSelect(TimePoints,nSelect+2), dataSelect(TimePoints,nSelect+1),'+c')

PLBase1=[(BaselinesTableSelect(1,nSelect+1)-BaselinesTableSelect(2,nSelect+1)) (BaselinesTableSelect(1,nSelect+1)-BaselinesTableSelect(2,nSelect+1)); (TimePoints(1, 1).*SamplingRate) (TimePoints(2, 1)*SamplingRate)];
plot(PLBase1(2,:),PLBase1(1,:), 'b');

PLBase2=[(BaselinesTableSelect(2,nSelect+1)-BaselinesTableSelect(2,nSelect+1)) (BaselinesTableSelect(2,nSelect+1)-BaselinesTableSelect(2,nSelect+1)); (TimePoints(1, 1).*SamplingRate) (TimePoints(20, 1)*SamplingRate)];
plot(PLBase2(2,:),PLBase2(1,:), 'y--');
%PLBase2=[(BaselinesTableSelect(2,nSelect+1)-BaselinesTableSelect(2,nSelect
%+1)) (BaselinesTableSelect(2,nSelect+1)-BaselinesTableSelect(2,nSelect+1)); (TimePoints(7, 1).*SamplingRate) (TimePoints(8, 1)*SamplingRate)];
%plot(PLBase2(2,:),PLBase2(1,:), 'b')

PLBase3=[(BaselinesTableSelect(3,nSelect+1)-BaselinesTableSelect(2,nSelect+1)) (BaselinesTableSelect(3,nSelect+1)-BaselinesTableSelect(2,nSelect+1)); (TimePoints(9, 1).*SamplingRate) (TimePoints(10, 1)*SamplingRate)];
plot(PLBase3(2,:),PLBase3(1,:), 'b');

PLBase4=[(BaselinesTableSelect(4,nSelect+1)-BaselinesTableSelect(2,nSelect+1)) (BaselinesTableSelect(4,nSelect+1)-BaselinesTableSelect(2,nSelect+1)); (TimePoints(14, 1).*SamplingRate) (TimePoints(15, 1)*SamplingRate)];
plot(PLBase4(2,:),PLBase4(1,:), 'b');

PLBase5=[(BaselinesTableSelect(5,nSelect+1)-BaselinesTableSelect(2,nSelect+1)) (BaselinesTableSelect(5,nSelect+1)-BaselinesTableSelect(2,nSelect+1)); (TimePoints(14, 1).*SamplingRate) (TimePoints(15, 1)*SamplingRate)];
plot(PLBase4(2,:),PLBase4(1,:), 'b');

plot (HWt(1,1:2),HWi(1,1:2), 'r')
plot (HWt(2,1:2),HWi(2,1:2), 'r')
scatter(RTt(1,1:2),RTi(1,1:2), 'go')
scatter(RTt(2,1:2),RTi(2,1:2), 'go')

plot (PeaksTimeSelect(1,nSelect+1),PeaksAmpSelect(1,nSelect+1),'bo')
errorbar(PeaksTimeSelect(1,nSelect+1),PeaksAmpSelect(1,nSelect+1),PeaksAmpSelect(1,nSelect+4),'b')
plot (PeaksTimeSelect(2,nSelect+1),PeaksAmpSelect(2,nSelect+1),'bo')
errorbar(PeaksTimeSelect(2,nSelect+1),PeaksAmpSelect(2,nSelect+1),PeaksAmpSelect(2,nSelect+4),'b')

hold on, plot(x1,f1,'--r','linewidth',2);
hold on, plot(x2,f2,'--r','linewidth',2);
% hold on, plot(x3,f3,'--r','linewidth',2);

%hold on, plot(x3,f3ab,'--b','linewidth',2);
%hold on, plot(x3,f3cd,'--g','linewidth',2);

title({ExpDate;file; nSelect});
xlabel('Time (us)');
ylabel('current (A)');
    end
%% save data analysed Gaba stim unit
ExpUnitName.(ExpDate).data.(file).DataSelect.dataSelect={dataSelect};
ExpUnitName.(ExpDate).data.(file).DataSelect.nSelect={nSelect};
ExpUnitName.(ExpDate).data.(file).DataSelect.sweepselect={sweepselect};
ExpUnitName.(ExpDate).data.(file).DataSelect.PeaksAmpSelect={PeaksAmpSelect};
ExpUnitName.(ExpDate).data.(file).DataSelect.PPRselect={PPRselect};
ExpUnitName.(ExpDate).data.(file).DataSelect.BaselinesTableSelect={BaselinesTableSelect};
ExpUnitName.(ExpDate).data.(file).DataSelect.ResistancesTableSelect={ResistancesTableSelect};
ExpUnitName.(ExpDate).data.(file).DataSelect.PeaksDelaySelect={PeaksDelaySelect};
ExpUnitName.(ExpDate).data.(file).DataSelect.RiseTimeTable={RiseTimeTable};
ExpUnitName.(ExpDate).data.(file).DataSelect.ArtefactTimeSelect={ArtefactTimeSelect};
ExpUnitName.(ExpDate).data.(file).DataSelect.PeaksTimeSelect={PeaksTimeSelect};
ExpUnitName.(ExpDate).data.(file).DataSelect.HalfWidthTableSelect={HalfWidthTableSelect};
ExpUnitName.(ExpDate).data.(file).DataSelect.FitDecayTimeTableSelect={FitDecayTimeTableSelect};
% ExpUnitName.(ExpDate).data.(file).DataSelect.CapacitanceMeanSelect={CapacitanceMeanSelect};
% ExpUnitName.(ExpDate).data.(file).DataSelect.FitCapacitanceMeanSelect={FitCapacitanceMeanSelect};
end;
ExpUnitName.(ExpDate).data.(file).DataSelect.FailureRate={FailureRate}


if val_SaveDataSelect == 1;
save (ExpDate, 'ExpUnitName')
end


display ('done')

%% old codes



%% Variables to save

%% dataselect
%'dataSelect', 'nSelect', 'sweepselect',
%'BaselinesTableSelect', 'ResistancesTableSelect'
%'PeaksAmpSelect', 'PPRselect'
%'PeaksDelaySelect', 'RiseTimeTable'
%'PeaksTimeSelect',%'ArtefactTimeSelect'


%% Mean table
%MeanUnitTable(1,:)= PeaksAmpSelect1, PeaksAmpSelect2, PPRselect, 






%%%%%%%% OLD CODES
%BaselinesTableSelect = [mean(dataSelect (TimePoints (1, 1):TimePoints (2,
%1), 1:nSelect+1)); mean(dataSelect (TimePoints (7, 1):TimePoints (8, 1), 1:nSelect+1));mean(dataSelect (TimePoints (9, 1):TimePoints (10, 1), 1:nSelect+1));mean(dataSelect (TimePoints (14, 1):TimePoints (15, 1), 1:nSelect+1)); mean(dataSelect (TimePoints (19, 1):TimePoints (20, 1), 1:nSelect+1))];


% samptime=input('sampling time in microseconde?');
% samptime=samptime*0.000001;
% [m,n] =size (idata);
%  
% % timescale = zeros(m,1);
% % t=0;
%  
% timescale=tdata;
% for i=2:m
% % timescale (i,1)=samptime+t;
% t=t+samptime;
% end
 
% datanalysed=idata;
% datanalysed (:, n+1) = mean (datanalysed(:, 1:n), 2);
% datanalysed (:, n+2) = timescale;


% expt = '2008-07-03_data_GBST_1-18'
% sweepnumber= 30
% load_Data_it_ASCII(expt, sweepnumber);

% %%%%%%%%
% 
% %pretest baseline
% TimePoints (1, 1)= 1;
% TimePoints (2, 1)= 290;
%  
% %Rs_1
% TimePoints (3, 1)= 300;
% TimePoints (4, 1)= 370;
%  
% %Rs_2
% TimePoints (5, 1)= 398;
% TimePoints (6, 1)= 529;
%  
% %Baseline
% TimePoints (7, 1)= 700;
% TimePoints (8, 1)= 2950;
%  
% %Baseline prestim_1
% TimePoints (9, 1)= 2700;
% TimePoints (10, 1)= 2990;
%  
% %Artefact_1
% TimePoints (11, 1)= 3000;
% TimePoints (12, 1)= 3032;
% %Peak_1
% TimePoints (13, 1)= 5000;
%  
% %Baseline prestim_2
% TimePoints (14, 1)= 5700;
% TimePoints (15, 1)= 5990;
%  
% %Artefact_2
% TimePoints (16, 1)= 6000;
% TimePoints (17, 1)= 6032;
% %Peak_2
% TimePoints (18, 1)= 8000;
%  
% %Baseline PostStim
% TimePoints (19, 1)= 8110;
% TimePoints (20, 1)= 8399;
% time(1,1)=0;
% time(2,1)= a-0.0005;
% time(3,1)= a-(b./2);
% time(4,1)= a+(b./2);
% time(5,1)= a+b-(b./2);
% time(6,1)= a+b+(b./2);
% time(7,1)= a+b+0.010;
% time(8,1)= a+b+c-0.010;
% time(9,1)= a+b+c-0.011;
% time(10,1)= a+b+c-0.001;
% time(11,1)= a+b+c;
% time(12,1)= a+b+c+ard;
% time(13,1)= a+b+c+0.050;
% time(14,1)= a+b+c+d+atd-0.011;
% time(15,1)= a+b+c+d+atd-0.001;
% time(16,1)= a+b+c+d;
% time(17,1)= a+b+c+d+ard;
% time(18,1)= a+b+c+d+atd+0.050;
% time(19,1)= a+b+c+d+atd+atd+e-0.011;
% time(20,1)= a+b+c+d+atd+atd+e-0.001
% save ('DataSelect', 'dataSelect', 'nSelect', 'sweepselect', 'PeaksAmpSelect', 'BaselinesTableSelect', 'ResistancesTableSelect', 'PeaksDelaySelect', 'RiseTimeTable','PPRselect', 'PeaksTimeSelect', 'ArtefactTimeSelect')
% save ('DataRaw', 'dataRaw', 'nRaw', 'PeaksAmp', 'BaselinesTable',
% 'ResistancesTable', 'PeaksDelay', 'PPR', 'PeaksTime', 'ArtefactTime')
% load DataFailure
% load DataSelect
% load DataRaw