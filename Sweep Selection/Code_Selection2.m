%
function rep = Code_Selection2(file_name, ID, nbSweeps, sweepsToKeep, samplingRate, nbStims, stim, begin_spike_smooth, peakThreshold, timeToPeakExcls, baseLineExcls, riseTimeExcls, decayTimeExcls, riseAndDecayThresholds, allStimsMustPass, rawData, smoothing_time, toDo, data_to_save)

% Cette function sort en output la matrice criterionsTable
%%%% Definition criterionsTable%%%%%%%%
% test table : ligne i = pour le sweep i :
%       colonne #1 : sweep selectionne globalement (0/1) : est le produit
%       des colonnes suivantes, si elles sont utilisees pour la selection
%       colonne #2 : selection sur baseline pr stim 1 (0/1)
% Selection de colonne 1 depend de  l'entree exclusion criterion +- baseline dans fig
%       colonne #3 : selection sur spike pr stim 1 (0/1)
% Selection de colonne 2 depend de l'entree exclusion criterion standard deviation dans fig
%       colonne #2*nb_stim+2 : les peaks ont-ils ete detectes (critere
%       fondamental, toujours utilise)
%       ...
doRiseTimeExclusion = toDo(1);
doDecayTimeExclusion = toDo(7);
doBLExclusion = toDo(2);
doTTPExclusion = toDo(3); % Time-to-Peak
plotSelectData = toDo(4);
plotFailedData = toDo(5);
plotMaxima = toDo(6);
doSave = toDo(8);

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
begin_spike_smooth(1) = int32(begin_spike_smooth(1) / samplingRate ) ; % Point number
deltaXForPeak = begin_spike_smooth(1);
deltaYForPeak = begin_spike_smooth(2);

%%%%%%%%%%%%%%%%%%%%% ASCII raw Data file to Data matrix %%%%%%%%%%%%%%%%%%

[data, sweepSize, nbSweeps] = preteatRawData( rawData, nbSweeps, sweepsToKeep );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ################################################## Tri sur les sweeps ###

criterionsTable = zeros(nbSweeps, 4*nbStims+5) ;
criterionsTable(:,2*nbStims+2) = 1;   % by default, consider the peaks are detected : if we do not detect them, it will be set to 0


smoothingX_1 = ( smoothing_time(1,1) / samplingRate ) + 1 ;
smoothingX_2 = ( smoothing_time(1,2) / samplingRate ) + 1 ;

%%%%%%%%%%%%%%%%%%%%%%% GLOBAL INFO FOR EACH STIM %%%%%%%%%%%%%%%%%%%%%%%%%

[indexBeginStims, indexEffectiveBeginStims, indexEndStims, indexBeginArtifact, indexEndArtifact, indexEndAnswers] = getStimsUsefulPoints( sweepSize, stim, samplingRate );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DATA SMOOTHING %%%%%%%%%%%%%%%%%%%%%%%%%

smoothedData = smoothData( sweepSize, data, smoothingX_1, smoothingX_2, indexBeginStims, indexEffectiveBeginStims, indexEndStims, indexEndArtifact );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END SMOOTHING %%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WORKING DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%

% The smoothed data, but recentered on 0 (data - mean(data))
for i=1:nbSweeps+1
    smoothedData( :, i ) = smoothedData( :, i ) - mean( smoothedData( :, i ) );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PEAK DETECTION %%%%%%%%%%%%%%%%%%%%%%%
