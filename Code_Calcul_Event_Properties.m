%
function rep = Code_Calcul_Event_Properties( file_name, data, sweepSize, nbSweeps, sweepsToKeep, samplingRate, nbStims, stim, stimsToAnalyse, begin_spike_smooth, smoothing_time, analysisTimeWindow, toDo, riseAndDecayThresholds )

doPlotData = toDo(1);
doPlotMean = toDo(2);
doPlotIntegrals = toDo(3);
doPeaks = toDo(4);
doIntegrals = toDo(5);
doPPR = toDo(6);    % 0 = no ; 1 = stim2/stim1 ; 2 = stim3/stim2
doRTime = toDo(7);
doDTime = toDo(8);
doTPulse = toDo(9);
saveAllSweeps = toDo(10);
saveMean = toDo(11);
invertResults = toDo(12);

% invertResults : do we have negative respones ? if so, we deal with them
% by multiplying by -1, to have positive results (otherwise, looking for
% maxima and other stuff won't do)
if invertResults
        data(:,1:nbSweeps+1) = -1*data(:,1:nbSweeps+1);
end

% Just an utility
function boolean = isBetweenO1( value )
    boolean = value <= 1 && value >= 0;
end

% Percentage windows for rise and decay time (10%-90% and 63%-100%, for example)
if ~isBetweenO1( riseAndDecayThresholds(1) )
    display( 'Invalid parameter : setting threshold 1 for rise time to 20%' );
    riseAndDecayThresholds(1) = 0.20;   % default value
end
if ~isBetweenO1( riseAndDecayThresholds(2) )
    display( 'Invalid parameter : setting threshold 2 for rise time to 80%' );
    riseAndDecayThresholds(2) = 0.80;   % default value
end
if riseAndDecayThresholds(2)  < riseAndDecayThresholds(1)
    display( 'Invalid parameters : resetting thresholds for rise time to 20% and 80%' );
    riseAndDecayThresholds(1) = 0.20;   % default value
    riseAndDecayThresholds(2) = 0.80;   % default value
end
if ~isBetweenO1( riseAndDecayThresholds(3) )
    display( 'Invalid parameter : setting threshold 1 for decay time to 63%' );
    riseAndDecayThresholds(3) = 0.63;   % default value
end
if ~isBetweenO1( riseAndDecayThresholds(4) )
    display( 'Invalid parameter : setting threshold 2 for decay time to 100%' );
    riseAndDecayThresholds(4) = 0.100;   % default value
end
if riseAndDecayThresholds(4)  < riseAndDecayThresholds(3)
    display( 'Invalid parameters : resetting thresholds for decay time to 63% and 100%' );
    riseAndDecayThresholds(3) = 0.63;   % default value
    riseAndDecayThresholds(4) = 0.100;   % default value
end

% For peak detection
begin_spike_smooth(1) = int32(begin_spike_smooth(1) / samplingRate ) ; % en nb de pts
deltaXForPeak = begin_spike_smooth(1); 
deltaYForPeak = begin_spike_smooth(2); 

% If it's in the wrong order, swap the begin and the end
if analysisTimeWindow(2) < analysisTimeWindow(1)
    tmp = analysisTimeWindow(2);
    analysisTimeWindow(2) = analysisTimeWindow(1);
    analysisTimeWindow(1) = tmp;
end

% Convert it to milliseconds
analysisTimeWindow = int32( analysisTimeWindow/samplingRate );
integralXDuration = analysisTimeWindow(2)-analysisTimeWindow(1);

nbSweeps_total = nbSweeps; % for the test pulse, below

smoothingX_1 = ( smoothing_time(1,1) / samplingRate ) + 1 ;
smoothingX_2 = ( smoothing_time(1,2) / samplingRate ) + 1 ;

%%%%%%%%%%%%%%%%%%%%%%% GLOBAL INFO FOR EACH STIM %%%%%%%%%%%%%%%%%%%%%%%%%

[indexBeginStims, indexEffectiveBeginStims, indexEndStims, indexBeginArtifact, indexEndArtifact, indexEndAnswers] = getStimsUsefulPoints( sweepSize, stim, samplingRate );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DATA SMOOTHING %%%%%%%%%%%%%%%%%%%%%%%%%
 
smoothedData = smoothData( sweepSize, data, smoothingX_1, smoothingX_2, indexBeginStims, indexEffectiveBeginStims, indexEndStims, indexEndArtifact );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WORKING DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%
% The smoothed data, but recentered on 0 (data - mean(data))
for i=1:nbSweeps+1
    smoothedData( :, i ) = smoothedData( :, i ) - mean( smoothedData( :, i ) );
    data( :, i ) = data( :, i ) - mean( data( :, i ) );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PEAK DETECTION %%%%%%%%%%%%%%%%%%%%%%%
% Exclude the artifact from the peak detection
intervalsToConsiderForMax = zeros( nbStims, 4 );
for k=stimsToAnalyse
    intervalsToConsiderForMax(k,:) = [indexBeginStims(k) indexBeginArtifact(k) indexEndArtifact(k) indexEndAnswers(k)];
end
% peaksTable{ k, i, 1 } = times of the max of detected peaks ([ ] if no detected peak) for the k-th stim of the i-th sweep
% peaksTable{ k, i, 2 } = indexes of the max of detected peaks ([ ] if no % detected peak) for the k-th stim of the i-th sweep
% peaksTable{ k, i, 3 } = maxima of detected peaks ([ ] if no detected peak) for the k-th stim of the i-th sweep
% And filled a little below :
%       peaksTable{ k, i, 4 } : TTP
%       peaksTable{ k, i, 5 } : RiseTime
%       peaksTable{ k, i, 6 } : DecayTime
%       peaksTable{ k, i, 7 } : Amplitude
peaksTable = detectPeaks( smoothedData, nbStims, nbSweeps, intervalsToConsiderForMax, deltaXForPeak, deltaYForPeak, true ); % Last argument overrides the delta*ForPeak and allows to detecte the max peak as a peak
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Peak time window exclusion %%%%%%%%%%%%%%%%%
for k=1:nbStims
        indexBegin = indexBeginStims(k) + analysisTimeWindow(1);
        indexEnd = indexBeginStims(k) + analysisTimeWindow(2);
        
        for i=1:nbSweeps+1  % Also the mean
            % Only keep peaks between the two specified dates
            peakList = zeros( 3, numel(peaksTable{k,i,1}) );
            if numel(peaksTable{k,i,1}) > 0
                peakList(1,:) = peaksTable{k,i,1}';
                peakList(2,:) = peaksTable{k,i,2}';
                peakList(3,:) = peaksTable{k,i,3}';
            end

            [times, indexes, maxs] = getPeaksInTimeWindow( peakList, indexBegin, indexEnd );
            % Only keep those peaks
            peaksTable{k,i,1} = times;
            peaksTable{k,i,2} = indexes;
            peaksTable{k,i,3} = maxs;
        end
end
%%%%%%%%%%%%%%%%%%%%%%%%% END Peak time exclusion %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now, the same thing, but for the HIGHEST peak of each stim, amongst the remaining peaks, only
%       peaksMaxTable{ k, i, 1 } : time of the maximum peak, for the sweep i, and stim k
%       peaksMaxTable{ k, i, 2 } : index of the maximum peak
%       peaksMaxTable{ k, i, 3 } : value of the maximum
peaksMaxTable = detectMaxOfPeaks( peaksTable );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Time to Peak %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Rise Times, decay times and amplitudes %%%%%%%%%%%%%%%
%               peaksTable{ k, i, 4 } ... peaksTable{ k, i, 7 }           %
% default values are -1
ttpTable = -1*ones( nbSweeps+1, nbStims ) ;
riseTimeTable = -1*ones( nbSweeps+1, nbStims ) ;
decayTimeTable = -1*ones( nbSweeps+1, nbStims ) ;
amplitudeTable = -1*ones( nbSweeps+1, nbStims ) ;
%for k=1:nbStims
for k=stimsToAnalyse
    for i=1:nbSweeps+1
        
        % For the main (i.e, MAX) peak
        if isempty( peaksTable{ k, i, 2 } )
            ttpTable( i, k ) = -1; % No peak was detected
            riseTimeTable(i,k) = -1;
            amplitudeTable(i,k) = -1;
            decayTimeTable(i,k) = -1;
        else
            ttpTable( i, k ) = peaksMaxTable{ k, i, 2 } - indexBeginStims(k);
            ttpTable( i, k ) = ttpTable( i, k )*samplingRate;
            
            baseLineMeanSmoothed = mean( smoothedData(indexBeginStims(k)-int32(50/samplingRate):indexBeginStims(k),i) ) ;
            % Since amplitude is given by getRiseTime, with have to compute
            % rise time even if it's not asked
            if doRTime || doPeaks
                [unused1, unused2, riseTimeTable(i,k), amplitudeTable(i,k)] = getRiseTime( smoothedData, i, baseLineMeanSmoothed, indexEffectiveBeginStims(k), ...
                                                                                   peaksMaxTable{k, i, 2}, riseAndDecayThresholds(1), ...
                                                                                   riseAndDecayThresholds(2), samplingRate );
            end
            if doDTime
                [unused1, unused2, decayTimeTable(i,k), unused3] = getDecayTime( smoothedData, i, baseLineMeanSmoothed, peaksMaxTable{k, i, 2}, ...
                                                                   indexEndAnswers(k), riseAndDecayThresholds(3), ...
                                                                   riseAndDecayThresholds(4), samplingRate );
            end
            % but if not asked (rise time irrelevant ?), we delete the
            % information afterwards. 0 means not asked, -1 means no peak
            % detected
            riseTimeTable(i,k) = doRTime*riseTimeTable(i,k);
            amplitudeTable(i,k) = doPeaks*amplitudeTable(i,k);
            decayTimeTable(i,k) = doDTime*decayTimeTable(i,k);
        end
        
        % For all peaks, in peaksTable (in a 4th row)
        nbPeaks = numel( peaksTable{ k, i, 1 } );
        peaksTable{ k, i, 4 } = zeros( 1, nbPeaks );    % TTP
        peaksTable{ k, i, 5 } = zeros( 1, nbPeaks );    % RiseTime
        peaksTable{ k, i, 6 } = zeros( 1, nbPeaks );    % DecayTime
        peaksTable{ k, i, 7 } = zeros( 1, nbPeaks );    % Amplitude
        dt = 0; rt = 0; amplitude = 0;
        for j=1:nbPeaks
            if doRTime || doPeaks
                [unused1, unused2, rt, amplitude] = getRiseTime( smoothedData, i, baseLineMeanSmoothed, indexEffectiveBeginStims(k), ...
                                                                                   peaksTable{ k, i, 2 }(j), riseAndDecayThresholds(1), ...
                                                                                   riseAndDecayThresholds(2), samplingRate );
            end
            if doDTime
                [unused1, unused2, dt, unused3] = getDecayTime( smoothedData, i, baseLineMeanSmoothed, peaksTable{ k, i, 2 }(j), ...
                                                                   indexEndAnswers(k), riseAndDecayThresholds(3), ...
                                                                   riseAndDecayThresholds(4), samplingRate );
            end
                                                               
            peaksTable{ k, i, 4 }(j) = samplingRate * ( peaksTable{ k, i, 2 }(j) - indexBeginStims(k) );
            peaksTable{ k, i, 5 }(j) = rt * doRTime;
            peaksTable{ k, i, 6 }(j) = dt;
            peaksTable{ k, i, 7 }(j) = amplitude * doPeaks;
        end
        
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BASELINES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
durConsideredBeforeStimForBL = 5;
baseline_table = cell(1,nbStims) ;
for k=stimsToAnalyse
    baseline_table{k} = zeros(nbSweeps,1) ;
    for i=1:nbSweeps
        baseline_table{k}(i,1) = mean(smoothedData(indexBeginStims(k)-int32(durConsideredBeforeStimForBL/samplingRate):indexBeginStims(k),i),1) ;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Max amplitudes   %%%%%%%%%%%%%%%%%%%%%%%%%
maxAmplitudeTable = zeros(nbSweeps,nbStims) ;
for i=1:nbSweeps
    for k=stimsToAnalyse
        if peaksMaxTable{k,i,1} > 0
            maxAmplitudeTable(i,k) = peaksMaxTable{k,i,3} - baseline_table{k}(i,1);
        else
            maxA = (max( smoothedData( (indexBeginStims(k) + analysisTimeWindow(1)):indexBeginArtifact(k),i) )) ;% en pA
            maxB = (max( smoothedData(indexEndArtifact(k):(indexBeginStims(k) + analysisTimeWindow(2)),i) )) ;% en pA
               if isempty( [maxA maxB] )
                   display( 'Error : time window for analysis is in the artifact window' );
                   rep = [];
                   return;
               end
            maxAmplitudeTable(i,k) = max( [maxA maxB] ) - baseline_table{k}(i,1);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Integrals   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
integralTable = zeros(nbSweeps,nbStims) ;
if doIntegrals
    display('-- Beginning integral calculations...') ;

    for i=1:nbSweeps

        for k=stimsToAnalyse

            % baseline de reference
            baseline_area = double( baseline_table{k}(i,1) * (integralXDuration*samplingRate - stim(k,3)) );
            baseline = baseline_table{k}(i,1);

            x0 = (indexBeginStims(k) + analysisTimeWindow(1));
            x1 = indexBeginArtifact(k);
            x2 = indexEndArtifact(k);
            x3 = (indexBeginStims(k) + analysisTimeWindow(2));
            integralTable(i,k) = ( trapz( smoothedData(x0:x1, nbSweeps+2), smoothedData(x0:x1, i ) ) ...
                + trapz( smoothedData(x2:x3, nbSweeps+2), smoothedData(x2:x3, i ) ) ...
                - baseline_area ) * 1e-3 ;% en pA.s = pC

            % maxA is the max peak amplitude in the first window to analyse before the second artefact, maxB in the window after the second artefact
%             maxA = (max( smoothedData(indexEffectiveBeginStims(k):indexBeginArtifact(k),i) )- baseline) ;% en pA
%             maxB = (max( smoothedData(indexEndArtifact(k):indexEffectiveBeginStims(k) + integralXDuration,i) ) - baseline) ;% en pA
%             maxAmplitudeTable(i,k) = max( [maxA maxB] );
        end
    end

    display('Integrals calculation done') ;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Per-Pulse Ratio   %%%%%%%%%%%%%%%%%%%%%%%%%%
doPPR = toDo(6);
pprTable = zeros( nbSweeps );
switch doPPR
    case 1  % stim2/stim1
        for i=1:nbSweeps
            if peaksMaxTable{1,i,1} > 0 && peaksMaxTable{2,i,1} > 0
                if peaksMaxTable{1,i,3} ~= 0
                    pprTable(i) = peaksMaxTable{2,i,3} / peaksMaxTable{1,i,3};
                else
                    pprTable(i) = sign( peaksMaxTable{2,i,3} ) * inf;
                end
            else
                pprTable(i) = -1; % Not detected
            end
        end
    case 2  % stim3/stim2
        for i=1:nbSweeps
            if peaksMaxTable{3,i,1} > 0 && peaksMaxTable{2,i,1} > 0
                if peaksMaxTable{2,i,3} ~= 0
                    pprTable(i) = peaksMaxTable{3,i,3} / peaksMaxTable{2,i,3};
                else
                    pprTable(i) = sign( peaksMaxTable{3,i,3} ) * inf;
                end
            else
                pprTable(i) = -1; % Not detected
            end
        end
    otherwise
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%  ############################################################### PLOT ###
doPlot = doPlotData || doPlotMean || doPlotIntegrals;

if doPlot == 1
    display('-- plotting...') ;
    h = zeros( 1, 2 ); % handles, for plots (used for legends)
    
    % Integral : time window
    yTimeWindowIntegral = cell( 1, nbStims );
    x1TimeWindowIntegral = cell( 1, nbStims );
    x2TimeWindowIntegral = cell( 1, nbStims );
    for k=stimsToAnalyse
        meanBLk = int32(mean(baseline_table{k}));
        maxAmplk = int32(max(maxAmplitudeTable(:,k)));
        yTimeWindowIntegral{k} = meanBLk:( maxAmplk + meanBLk );
        x1TimeWindowIntegral{k} = smoothedData((indexBeginStims(k) + analysisTimeWindow(1)),nbSweeps+2) * ones( 1, maxAmplk+1 );
        x2TimeWindowIntegral{k} = smoothedData((indexBeginStims(k) + analysisTimeWindow(2)), nbSweeps+2 ) * ones( 1, maxAmplk+1 );
    end

    if doPlotData
        % First graph : the sweeps;
        figure
        title( sprintf( '%s : sweeps', file_name ), 'Interpreter','none');  % to avoid '_' interpreted as subscript command
        ylabel('I [pA]') ;
        xlabel('t [ms]') ;

        for i=1:nbSweeps
            hold on, plot(smoothedData(:, nbSweeps+2), smoothedData(:, i),'k', 'DisplayName', sprintf('Sweep %d', sweepsToKeep(i)) );
            % Plot 'main maxima'
            for k=stimsToAnalyse
                if peaksMaxTable{k,i,1} > 0
                    % to determine the time, use the index and the 'time
                    % sweep' : just using peaksMaxTable{k,i,1}  and
                    % mutliplying it by samplingRate is not accurate enough
                    x = smoothedData( peaksMaxTable{k,i,2}, nbSweeps+2 );
                    plot( x, peaksMaxTable{k,i,3},'k', 'DisplayName', sprintf('Max for sweep %d, stim %d', sweepsToKeep(i), k), 'Marker', 'o' );
                end
            end
        end
        hold on, h(1) = plot(smoothedData(:, nbSweeps+2), smoothedData(:, nbSweeps+1),'r', 'DisplayName', 'Mean sweep' );

        %plot green bar representing the time window of the integral
        for k=stimsToAnalyse
            hold on, h(2) = plot( x1TimeWindowIntegral{k}, yTimeWindowIntegral{k},'g');
            hold on, plot( x2TimeWindowIntegral{k}, yTimeWindowIntegral{k},'g');
        end
        legend( h, 'Mean sweep', 'Time window for integral' );
    end

    if doPlotMean
        % Second graph : the mean sweeps (raw and smoothed)
        handleSummaryGraph = figure;
        title( sprintf( '%s : mean sweep', file_name ), 'Interpreter','none');
        hold on, plot(smoothedData(:, nbSweeps+2), data(:, nbSweeps+1),'k');
        hold on, plot(smoothedData(:, nbSweeps+2), smoothedData(:, nbSweeps+1),'r');
        legend( 'Mean sweep', 'Mean sweep (smoothed)' );

        colorsPoints = {'g', 'b', 'm', 'r' };
        for k=stimsToAnalyse
            if numel( peaksTable{k, nbSweeps+1, 2} ) > 0  % Only if a peak was detected for this stim on the mean
                baseLineMeanSmoothed = mean( smoothedData(indexBeginStims(k)-int32(50/samplingRate):indexBeginStims(k),nbSweeps+1) ) ;
                [m, indexMaxPeak] = max( peaksTable{k, nbSweeps+1, 3} );
                
                % Plot 'main maxima'
                if peaksMaxTable{k,nbSweeps+1,1} > 0
                    % to determine the time, use the index and the 'time
                    % sweep' : just using peaksMaxTable{k,i,1}  and
                    % mutliplying it by samplingRate is not accurate enough
                    x = smoothedData( peaksMaxTable{k,nbSweeps+1,2}, nbSweeps+2 );
                    plot( x, peaksMaxTable{k,nbSweeps+1,3},'k', 'DisplayName', sprintf('Max for mean sweep, stim %d', k), 'Marker', 'o' );
                end
                
                if doRTime
                    % Rise Time
                    [iStart, iEnd, a, b] = getRiseTime( ...
                                smoothedData, nbSweeps+1, baseLineMeanSmoothed, indexEffectiveBeginStims(k), ...
                                peaksTable{k, nbSweeps+1, 2}(indexMaxPeak), riseAndDecayThresholds(1), ...
                                riseAndDecayThresholds(2), samplingRate ...
                        );
                    if iStart > 0 && iEnd < size(data, 1)
                        indexColor = mod(k,4) + 1;
                        hold on, plot (smoothedData(iStart, nbSweeps+2), smoothedData(iStart, nbSweeps+1), colorsPoints{indexColor}, 'Marker', 'o');
                        hold on, plot (smoothedData(iEnd, nbSweeps+2), smoothedData(iEnd, nbSweeps+1), colorsPoints{indexColor}, 'Marker', 'o');
                    end
                end

                if doDTime
                % Decay Time
                    [iStart, iEnd, a, b] = getDecayTime( ...
                            smoothedData, nbSweeps+1, baseLineMeanSmoothed, peaksTable{k, nbSweeps+1, 2}(indexMaxPeak), ...
                            indexEndAnswers(k), riseAndDecayThresholds(3), ...
                            riseAndDecayThresholds(4), samplingRate ...
                        );
                    if iStart > 0 && iEnd < size(data, 1)
                        indexColor = mod(k,4) + 1;
                        hold on, plot (smoothedData(iStart, nbSweeps+2), smoothedData(iStart, nbSweeps+1), colorsPoints{indexColor}, 'Marker', 'x');
                        hold on, plot (smoothedData(iEnd, nbSweeps+2), smoothedData(iEnd, nbSweeps+1), colorsPoints{indexColor}, 'Marker', 'x');
                    end
                end
            end
        end
    end
    
    % Third graph : the integrals for the mean
    if doPlotIntegrals
        figure
        title( sprintf( '%s : integrals (mean sweep)', file_name ), 'Interpreter','none');
        ylabel('I [pA]') ;
        xlabel('t [ms]') ;

        baseline_mean_smoothed_data = mean( smoothedData(indexBeginStims(1)-int32(50/samplingRate):indexBeginStims(1),nbSweeps+1) ) ;
        smoothedData_mean = smoothedData(:, nbSweeps+1) -  baseline_mean_smoothed_data;

        hold on, h(1) = plot (smoothedData(:, nbSweeps+2), smoothedData_mean,'r');
        hold on, area (smoothedData(:, nbSweeps+2),smoothedData_mean );

        %plot green bar representing the time window of the integral
        for k=stimsToAnalyse
            hold on, h(2) = plot( x1TimeWindowIntegral{k}, yTimeWindowIntegral{k},'g');
            hold on, plot( x2TimeWindowIntegral{k}, yTimeWindowIntegral{k},'g');
        end
        legend( h, 'Mean sweep', 'Time window for integral' );
    end
    
    
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
end
if ~doPlotMean
    % Create a new handle (for TPulse)
    handleSummaryGraph = 0;
    while ishghandle(handleSummaryGraph)
        handleSummaryGraph = handleSummaryGraph + 1;
    end
end


%  ########################################################### END PLOT ###

%  ############################################################### TPUlse ###

if doTPulse == 1
    display('-- analyzing testpulse ...' );
    %
    options_tpulse(1) = 1;      % fit_TP_check
    options_tpulse(2) = doPlot; % plot_check
    options_tpulse(3) = 1;      % save_check
    
    U_pulse_value = 5;          % Volt
    samplingRate = 0.05;       % Milliseconds
    
    TP_1 = 20;                  % pre-testpulse (ms)
    TP_2 = 30;                  % Duration fit
    TP_3 = TP_1 + 0.99*TP_2;    % duration testpulse
    TP_2 = 0.8*TP_2 + TP_1;
    
    time_points = [TP_1; TP_2; TP_3];
    % 1ere colonne de time_points = temps en ms
    % 2eme colonne de time_points = # de la ligne  correspondant au temps dans
    % le tableau des donnees reorganisee

    data_to_save = cell(1, 5);
    % if we need to revert the results in order for ChR to work (some of the experiment have inverted results, du to the
    % diff of potential)
    if invertResults
        data(:,1:nbSweeps+1) = -1*data(:,1:nbSweeps+1);
    end
    testPulseResults = test_pulse_analysis( file_name, data, data_to_save, time_points, samplingRate, U_pulse_value, nbSweeps, options_tpulse, 0, handleSummaryGraph );
    testPulseTime = cell(nbSweeps+1,5);
    for i = 4:(nbSweeps+1)
        testPulseTime(i,:) = test_pulse_analysis(file_name, data, data_to_save, time_points, samplingRate, U_pulse_value, (i-3:i), options_tpulse, 0, handleSummaryGraph );
    end
else
    testPulseResults = cell(1,5);
end

%%%%%%%%%%% plot test-pulse over time from sweeps data in workspace %%%%%%%
figure
mean_cap = mean(cell2mat(testPulseTime(:,2)),1);
mean_rm = mean(cell2mat(testPulseTime(:,4)),1);
mean_ra = mean(cell2mat(testPulseTime(:,5)),1);
plot(cell2mat(testPulseTime(:,2))./mean_cap,'r');hold on;
plot(cell2mat(testPulseTime(:,4))./mean_rm,'b');hold on;
plot(cell2mat(testPulseTime(:,5))./mean_ra,'k');
xlabel('Sweeps');ylabel('%change');
legend(['Mean membrane capacitance = ',num2str(mean_cap),' (pF)'],...
    ['Mean membrane resistance = ',num2str(mean_rm),' (MOhm)'],...
    ['Mean access resistance = ',num2str(mean_ra),' (MOhm)']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%############################################################### ENDTpulse

nbBeforeStimsCols = 6+4*nbStims;
% ################################################################ SAVE ###
[pathstr, name, ext, versn] = fileparts(file_name);
name = strcat(name, ext);
resultdata = cell( nbSweeps+1, 2*nbStims+nbBeforeStimsCols+1 );
if saveAllSweeps
    %%%% save integrals
    for i=1:nbSweeps
        resultdata{i,1} = name ;
         resultdata{i,2} = sweepsToKeep(i) ; % the real sweep number
%         resultdata{i,3} = testPulseResults{2} ; % capa
%         resultdata{i,4} = testPulseResults{3} ; % R^2 meanfit
%         resultdata{i,5} = testPulseResults{4} ; % Rm
%         resultdata{i,6} = testPulseResults{5} ; % Ra
         resultdata{i,3} = testPulseTime{i,2} ; % capa
         resultdata{i,4} = testPulseTime{i,3} ; % R^2 meanfit
         resultdata{i,5} = testPulseTime{i,4} ; % Rm
         resultdata{i,6} = testPulseTime{i,5} ; % Ra
        for k=1:nbStims
            resultdata{i,6+k} = ttpTable(i,k); % Time-to-peak for the k-th stim
            resultdata{i,6+nbStims+k} = riseTimeTable(i,k); % rise time for the k-th stim
            resultdata{i,6+2*nbStims+k} = decayTimeTable(i,k); % decay time for the k-th stim
            resultdata{i,6+3*nbStims+k} = amplitudeTable(i,k); % amplitude of the peak for the k-th stim
        end
        resultdata(i,nbBeforeStimsCols+1:nbStims+nbBeforeStimsCols) = num2cell( integralTable(i,:) ) ;    
        %%%% save max amplitude peaks    
        resultdata(i,nbBeforeStimsCols+1+nbStims:2*nbStims+nbBeforeStimsCols) = num2cell( maxAmplitudeTable(i,:) ) ;
        %%% Save PPR
        resultdata(i,2*nbStims+nbBeforeStimsCols+1) = num2cell( pprTable(i) );
    end
end
indexUsed = nbSweeps + 1;
if saveMean
    %%%% save means
    tpulse_table_mean = cellfun(@mean, testPulseResults); 
    integralTable_mean = mean(integralTable);
    resultdata{indexUsed,1} = name ;
    resultdata{indexUsed,2} = 'Mean' ;
    resultdata{indexUsed,3} = tpulse_table_mean(2) ; % capa
    resultdata{indexUsed,4} = tpulse_table_mean(3) ; % R^2 meanfit
    resultdata{indexUsed,5} = tpulse_table_mean(4) ; % Rm
    resultdata{indexUsed,6} = tpulse_table_mean(5) ; % Ra
    for k=1:nbStims
            resultdata{indexUsed,6+k} = ttpTable(nbSweeps+1, k); % Mean time-to-peak for the k-th stim of the mean sweep (and _not_ the mean of all TTP for this stim)
            resultdata{indexUsed,6+nbStims+k} = riseTimeTable(nbSweeps+1,k); % rise time for the k-th stim
            resultdata{indexUsed,6+2*nbStims+k} = decayTimeTable(nbSweeps+1,k); % decay time for the k-th stim
            resultdata{indexUsed,6+3*nbStims+k} = amplitudeTable(nbSweeps+1,k); % amplitude of the peak for the k-th stim
    end
    resultdata(indexUsed,nbBeforeStimsCols+1:nbStims+nbBeforeStimsCols) = num2cell( integralTable_mean(1,:) ) ;
    %%%% save max amplitude peaks into data_to_save_mean
    maxAmplitudeTable_mean = mean(maxAmplitudeTable);    
    resultdata(indexUsed,nbBeforeStimsCols+1+nbStims:2*nbStims+nbBeforeStimsCols) = num2cell( maxAmplitudeTable_mean(1,:) ) ;
    %%% Save PPR
    resultdata(indexUsed,2*nbStims+nbBeforeStimsCols+1) = num2cell( mean( pprTable( find(pprTable(:) ~= -1) ) ) );
end

    rep = resultdata;


% ############################################################ END SAVE ###

% test_table
% select_2_sweep
% failure_list


display('done: Code_Calcul_Events_Properties') ;

end

% ############################################################ END CODE ###