% Exclude the artifact from the peak detection
intervalsToConsiderForMax = zeros( nbStims, 4 );
for k = 1:nbStims
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
peaksTable = detectPeaks( smoothedData, nbStims, nbSweeps, intervalsToConsiderForMax, deltaXForPeak, deltaYForPeak );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Peak time window exclusion %%%%%%%%%%%%%%%%%
for k=1:nbStims
    % Do we use this criterion (time window for this peak ?)
    if timeToPeakExcls(k, 1) > 0
        indexBegin = timeToPeakExcls(k, 1) / samplingRate;
        indexEnd = timeToPeakExcls(k, 2) / samplingRate;
        
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
            % If there are such peaks, there the criterion is fulfilled
            if ~isempty(indexes)
                criterionsTable(i,2*k+1) = 1 ;
            end
        end
    else
        criterionsTable(:,2*k+1) = 1; % by default, if the criterion isn't used, it's OK
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
ttpTable = zeros( nbSweeps+1, nbStims ) ;
riseTimeTable = zeros( nbSweeps, nbStims ) ;
decayTimeTable = zeros( nbSweeps, nbStims ) ;
amplitudeTable = zeros( nbSweeps, nbStims ) ;
for k=1:nbStims
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
            [unused1, unused2, riseTimeTable(i,k), amplitudeTable(i,k)] = getRiseTime( smoothedData, i, baseLineMeanSmoothed, indexEffectiveBeginStims(k), ...
                                                                                   peaksMaxTable{k, i, 2}, riseAndDecayThresholds(1), ...
                                                                                   riseAndDecayThresholds(2), samplingRate );
            [unused1, unused2, decayTimeTable(i,k), unused3] = getDecayTime( smoothedData, i, baseLineMeanSmoothed, peaksMaxTable{k, i, 2}, ...
                                                                   indexEndAnswers(k), riseAndDecayThresholds(3), ...
                                                                   riseAndDecayThresholds(4), samplingRate );
        end
        
        % For all peaks, in peaksTable (in a 4th row)
        nbPeaks = numel( peaksTable{ k, i, 1 } );
        peaksTable{ k, i, 4 } = zeros( 1, nbPeaks );    % TTP
        peaksTable{ k, i, 5 } = zeros( 1, nbPeaks );    % RiseTime
        peaksTable{ k, i, 6 } = zeros( 1, nbPeaks );    % DecayTime
        peaksTable{ k, i, 7 } = zeros( 1, nbPeaks );    % Amplitude
        for j=1:nbPeaks
            [unused1, unused2, rt, amplitude] = getRiseTime( smoothedData, i, baseLineMeanSmoothed, indexEffectiveBeginStims(k), ...
                                                                                   peaksTable{ k, i, 2 }(j), riseAndDecayThresholds(1), ...
                                                                                   riseAndDecayThresholds(2), samplingRate );
            [unused1, unused2, dt, unused3] = getDecayTime( smoothedData, i, baseLineMeanSmoothed, peaksTable{ k, i, 2 }(j), ...
                                                                   indexEndAnswers(k), riseAndDecayThresholds(3), ...
                                                                   riseAndDecayThresholds(4), samplingRate );
                                                               
            peaksTable{ k, i, 4 }(j) = samplingRate * ( peaksTable{ k, i, 2 }(j) - indexBeginStims(k) );
            peaksTable{ k, i, 5 }(j) = rt;
            peaksTable{ k, i, 6 }(j) = dt;
            peaksTable{ k, i, 7 }(j) = amplitude;
        end
        
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function displaySweepMaximaInfo( nbSweep )
        % Display, for a stim, a lot of informations, on a graph : maxima, window
        % of maximum research, etc
        figure
        hold on, plot(data(:, nbSweeps+2), data(:, 1),'b', 'DisplayName', 'raw data');
        hold on, plot(smoothedData(:, nbSweeps+2), smoothedData(:, 1),'k', 'DisplayName', 'smoothed data');
        ylims = get(gca,'YLim'); % [Ymin Ymax] (gca = current axes handle)
        for loopIndex=1:nbStims
            for q=1:numel( peaksTable{ loopIndex, 1, 1 } )
                x = peaksTable{ loopIndex, 1, 1 }(q);
                y = peaksTable{ loopIndex, 1, 3 }(q);
                hold on, plot( x, y, 'o', 'MarkerFaceColor','w', 'MarkerSize', 5);
            end
        end
        for loopIndex=1:nbStims
            hold on, plot( data(indexBeginStims(loopIndex), nbSweeps+2)*[1 1], ylims, '--b', 'DisplayName', 'indexBeginStims');
            hold on, plot( data(indexEffectiveBeginStims(loopIndex), nbSweeps+2)*[1 1], ylims, '--r', 'DisplayName', 'indexEffectiveBeginStims');
            hold on, plot( data(indexEndStims(loopIndex), nbSweeps+2)*[1 1], ylims, '--g', 'DisplayName', 'indexEndStims');
            hold on, plot( data(indexBeginArtifact(loopIndex), nbSweeps+2)*[1 1], ylims, '--m', 'DisplayName', 'indexBeginArtifact');
            hold on, plot( data(indexEndArtifact(loopIndex), nbSweeps+2)*[1 1], ylims, '--k', 'DisplayName', 'indexEndArtifact');
            hold on, plot( data(indexEndAnswers(loopIndex), nbSweeps+2)*[1 1], ylims, '--b', 'DisplayName', 'indexEndAnswers');
            hold on, area( [data(indexBeginArtifact(loopIndex), nbSweeps+2) data(indexEndArtifact(p), nbSweeps+2)], [ylims(2) ylims(2)], 'DisplayName', 'Artifact Window (excluded)', 'BaseValue', ylims(1));
        end
    end

%% Testing
% if nbSweeps >= 1
%     displaySweepMaximaInfo(1);
% end

%%%%%%%% First selection : which are the sweep with detected peaks ? %%%%%%
temp1 = 1 ;
temp2 = 1 ;
sweepsSelectedFirstPass = zeros(1,1) ;
arePeaksDetectedCritIndex = 2*nbStims+2; % Criterion : have the peaks been detected ?

withDetectedPeak = [ ];
for k=1:nbStims
    for i=1:nbSweeps
        % First filtering : all peaks must have been detected
        if peaksMaxTable{ k, i, 1 } < 0
            criterionsTable(i,arePeaksDetectedCritIndex) = 0;  % at least one peak has not been detected
        end
    end
end
for i=1:nbSweeps
    if criterionsTable(i,arePeaksDetectedCritIndex) == 1
        criterionsTable(i,1) = 1 ;
        sweepsSelectedFirstPass(temp1) = i ;
        withDetectedPeak = [withDetectedPeak peaksMaxTable{k,i,3}];
        temp1 = temp1 + 1 ;
    else
        temp2 = temp2 + 1 ;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END First selection %%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

durConsideredBeforeStimForBL = 5;
baselinesPlot = zeros( sweepSize, 2 ) ;
mean_BL = 0;
if sweepsSelectedFirstPass(1) == 0
    display('WARNING : no sweeps with detected peaks') ;
    selectedList = [ ];
    rep = {}; %#ok<NASGU>
else
    
    nbSelectFirstPass = numel( sweepsSelectedFirstPass ) ;
    rangeUsedThresholdCriterions = [ ]; % The threshold criterions we use
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Baseline exclusion %%%%%%%%%%%%%%%%%%%%%%%
    baseline_table = cell(1,nbStims) ;
    for k=1:nbStims
        
        baseline_table{k} = zeros(nbSweeps,1) ;
        for i = 1:nbSweeps
            baseline_table{k}(i) = mean( smoothedData(indexBeginStims(k)-int32(durConsideredBeforeStimForBL/samplingRate):indexBeginStims(k),i),1 ) ; %%% from 5 ms before the stim
            criterionsTable( i, 2*k ) = 1 ; % Criterion OK by default : if not, will be set to 0 below
        end
        % Mean baseline for this stim
        mean_BL = mean( baseline_table{k}(:) );
        
        %%%%%%%% First criterion : baseline exclusion
        if baseLineExcls(k) > 0
            baseline_min =  mean_BL - baseLineExcls(k);
            baseline_max =  mean_BL + baseLineExcls(k);
            
            % Used to visualize (plot) the min and max baselines, after
            baselinesPlot( indexBeginStims(k)-int32( durConsideredBeforeStimForBL/samplingRate ):indexBeginStims(k), 1 ) = baseline_min;
            baselinesPlot( indexBeginStims(k)-int32( durConsideredBeforeStimForBL/samplingRate ):indexBeginStims(k), 2 ) = baseline_max;
            
            % (colonne de criterionsTable pour exclure les sweeps avec un evenement juste avant la stim)
            for i=1:nbSweeps
                if ( (smoothedData(indexBeginStims(k),i) > baseline_max) || (smoothedData(indexBeginStims(k),i) < baseline_min) )
                    criterionsTable( i, 2*k ) = 0 ;
                end
            end
            
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End BL Exclusion %%%%%%%%%%%%%%%%%%
    
    for k=1:nbStims
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTP exclusion %%%%%%%%%%%%%%%%%%%%%%
%         for i=1:nbSweeps
%             %    st_deviation_Tb = std( withDetectedPeak );  % standard deviation = 'ecart-type'
%             mean_Tb(k) = mean( withDetectedPeak );
%             
%             % Do we use this criterion (TTP for this peak ?)
%             if timeToPeakExcls(k, 1) > 0
%                 % Peaks not between the two specified dates are ... suspect
%                 j = find( sweepsSelectedFirstPass(:) == i );
%                 if ~isempty(j)
%                     if ( peaksMaxTable{k,j,1} > 0 && peaksMaxTable{k,i,1} > timeToPeakExcls(k, 1) && peaksMaxTable{k,i,1} < timeToPeakExcls(k, 2) )
%                         criterionsTable(i,2*k+1) = 1 ;
%                     end
%                 end
%             else
%                 criterionsTable(:,2*k+1) = 1; % by default, if the criterion isn't used, it's OK
%             end
%             % ---------------------------------------------------------- fin 2e tri ---
%         end
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%% END TTP exclusion %%%%%%%%%%%%%%%%%%%

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% Rise time exclusion %%%%%%%%%%%%%%%%%%
        
        for i=1:nbSweeps
            % Do we use this criterion (RT for this peak ?)
            if riseTimeExcls(k, 1) > 0
                if ( riseTimeTable(i,k) > riseTimeExcls(k, 1) && riseTimeTable(i,k) < riseTimeExcls(k, 2) )
                    criterionsTable(i, 3*nbStims+2+k) = 1 ;
                end
            else
                criterionsTable(:, 3*nbStims+2+k) = 1; % by default, if the criterion isn't used, it's OK
            end
            % ---------------------------------------------------------- fin 2e tri ---
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% END Rise time exclusion  %%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% Decay time exclusion %%%%%%%%%%%%%%%%%%
        
        for i=1:nbSweeps
            % Do we use this criterion (DT for this peak ?)
            if decayTimeExcls(k, 1) > 0
                if ( decayTimeTable(i,k) > decayTimeExcls(k, 1) && decayTimeTable(i,k) < decayTimeExcls(k, 2) )
                    criterionsTable(i, 4*nbStims+2+k) = 1 ;
                end
            else
                criterionsTable(:, 4*nbStims+2+k) = 1; % by default, if the criterion isn't used, it's OK
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% END Decay time exclusion  %%%%%%%%%%%%%
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Threshold exclusion %%%%%%%%%%%%%%%%%%%%
        
        % Does this peak have a threshold ?
        if k <= size(peakThreshold, 1) && peakThreshold(k) > 0
            
            % This threshold is used as a criterion
            rangeUsedThresholdCriterions = [rangeUsedThresholdCriterions 2*nbStims+2+k];
            
            % Are we above the threshold ?
            for i=1:nbSelectFirstPass
                j = sweepsSelectedFirstPass(i);
                if (peaksMaxTable{k,j,3} - mean_BL) < peakThreshold(k, 1) || (peaksMaxTable{k,j,3} - mean_BL) > peakThreshold(k, 2)
                    criterionsTable( j, 2*nbStims+2+k ) = 0;
                else
                    criterionsTable( j, 2*nbStims+2+k ) = 1;
                end
            end
        else
            criterionsTable( :,2*nbStims+2+k ) = 1; % No threshold means "OK for this criterion"
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% END Threshold exclusion %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%   Criterion : summary   %%%%%%%%%%%%%%%%%%%%%%
    
    for i=1:nbSweeps
        blResult = 1;
        if doBLExclusion  % Baseline exclusion : used
            rangeUsedCriterions = [ ];
            parfor k=1:nbStims
                if k <= size(baseLineExcls, 2) && baseLineExcls(k) > 0 > 0
                    rangeUsedCriterions = [rangeUsedCriterions 2*k];
                end
            end
            if allStimsMustPass
                blResult  = prod( criterionsTable(i, rangeUsedCriterions) ); % All components must be set to 1
            else
                blResult  = numel( nonzeros( criterionsTable(i, rangeUsedCriterions) ) ) > 0 || isempty( rangeUsedCriterions ); % Only one non-null component is enough
            end
        end
        
        ttpResult = 1;
        if doTTPExclusion  % Time-to-Peak exclusion : used
            rangeUsedCriterions = [ ];
            for k=1:nbStims
                if k <= size(timeToPeakExcls, 2) && timeToPeakExcls(k) > 0
                    rangeUsedCriterions = [rangeUsedCriterions 2*k+1];
                end
            end
            if allStimsMustPass
                ttpResult  = prod( criterionsTable(i, rangeUsedCriterions) ); % All components must be set to 1
            else
                ttpResult  = numel( nonzeros( criterionsTable(i, rangeUsedCriterions) ) ) > 0 || isempty( rangeUsedCriterions ); % Only one non-null component is enough
            end
        end
        
        riseTimeResult = 1;
        if doRiseTimeExclusion  % Rise time exclusion : used
            rangeUsedCriterions = [ ];
            for k=1:nbStims
                if k <= size(riseTimeExcls, 2) && riseTimeExcls(k) > 0
                    rangeUsedCriterions = [rangeUsedCriterions 3*nbStims+2+k];
                end
            end
            if allStimsMustPass
                riseTimeResult  = prod( criterionsTable(i, rangeUsedCriterions) ); % All components must be set to 1
            else
                riseTimeResult  = numel( nonzeros( criterionsTable(i, rangeUsedCriterions) ) ) > 0 || isempty( rangeUsedCriterions ); % Only one non-null component is enough
            end
        end
        
        decayTimeResult = 1;
        if doDecayTimeExclusion  % Decay time exclusion : used
            rangeUsedCriterions = [ ];
            for k=1:nbStims
                if k <= size(decayTimeExcls, 2) && decayTimeExcls(k) > 0
                    rangeUsedCriterions = [rangeUsedCriterions 4*nbStims+2+k];
                end
            end
            if allStimsMustPass
                decayTimeResult  = prod( criterionsTable(i, rangeUsedCriterions) ); % All components must be set to 1
            else
                decayTimeResult  = numel( nonzeros( criterionsTable(i, rangeUsedCriterions) ) ) > 0 || isempty( rangeUsedCriterions ); % Only one non-null component is enough
            end
        end
        
        if allStimsMustPass
            thresholdResult  = prod( criterionsTable(i, rangeUsedThresholdCriterions) ); % All components must be set to 1
        else
            thresholdResult  = numel( nonzeros( criterionsTable(i, rangeUsedThresholdCriterions) ) ) > 0 || isempty( rangeUsedThresholdCriterions ); % Only one non-null component is enough
        end
        
        % Now, is the sweep selected ? Update 'criterionsTable'
        criterionsTable(i,1) = ttpResult * blResult * riseTimeResult * decayTimeResult * thresholdResult * criterionsTable(i,arePeaksDetectedCritIndex);
        
        % Update 'criterionsTable', taking all criterions into account
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%   End criterion summary %%%%%%%%%%%%%%%%%%%%%%
    
    excludedList = transpose( find(criterionsTable(1:nbSweeps,1) == 0) );
    selectedList = transpose( find(criterionsTable(1:nbSweeps,1) == 1) );
    nbSelected = numel(selectedList) ;
    nbExcluded = numel(excludedList);
    display( '--------------------------------' );
    display( 'Summary :' );
    display( sprintf( '  Selected sweeps (%d) :', nbSelected ) );
    disp( sweepsToKeep( selectedList ) );
    display( sprintf( '  Excluded sweeps (%d) :', nbExcluded ) );
    disp( sweepsToKeep( excludedList ) );
    display( sprintf( '  Exclusion rate : %f', nbExcluded/nbSweeps ) ) ;
    display( '--------------------------------' );
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Peak summary %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
summaryPeaks = cell(1, 9);
p = 1;
summaryPeaks{p, 1} = file_name;
summaryPeaks{p, 2} = '#Sweep';
summaryPeaks{p, 3} = '#Stim';
summaryPeaks{p, 4} = '#Peak';
summaryPeaks{p, 5} = 'Time';
summaryPeaks{p, 6} = 'TTP';
summaryPeaks{p, 7} = 'RiseTime';
summaryPeaks{p, 8} = 'DecayTime';
summaryPeaks{p, 9} = 'Amplitude';
p = p + 1;
for i=1:nbSweeps
    for k=1:nbStims
        nbPeaks = numel( peaksTable{ k, i, 1 } );
        for j=1:nbPeaks
            summaryPeaks{p, 1} = '';
            summaryPeaks{p, 2} = i;
            summaryPeaks{p, 3} = k;
            summaryPeaks{p, 4} = j;
            summaryPeaks{p, 5} = peaksTable{ k, i, 1 }(j);	% time of peak
            summaryPeaks{p, 6} = peaksTable{ k, i, 4 }(j);	% TTP
            summaryPeaks{p, 7} = peaksTable{ k, i, 5 }(j);  % RiseTime
            summaryPeaks{p, 8} = peaksTable{ k, i, 6 }(j);  % DecayTime
            summaryPeaks{p, 9} = peaksTable{ k, i, 7 }(j);  % Amplitude
            p = p + 1;
        end
    end
end

% Put peak info into the workspace
display('registering peaks in the workspace ...') ;
varName = genvarname(strcat('peaks_', file_name), who) ;
assignin( 'base', varName, summaryPeaks );

%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%

maximaArrayColor = zeros( nbSweeps );
global colorsGraph;

colorsGraph = {'r', 'c', 'm', 'g', 'b', 'y', 'k' };

h = zeros(1,9);

if plotFailedData || plotSelectData
    display('plotting...') ;
    
    % Figure 1 : summary
    figure
    for i=1:nbSweeps
        if plotFailedData && criterionsTable(i,2*nbStims+2) == 0 % no peak detected : red
            hold on, plot(smoothedData(:, nbSweeps+2), smoothedData(:, i), colorsGraph{1}, 'DisplayName', sprintf('Sweep %d', sweepsToKeep(i)) );
            if h(2) == 0
                hold on, h(2) = plot(smoothedData(1, nbSweeps+2), smoothedData(1, i), colorsGraph{1}); % phony graph, for the legend
            end
            % No entry in maximaArray : no peaks detected
        elseif plotFailedData && prod( criterionsTable(i,rangeUsedThresholdCriterions) ) == 0 % threshold exclusion : cyan
            hold on, plot(smoothedData(:, nbSweeps+2), smoothedData(:, i), colorsGraph{2}, 'DisplayName', sprintf('Sweep %d', sweepsToKeep(i)) );
            if h(3) == 0
                hold on, h(3) = plot(smoothedData(1, nbSweeps+2), smoothedData(1, i), colorsGraph{2}); % phony graph, for the legend
            end
            maximaArrayColor(i) = 2;  % maximum : color
        elseif plotFailedData && doTTPExclusion && prod(criterionsTable(i,3:2:2*nbStims+1)) == 0 % time-to-peak exclusion : magenta
            hold on, plot(smoothedData(:, nbSweeps+2), smoothedData(:, i),'m', 'DisplayName', sprintf('Sweep %d', sweepsToKeep(i)) );
            if h(4) == 0
                hold on, h(4) = plot(smoothedData(1, nbSweeps+2), smoothedData(1, i),'m'); % phony graph, for the legend
            end
            maximaArrayColor(i) = 3;  % maximum : color
        elseif plotFailedData && doBLExclusion && prod(criterionsTable(i,2:2:2*nbStims)) == 0   % baseline exclusion : green
            hold on, plot(smoothedData(:, nbSweeps+2), smoothedData(:, i),'g', 'DisplayName', sprintf('Sweep %d', sweepsToKeep(i)) );
            if h(5) == 0
                hold on, h(5) = plot(smoothedData(1, nbSweeps+2), smoothedData(1, i),'g'); % phony graph, for the legend
            end
            maximaArrayColor(i) = 4;  % maximum : color
        elseif plotSelectData &&  criterionsTable(i,1) == 1 % accepted : blue
            hold on, plot(smoothedData(:, nbSweeps+2), smoothedData(:, i),'b', 'DisplayName', sprintf('Sweep %d', sweepsToKeep(i)) );
            if h(6) == 0
                hold on, h(6) = plot(smoothedData(1, nbSweeps+2), smoothedData(1, i),'b'); % phony graph, for the legend
            end
            maximaArrayColor(i) = 5;  % maximum : color
        elseif plotFailedData && prod(criterionsTable(i,3*nbStims+3:4*nbStims+2)) == 0   % risetime exclusion : yellow
            hold on, plot(smoothedData(:, nbSweeps+2), smoothedData(:, i),'y', 'DisplayName', sprintf('Sweep %d', sweepsToKeep(i)) );
            if h(7) == 0
                hold on, h(7) = plot(smoothedData(1, nbSweeps+2), smoothedData(1, i),'y'); % phony graph, for the legend
            end
            maximaArrayColor(i) = 6;  % maximum : color
        elseif plotFailedData && prod(criterionsTable(i,4*nbStims+3:5*nbStims+2)) == 0   % decaytime exclusion : dotted yellow
            hold on, plot(smoothedData(:, nbSweeps+2), smoothedData(:, i),':y', 'DisplayName', sprintf('Sweep %d', sweepsToKeep(i)) );
            if h(8) == 0
                hold on, h(8) = plot(smoothedData(1, nbSweeps+2), smoothedData(1, i),':y'); % phony graph, for the legend
            end
            maximaArrayColor(i) = 6;  % maximum : color
        end
    end
    % Mean sweep (in black, bold, dotted)
    maximaArrayColor(nbSweeps+1) = 7;
    if nbSweeps > 1
        hold on, h(1) = plot(smoothedData(:, nbSweeps+2), smoothedData(:, nbSweeps+1),':k', 'LineWidth',3, 'DisplayName', 'Mean sweep'  );
        % Mean of selected sweeps (in black, bold, dashed)
        if plotSelectData
            if numel(selectedList) > 1
                meanSelected = mean( smoothedData(:, selectedList ), 2 );
                hold on, h(9) = plot(smoothedData(:, nbSweeps+2), meanSelected,'--k', 'LineWidth',2, 'DisplayName', 'Mean of selected sweeps'  );
            else
                display( 'Only one selected sweep : displaying the mean of selected sweeps would be redundant.' );
            end
        end
    else
        display( 'Only one sweep : displaying the mean sweep would be redundant.' );
    end
    
    % Legend
    legends = {'Mean sweep', 'Peaks not detected', 'Threshold exclusion', 'Time-to-Peak exclusion', 'BL exclusion', 'Valid', 'Rise time exclusion', 'Decay time exclusion', 'Mean of selected' };
    existingGraphs = find(h);
    hold on, legend( h(existingGraphs), legends{ existingGraphs });
    
    % Plot the baselines used for selection, thresholds for peaks and the acceptable range for peaks,
    % if the corresponding criterions are selected
    ylims = get(gca,'YLim'); % [Ymin Ymax] (gca = current axes handle)
    for k=1:nbStims
        if doBLExclusion && baseLineExcls(k) > 0
            bgnPlt = indexBeginStims(k) - int32( durConsideredBeforeStimForBL/samplingRate );
            endPlt = indexBeginStims(k);
            hold on, plot(smoothedData(bgnPlt:endPlt, nbSweeps+2), baselinesPlot(bgnPlt:endPlt, 1),'r', 'LineWidth', 3 );
            hold on, plot(smoothedData(bgnPlt:endPlt, nbSweeps+2), baselinesPlot(bgnPlt:endPlt, 2),'r', 'LineWidth', 3 );
        end
        
        if doTTPExclusion && timeToPeakExcls(k) > 0
            hold on, plot( [timeToPeakExcls(k, 1) timeToPeakExcls(k, 1)], ylims, '--b');    % Min date for the peak
            hold on, plot( [timeToPeakExcls(k, 2) timeToPeakExcls(k, 2)], ylims, '--k');    % Max date for the peak
        end
        
        if k <= size(peakThreshold, 1) && peakThreshold(k, 1) > 0
            bgnPlt = indexBeginStims(k);
            endPlt = indexEndAnswers(k);
            % To visualize the threshold for the peaks of each stim
            thresholdData( bgnPlt:endPlt ) = mean_BL + peakThreshold(k, 1);
            hold on, plot(smoothedData(bgnPlt:endPlt, nbSweeps+2), thresholdData( bgnPlt:endPlt ),'--r', 'LineWidth', 2 );
            thresholdData( bgnPlt:endPlt ) = mean_BL + peakThreshold(k, 2);
            hold on, plot(smoothedData(bgnPlt:endPlt, nbSweeps+2), thresholdData( bgnPlt:endPlt ),'--r', 'LineWidth', 2 );
        end
        % Plot maxima
        if plotMaxima
            
            %% Step 1 : the 'big' maxima, i.e the main peaks
            
            nonZerosX = [ ];
            for i=1:nbSweeps+1
                if peaksMaxTable{k, i, 3} > 0
                    nonZerosX = [nonZerosX i];
                end
            end
            x = transpose( smoothedData([peaksMaxTable{k,nonZerosX,2}], nbSweeps+2) ); % The exact times of the maxima :
            % maximaArray(k,nonZerosX,1) contains the indexes of the
            % points, and *data(_, nbSweeps+2) contains the dates. If we
            % just compute the dates by multiplying the indexes by
            % the 'samplingRate', it's not accurate enough : the points are
            % not exactly on the curves.
            y = [peaksMaxTable{k, nonZerosX, 3}];
            colorCodes = maximaArrayColor(nonZerosX);
            for j=1:size(nonZerosX, 2)
                if j == nbSweeps+1
                    if nbSweeps > 1 % do not plot anything about mean if there is only one sweep
                        hold on, plot( x(j), y(j), 'o', 'MarkerEdgeColor', colorsGraph{colorCodes(j)}, 'MarkerFaceColor','w', 'MarkerSize', 6, 'DisplayName', 'Max for mean sweep' );
                    end
                elseif plotFailedData && colorCodes(j) ~= 5 && colorCodes(j) > 0
                    hold on, plot( x(j), y(j), 'o', 'MarkerEdgeColor', colorsGraph{colorCodes(j)}, 'MarkerFaceColor','w', 'MarkerSize', 6, 'DisplayName', sprintf('Max for sweep %d', sweepsToKeep( nonZerosX(j) ) ) );
                elseif plotSelectData && colorCodes(j) > 0
                    hold on, plot( x(j), y(j), 'o', 'MarkerEdgeColor', colorsGraph{colorCodes(j)}, 'MarkerFaceColor','w', 'MarkerSize', 6, 'DisplayName', sprintf('Max for sweep %d', sweepsToKeep( nonZerosX(j) ) ) );
                end
            end
            
            %% Step 2 : all the other, secondary maxima
            for i=1:nbSweeps
                for j=1:numel( peaksTable{k, i, 1} )
                    x = smoothedData( peaksTable{k,i,2}(j), nbSweeps+2 );
                    y = peaksTable{k,i,3}(j);
                    if plotFailedData && maximaArrayColor(i) ~= 5 && maximaArrayColor(i) > 0
                        hold on, plot( x, y, '+', 'MarkerEdgeColor', colorsGraph{maximaArrayColor(i)}, 'MarkerFaceColor','w', 'MarkerSize', 5, ...
                            'DisplayName', sprintf( 'Sweep %d : TTP : %f ; RiseTime : %f ; DecayTime : %f ; Amplitude : %f', ...
                            sweepsToKeep(i), peaksTable{k,i,4}(j), peaksTable{k,i,5}(j), peaksTable{k,i,6}(j), peaksTable{k,i,7}(j) ) );
                    elseif plotSelectData && maximaArrayColor(i) > 0
                        hold on, plot( x, y, '+', 'MarkerEdgeColor', colorsGraph{maximaArrayColor(i)}, 'MarkerFaceColor','w', 'MarkerSize', 5, ...
                            'DisplayName', sprintf( 'Sweep %d : TTP : %f ; RiseTime : %f ; DecayTime : %f ; Amplitude : %f', ...
                            sweepsToKeep(i), peaksTable{k,i,4}(j), peaksTable{k,i,5}(j), peaksTable{k,i,6}(j), peaksTable{k,i,7}(j) ) );
                    end
                end
            end
            
        end
    end
    
    title( sprintf( '%s : criterion selection', file_name ) ,'Interpreter','none');
    ylabel('I [pA]') ;
    xlabel('t [ms]') ;
    
    % For each stim : risetime /decay time/amplitude = f(ttP)
    %colorCodes = ones( 1, nbSweeps );   % Rejected in red
    %colorCodes( 1, selectedList ) = 5;  % Selected in blue
    colorCodes = maximaArrayColor;
    amplitudeTableExcl = zeros( nbStims, 2 );
    for nbStim=1:nbStims
        figure
        caracteristicFunctionTTP( riseTimeTable, riseTimeExcls, ttpTable, 'Rise time [ms]', nbSweeps, sweepsToKeep, nbStim, colorCodes, 3, 1 );
        caracteristicFunctionTTP( decayTimeTable, decayTimeExcls, ttpTable, 'Decay time [ms]', nbSweeps, sweepsToKeep, nbStim, colorCodes, 3, 2 );
        caracteristicFunctionTTP( amplitudeTable, amplitudeTableExcl, ttpTable, 'Amplitude [pA]', nbSweeps, sweepsToKeep, nbStim, colorCodes, 3, 3 );
        mtit( sprintf( 'Stim %d (%s)', nbStim, file_name ) ,'Interpreter','none');
    end
end

%%%%%%%%%%%%%%%%%%% END PLOT %%%%%%%%%%%%%%%%%%%%



% ################################################################ SAVE ###
save_test = cell( nbSweeps, 4*nbStims+5 );
if doSave
    
    for i=1:nbSweeps
        for j=1:size(save_test, 2)
            save_test{i,j} = criterionsTable(i,j) ;
        end
    end
    
    for i=1:nbSweeps
        data_to_save{ID+i,1} = file_name ;
        data_to_save{ID+i,2} = sweepsToKeep(i) ; % the real sweep number ;
        data_to_save(ID+i,3:4*nbStims+7) = save_test(i,:) ;
    end
    
    rep = data_to_save ;
else
    rep = {} ;
    
end


% ############################################################ END SAVE ###

% criterionsTable
end

% ############################################################ END CODE ###


%%%%%%%%%%%%%%% Helper function %%%%%%%%%%%%
function caracteristicFunctionTTP( caracTable, caracThresholds, ttpTable, strCaracName, nbSweeps, sweepsToKeep, k, colorCodes, nbSubplots, nbSubplot )  
        global colorsGraph;
        
        plotHandles = zeros( nbSubplots, 1 );
        plotLegends = cell( nbSubplots, 1 );
        
        m = ceil( sqrt(nbSubplots) );
        subplot( m, m, nbSubplot);
        for i=1:nbSweeps
            if ttpTable(i,k) > 0 && colorCodes(i) > 0
                hold on, plot(  ttpTable(i,k), caracTable(i,k), 'o', 'MarkerEdgeColor', colorsGraph{colorCodes(i)}, ...
                    'DisplayName', sprintf('Sweep %d', sweepsToKeep(i)), 'MarkerSize', 5 );
            end
        end
        xlims = get(gca,'XLim'); % [Xmin Xmax] (gca = current axes handle)
        if caracThresholds( k, 1 ) > 0
            hold on, plot( xlims, caracThresholds( k, 1 )*[1 1],'--k');
            hold on, plot( xlims, caracThresholds( k, 2 )*[1 1],'--k');
        end
        
        %plotLegends{k, 1} = sprintf( 'Stim %d', k );
        ylabel( strCaracName );
        xlabel('Time-to-peak [ms]');
        %legend( plotHandles, plotLegends );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%