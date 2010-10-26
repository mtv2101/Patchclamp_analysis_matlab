function varargout = gui_plasticity(varargin)
%GUI_PLASTICITY M-file for gui_plasticity.fig
%      GUI_PLASTICITY, by itself, creates a new GUI_PLASTICITY or raises the existing
%      singleton*.
%
%      H = GUI_PLASTICITY returns the handle to a new GUI_PLASTICITY or the handle to
%      the existing singleton*.
%
%      GUI_PLASTICITY('Property','Value',...) creates a new GUI_PLASTICITY using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to gui_plasticity_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI_PLASTICITY('CALLBACK') and GUI_PLASTICITY('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI_PLASTICITY.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_plasticity

% Last Modified by GUIDE v2.5 14-Aug-2010 14:51:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_plasticity_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_plasticity_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_plasticity is made visible.
function gui_plasticity_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for gui_plasticity
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Default path
[p1,p2] = matlabPathDependingOnComputer();
temp = getfield(handles, 'folderSavePathEdit') ;
set(temp, 'string', strcat( p1, 'Matlab2008directory/')  ) ;
temp = getfield(handles, 'fileListFullPathEdit') ;
set(temp, 'string', strcat( p2, 'Lists_ChR2_LTP/file_list_LTP_eIPSC_0.txt') );
temp = getfield(handles, 'folderDataPathEdit') ;
set(temp, 'string', strcat( p1, 'Data_Electrophy/ASCII_ChR2_LTP/')  ) ;
% Display the threshold gradient for peak detection
displayThresholdGradient();
% Set up the time info table for administered drugs
data = cell( 12, 3 );
for i=1:12
    data{i,1} = sprintf( 'Drug %i', i );
    data{i,2} = 0;
    data{i,3} = 0;
end
handle = findobj( 'Tag', 'timeWindowsTable' );
set(handle,'Data', data(:,1:3));


% --- Outputs from this function are returned to the command line.
function varargout = gui_plasticity_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadDataButton.
function loadDataButton_Callback(hObject, eventdata, handles)
% Loads the data (first tab)
handle = findobj( 'Tag', 'folderDataPathEdit' );
folderDataPath = get( handle, 'string' );
handle = findobj( 'Tag', 'fileListFullPathEdit' );
fileListFullPath = get( handle, 'string');
handle = findobj( 'Tag', 'previewSweepsData' ); % figure handle
try
    loadPlasticitySweepData( folderDataPath, fileListFullPath, handle );
% %     % set the time info into the timewindow table
% %     data = evalin('base', 'plasticityDataTimeInfo');
% %     handle = findobj( 'Tag', 'timeWindowsTable' );
% %     set(handle,'Data', data(:,1:2));
     msgbox( 'Data loaded and registered to the workspace' );
     display( '--- Loaded time info ---' );
catch me
    display( '----------------------' );
    display( me.message );
    display( '----------------------' );
end

function launchAnalysisButton_Callback(hObject, eventdata, handles)
handle = findobj( 'Tag', 'timeWindowsTable' );
data = get(handle,'Data');


display('begin data processing...') ;
% ######################################################## Setting path ###

handle = findobj( 'Tag', 'folderSavePathEdit' );
save_path = get( handle, 'string' );
handle = findobj( 'Tag', 'saveResultsFilenameEdit' );
save_name = get( handle, 'string') ;

% #################################################### END Setting path ###



% ###################################################### Configurations ###
handle = findobj( 'Tag', 'samplingRateEdit' );
samplingRate = str2double( get(handle, 'string') );
handle = findobj( 'Tag', 'nbStimsEdit' );
nbStims = str2double( get( handle, 'string' ) ) ;

handle = findobj( 'Tag', 'deltaXEdit' );
bss_time = str2double(get( handle, 'string' )) ;
handle = findobj( 'Tag', 'deltaYEdit' );
bss_rise = str2double(get( handle, 'string' )) ;
begin_spike_smooth = [bss_time, bss_rise]; 


temp =  findobj( 'Tag', 'stimsBeginningEdit') ;
stimBegin = get(temp, 'string') ;
stimBegin = regexp(stimBegin, '\_', 'split') ;

temp =  findobj( 'Tag', 'stimsDurationEdit') ;
stimDur = get(temp, 'string') ;

temp =  findobj( 'Tag', 'exclusionTimeEdit') ;
stimExcl = get(temp, 'string') ;

stim = zeros(nbStims,3) ;
for i=1:nbStims
    stim(i,1) = str2double( stimBegin{i} ) ;
	stim(i,2) = str2double( stimDur ) ;
	stim(i,3) = str2double( stimExcl ) ;
end

max_min_smooth = zeros(2,2) ;
smoothing_time = zeros(1,2) ;

temp =  findobj( 'Tag', 'smoothingTime1Edit' );
smoothing_time(1,1) = str2double(get(temp, 'string')) ;
temp =  findobj( 'Tag', 'smoothingTime2Edit' );
smoothing_time(1,2) = str2double(get(temp, 'string')) ;

temp =  findobj( 'Tag', 'timeWindowStartEdit') ;
analysisTimeWindow(1) = str2double(get(temp, 'string')) ;
temp =  findobj( 'Tag', 'timeWindowEndEdit') ;
analysisTimeWindow(2) = str2double(get(temp, 'string')) ;

% Which sweeps to analyze, which ones to exclude ?
sweepRange = ''; % default : all (overridden by list of files)


% Percentage windows for rise and decay time
riseAndDecayThresholds = zeros(4,1);
temp =  findobj( 'Tag', 'rtLevel1Edit') ;
riseAndDecayThresholds(1) = str2double( get(temp, 'string') ) / 100.0;
temp =  findobj( 'Tag', 'rtLevel2Edit') ;
riseAndDecayThresholds(2) = str2double( get(temp, 'string') ) / 100.0;
temp =  findobj( 'Tag', 'dtLevel2Edit') ;   % the highest threshold (100% by default)
riseAndDecayThresholds(3) = str2double( get(temp, 'string') ) / 100.0;
temp =  findobj( 'Tag', 'dtLevel1Edit') ;   % the lowest threshold (63% by default)
riseAndDecayThresholds(4) = str2double( get(temp, 'string') ) / 100.0;

toDo = zeros(1,11) ;
% Plot options
% don't delegate the plotting to the ChR subprogram
toDo(1) = 0;
toDo(3) = 0;
% Analysis options
toDo(4) = 1; % analyse peaks;
toDo(5) = get( findobj( 'Tag', 'integralAnalysisCheckbox'), 'value');
toDo(6) = get( findobj( 'Tag', 'pprAnalysisCheckbox'), 'value');    % Per Pulse Ratio
toDo(7) = get( findobj( 'Tag', 'rtAnalysisCheckbox'), 'value');    % Rise time
toDo(8) = get( findobj( 'Tag', 'dtAnalysisCheckbox'), 'value');    % Decay time
toDo(9) = get( findobj( 'Tag', 'testPulseAnalysisCheckbox'), 'value'); % Test pulse fit
% Save options
toDo(10) = get( findobj( 'Tag', 'saveSweepsCheckbox'), 'value') ;

% PPR, more detailed
toDo(6) = toDo(6) * ( get( findobj( 'Tag', 'stim2over1RadioButton'), 'Value' ) + 2*get( findobj( 'Tag', 'stim3over2RadioButton'), 'Value' ) );     % 0 = no ; 1 = stim2/stim1 ; 2 = stim3/stim2

toDo(2) = 0; % don't do mean
toDo(11) = 0; % so don't save mean

default_config = {samplingRate, nbStims, stim, max_min_smooth, smoothing_time} ;

% ################################################## END Configurations ###

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% File lists data %%%%%%%%%%
try
    fileOptions = evalin('base', 'plasticityFileListOptions');
    fileNames = evalin('base', 'plasticityFileListNames');
    fileSweepNumbers = evalin('base', 'plasticityFileSweepNumbers');
    fileSweepSize = evalin('base', 'plasticityFileSweepSizes');
    dataTimeInfo = evalin('base', 'plasticityDataTimeInfo');
    plasticityData = evalin('base', 'plasticityData');
    nbFiles = size( dataTimeInfo, 1 );
catch me
    errordlg( 'Make sure the data has already been loaded using the ''Load Sweep data'' tab' );
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% searching maximum number of stimulations
max_nbStims = nbStims ;
% checking the NbStim parameter for all the files
for ID=1:nbFiles
    if strcmp('',fileOptions{ID}) == 0
        options = regexp(fileOptions{ID},'\/','split') ;
        
        for i=1:size(options,2)
            str = options{i} ;
            if size(regexp(str,'NbStim=','end')) ~= 0
                index = regexp(str,'NbStim=','end') ;
                max_nbStims = max(str2double(str(index(1)+1:size(str,2))),max_nbStims) ;
            end
        end
    end
end


% setting the array for saving the data
nbBeforeStimsCols = 6+4*nbStims;
sweepsData = cell(1, 2*max_nbStims+nbBeforeStimsCols) ;
sweepsData{1,1} = 'File name' ;
sweepsData{1,2} = 'Sweep nb' ;
sweepsData{1,3} = 'Capa_Meanfit [pF]' ;
sweepsData{1,4} = 'Rsquare_Meanfit' ;
sweepsData{1,5} = 'Rm (Mohm)' ;
sweepsData{1,6} = 'Ra (Mohm)' ;

for k=1:nbStims
    sweepsData{1,6+k} = sprintf('Time-to-peak (ms) for stim #%i', k) ;
    sweepsData{1,6+nbStims+k} = sprintf('Rise time (ms) for stim #%i', k) ;
    sweepsData{1,6+2*nbStims+k} = sprintf('Decay time (ms) for stim #%i', k) ;
    sweepsData{1,6+3*nbStims+k} = sprintf('Amplitude (pA) for stim #%i', k) ;
end

for k=1:max_nbStims
    sweepsData{1,k+nbBeforeStimsCols} = strcat('Stim#',int2str(k),'_Integral_time_window') ;
    sweepsData{1,k+max_nbStims+nbBeforeStimsCols} = strcat('Stim#',int2str(k),'_Peak in pA during time_window') ;
end

%%%% PPR %%%%

strPPR = 'PPR (disabled)';
if toDo(6) == 1
    strPPR = 'PPR (stim2/stim1)';
    % In order to the PPR 2/1 to work, the analysis of the stims 1 and 2
    % must be done
    set( findobj( 'Tag', 'analyzeStim2' ), 'value', 1 );
    set( findobj( 'Tag', 'analyzeStim1' ), 'value', 1 );
elseif toDo(6) == 2
	strPPR = 'PPR (stim3/stim2)';
    % idem for 3 and 2
    set( findobj( 'Tag', 'analyzeStim3' ), 'value', 1 );
    set( findobj( 'Tag', 'analyzeStim2' ), 'value', 1 );
end
sweepsData{1,2*max_nbStims+nbBeforeStimsCols+1} = strPPR;

%%%% Stim Range %%%%

% Which stims to analyze, which ones to exclude ?
stimRange = []; % default : all (overridden by list of files)
for i=1:3
    if get( findobj( 'Tag', sprintf('analyzeStim%i', i) ), 'value')
        stimRange = [stimRange; i];
    end
end
if isempty(stimRange)
    uiwait( warndlg( 'No stim selected, reverting to default : the analysis will be run on all stims.' ) );
    for i=1:3
        set( findobj( 'Tag', sprintf('analyzeStim%i', i) ), 'value', 1 )
    end
end
stimRange = sprintf('%i;',stimRange(:));

%%% settings & analysis %%%
% Saving default parameters (each loop incrementation, restore them)
stimBegin_default = stimBegin ;
stimDur_default = str2double( stimDur ) ;
stimExcl_default = str2double( stimExcl ) ;
sweepRange_default = sweepRange;
stimRange_default = stimRange;

% The sweeps numbers we keep, ordered and put one after the other
% for example, if we have two files, one of 7 sweeps and the other of 10 sweeps,
% and we keep the sweep 2;3 for the first and 8 for the second, it will be
% [2;3;15]
sweepsKeptInAllFilesOrdered = [];
nbSweepsInAllFilesUntilThisOne = 0;   % At the end, will contain te total number of sweeps in all files, even those we havent kept

for ID=1:nbFiles
    display( sprintf('----Treating record %d----', ID) )
    
    % re-setting default parameters
    samplingRate = default_config{1,1} ;
    nbStims = default_config{1,2};
    stim = default_config{1,3} ;
    smoothing_time = default_config{1,5} ;
    stimBegin = stimBegin_default ;
    stimDur = stimDur_default ;
    stimExcl = stimExcl_default ;
    sweepRange = sweepRange_default;
    stimRange = stimRange_default;
    invertResults = 0;
    
    % taking modified parameters if specified
    if strcmp('',fileOptions{ID}) == 0
        options = regexp(fileOptions{ID},'\/','split') ;
        for i=1:size(options,2)
            str = options{i};
            if size(regexp(str,'NbStim=','end')) ~= 0
                index = regexp(str,'NbStim=','end') ;
                nbStims = str2double(str(index(1)+1:size(str,2))) ;
            elseif size(regexp(str,'StimBegin=','end')) ~= 0
                index = regexp(str,'StimBegin=','end') ;
                stimBegin = regexp(str(index(1)+1:size(str,2)), '\_', 'split') ;
            elseif size(regexp(str,'StimDur=','end')) ~= 0
                index = regexp(str,'StimDur=','end') ;
                stimDur = str2double(str(index(1)+1:size(str,2)));
            elseif size(regexp(str,'StimExcl=','end')) ~= 0
                index = regexp(str,'StimExcl=','end') ;
                stimExcl = str2double(str(index(1)+1:size(str,2))) ;
            elseif size(regexp(str,'ExclCritStd=','end')) ~= 0
                index = regexp(str,'ExclCritStd=','end') ;
                timeToPeakExcls(:) = str2double(str(index(1)+1:size(str,2))) ;
            elseif size(regexp(str,'ExclCritBl=','end')) ~= 0
                index = regexp(str,'ExclCritBl=','end') ;
                baseLineExcls = regexp(str(index(1)+1:size(str,2)), '\_', 'split') ; %% NOT TESTED
            elseif size(regexp(str,'SamplingRate=','end')) ~= 0
                index = regexp(str,'SamplingRate=','end') ;
                samplingRate = str2double(str(index(1)+1:size(str,2)));
            elseif size(regexp(str,'SmoothingTime1=','end')) ~= 0
                index = regexp(str,'SmoothingTime1=','end') ;
                smoothing_time(1,1) = str2double(str(index(1)+1:size(str,2))) ;
            elseif size(regexp(str,'SmoothingTime2=','end')) ~= 0
                index = regexp(str,'SmoothingTime2=','end') ;
                smoothing_time(1,2) = str2double(str(index(1)+1:size(str,2))) ;
            elseif size(regexp(str,'BSSTime=','end')) ~= 0
                index = regexp(str,'BSSTime=','end') ;
                bss_time = str2double(str(index(1)+1:size(str,2))) ;
            elseif size(regexp(str,'BSSRise=','end')) ~= 0
                index = regexp(str,'BSSRise=','end') ;
                bss_rise = str2double(str(index(1)+1:size(str,2))) ;
            elseif size(regexp(str,'SweepRange=','end')) ~= 0
                index = regexp(str,'SweepRange=','end') ;
                sweepRange = str(index(1)+1:size(str,2));
            elseif size(regexp(str,'StimsAnalyzed=','end')) ~= 0
                index = regexp(str,'StimsAnalyzed=','end') ;
                stimRange = str(index(1)+1:size(str,2));
            elseif size(regexp(str,'invertResults=1','end')) ~= 0
                invertResults = 1;
            end
        end
        
        if nbStims < size(stim,1)
            stim = zeros(nbStims,3);
        end
        
        for i=1:nbStims
            stim(i,1) = str2double(stimBegin{i}) ;
            stim(i,2) = stimDur;
            stim(i,3) = stimExcl;
        end
        
        %begin_spike_smooth = [bss_time, bss_rise] ;
    end
    
    nbSweeps = fileSweepNumbers(ID);
    file_name = char( fileNames{ID} );
    % The sweeps we don't want to be excluded from the analysis
    sweepsToKeep = getSweepRange( sweepRange, nbSweeps );
    sweepsKeptInAllFilesOrdered = [sweepsKeptInAllFilesOrdered, (sweepsToKeep+nbSweepsInAllFilesUntilThisOne)];
    nbSweepsInAllFilesUntilThisOne = nbSweepsInAllFilesUntilThisOne + nbSweeps;
    sweepRange = sort( unique([sweepsToKeep nbSweeps+1 nbSweeps+2]));
    plasticityData{ID} = plasticityData{ID}( :, sweepRange);
    nbSweeps = numel( sweepsToKeep );

    % Hijack getSweepRange to use it for getting the stims we want to
    % analyse
    stimsToAnalyse = getSweepRange( stimRange, nbStims );
    
    % if we need to revert the results in order for ChR to work (some of the experiment have inverted results, du to the
    % diff of potential)
    toDo(12) = invertResults;
 
    % Main computation ; append the new results to the already computed data
    newdata = Code_Calcul_Event_Properties( file_name, plasticityData{ID}, fileSweepSize(ID), nbSweeps, sweepsToKeep, samplingRate, nbStims, stim, stimsToAnalyse, begin_spike_smooth, smoothing_time, analysisTimeWindow, toDo, riseAndDecayThresholds );
    nbSweepRecords = numel(sweepsToKeep);
    nbRecordsAlready = size(sweepsData,1);
    nbFields = size(sweepsData,2);
    for i=1:nbSweepRecords
        for j=1:nbFields
            [sweepsData{nbRecordsAlready+i, j}] = [newdata{i,j}];
        end
    end
    
end

% Compute the times of the sweeps (ie, the date when each sweep begin)
nbSweepsTotal = size( sweepsData, 1 ) - 1; % -1 because of the legend in the table
times = zeros(nbSweepsTotal, 1);
% fill the dates for the x axis : time
indexSweepTotal = 1;
indexSweepInFile = 1;
currentFile = 1;
while indexSweepTotal <= nbSweepsInAllFilesUntilThisOne
    if indexSweepInFile > numel( dataTimeInfo{currentFile,3} ) % we just changed of file 
        currentFile = currentFile+1;
        indexSweepInFile = 1;   % start at the first sweep of the new file
    end
    % Current time = time for the beginning of the file + time of the
    % beginning of the sweep in the file
    currentTime = dataTimeInfo{currentFile,1} + dataTimeInfo{currentFile,3}(indexSweepInFile);
    times(indexSweepTotal) = currentTime;
    % Increment
    indexSweepTotal = indexSweepTotal + 1;
    indexSweepInFile = indexSweepInFile + 1;
end
timesKept = times(sweepsKeptInAllFilesOrdered);

%%%%%%%%%%%%%%%%%%%%%% Time windows for the drugs %%%%%%%%%%%%%%%%%%%%%%%%%
handle = findobj( 'Tag', 'timeWindowsTable' );
timeWindowDrugs = get(handle,'Data');

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the arrays ; if the plotting is not needed, they will stay set to
% 0 and not be plotted at the end (NB : (small) memory wasting)
integrals = zeros(nbSweepsTotal, 3);
amplitudes = zeros(nbSweepsTotal, 3);
risetimes = zeros(nbSweepsTotal, 3);
decaytimes = zeros(nbSweepsTotal, 3);
timetopeaks = zeros(nbSweepsTotal, 3);
perpulseratios = zeros(nbSweepsTotal, 1);
tpulses = zeros(nbSweepsTotal, 2); % Rm and Ra
if toDo(10)  % If Save sweeps is set, we have the sweep data ; otherwise, we don't (NB: not having it would be stupid)
    isAmplitudeToPlot = get( findobj( 'Tag', 'plotAmplitudeDataCheckbox'), 'value');
    isIntegralToPlot = get( findobj( 'Tag', 'plotIntegralDataCheckbox'), 'value');
    isPPRToPlot = get( findobj( 'Tag', 'plotPPRDataCheckbox'), 'value');
    isTTPToPlot = get( findobj( 'Tag', 'plotTTPDataCheckbox'), 'value');
    isRTToPlot = get( findobj( 'Tag', 'plotRTDataCheckbox'), 'value');
    isDTToPlot = get( findobj( 'Tag', 'plotDTDataCheckbox'), 'value');
    % y axis - integrals, for example
    for i=1:nbSweepsTotal
        if isIntegralToPlot
            integrals(i,1) = sweepsData{i+1,1+nbBeforeStimsCols};
            integrals(i,2) = sweepsData{i+1,2+nbBeforeStimsCols};
            integrals(i,3) = sweepsData{i+1,3+nbBeforeStimsCols};
        end
        if isTTPToPlot
            timetopeaks(i,1) = sweepsData{i+1,6+1};
            timetopeaks(i,2) = sweepsData{i+1,6+2};
            timetopeaks(i,3) = sweepsData{i+1,6+3};
        end
        if isRTToPlot
            risetimes(i,1) = sweepsData{i+1,6+nbStims+1};
            risetimes(i,2) = sweepsData{i+1,6+nbStims+2};
            risetimes(i,3) = sweepsData{i+1,6+nbStims+3};
        end
        if isDTToPlot
            decaytimes(i,1) = sweepsData{i+1,6+2*nbStims+1};
            decaytimes(i,2) = sweepsData{i+1,6+2*nbStims+2};
            decaytimes(i,3) = sweepsData{i+1,6+2*nbStims+3};
        end
        if isAmplitudeToPlot
            amplitudes(i,1) = sweepsData{i+1,6+3*nbStims+1};
            amplitudes(i,2) = sweepsData{i+1,6+3*nbStims+2};
            amplitudes(i,3) = sweepsData{i+1,6+3*nbStims+3};
        end
        if isPPRToPlot
            perpulseratios(i) = sweepsData{i+1,2*nbStims+nbBeforeStimsCols+1};
        end
        if isempty( sweepsData{i+1,6} ) % The cell in the results is empty (*not* set to 0) if the analysis on test pulse has not been done
            tpulses(i, 1) = 0;
            tpulses(i, 2) = 0;
        else
            tpulses(i, 1) = sweepsData{i+1,5};	% Rm
            tpulses(i, 2) = sweepsData{i+1,6};	% Ra
        end
    end
    
    % Now, are the things to plot really worth the plotting ? (ie, was the
    % analysis successful ?)
    isTPulseToPlot = std(tpulses(:)) > 0; % otherwise, this characteristic is probably disabled and so uniformously equal to 0 or -1
    isPPRToPlot = std(perpulseratios(:)) > 0;
    somethingHasBeenPlotted = 0; % Useful to see if we have already plotted something : indeed, the PPR must be plotted if it's checked, even if nothing else is ;
    % but if we plot something for stim 1 and stm 2, then PPR will have
    % been plotted amongst those things, and we won't make a plot only with
    % the PPR for sim 3
    for k=1:nbStims
        isIntegralToPlot = std(integrals(:,k)) > 0; % otherwise, this stim's characteristic is probably disabled and so uniformously equal to 0 or -1
        isAmplitudeToPlot = std(amplitudes(:,k)) > 0;
        isRTToPlot = std(risetimes(:,k)) > 0;
        isDTToPlot = std(decaytimes(:,k)) > 0;
        isTTPToPlot = std(timetopeaks(:,k)) > 0;
        toPlot = isAmplitudeToPlot|isIntegralToPlot|isTTPToPlot|isRTToPlot|isDTToPlot;    % Don't add test pulse, it's just an indicator to see if the other results can be trusted
        % and don't add isPPRToPlot, because PPR s not something specific
        % to the stim : it only will be added if other stim characteristics
        % are plotted (unless nothing is plotted at all for any stim, cf.
        % below)
        if ~somethingHasBeenPlotted && k == nbStims
            % Last chance to plot non-stim-dependent stuff, like PPR
            toPlot = isPPRToPlot;
        end

        if toPlot
            somethingHasBeenPlotted = 1;
            plotHandles = [];
            plotLegends = [];
            plotWhereToPlotDrugInfoHandle = 0; % Will store the handle of the plot on which the time info for the drugs will be plotted
            nbPlots = isIntegralToPlot + isAmplitudeToPlot + isPPRToPlot + isTTPToPlot + isRTToPlot + isDTToPlot + isTPulseToPlot;
            figure;
            hold on;
            currPlot = 1;
            if isAmplitudeToPlot
                subplot( nbPlots, 1, currPlot );
                currPlot = currPlot + 1;
                h = plot( timesKept, amplitudes(:,k), '-om' );
                    plotHandles = [plotHandles, h];
                    plotLegends{end+1} = sprintf('Amplitude (stim #%i)', k);
                ylabel('I [pA]') ;
                xlabel([ plotLegends{end}, '  -  t [ms]'] ) ;
                plotWhereToPlotDrugInfoHandle = currPlot - 1;
            end
            if isIntegralToPlot
                subplot( nbPlots, 1, currPlot );
                currPlot = currPlot + 1;
                h = plot( timesKept, integrals(:,k), '-+k' );
                    plotHandles = [plotHandles, h];
                    plotLegends{end+1} = sprintf('Integral (stim #%i)', k);
                ylabel('[pA.s]') ;
                xlabel([ plotLegends{end}, '  -  t [ms]'] ) ;
                if plotWhereToPlotDrugInfoHandle == 0
                    plotWhereToPlotDrugInfoHandle = currPlot - 1;
                end
            end
            if isTTPToPlot
                subplot( nbPlots, 1, currPlot );
                currPlot = currPlot + 1;
                h = plot( timesKept, timetopeaks(:,k), '-og' );
                    plotHandles = [plotHandles, h];
                    plotLegends{end+1} = sprintf('Time-To-Peak (stim #%i)', k);
                ylabel('t [ms]') ;
                xlabel([ plotLegends{end}, '  -  t [ms]'] ) ;
                if plotWhereToPlotDrugInfoHandle == 0
                    plotWhereToPlotDrugInfoHandle = currPlot - 1;
                end
            end
            if isDTToPlot
                subplot( nbPlots, 1, currPlot );
                currPlot = currPlot + 1;
                h = plot( timesKept, decaytimes(:,k), '-ob' );
                    plotHandles = [plotHandles, h];
                    plotLegends{end+1} = sprintf('Decay Time (stim #%i)', k);
                ylabel('t [ms]') ;
                xlabel([ plotLegends{end}, '  -  t [ms]'] ) ;
                if plotWhereToPlotDrugInfoHandle == 0
                    plotWhereToPlotDrugInfoHandle = currPlot - 1;
                end
            end
            if isRTToPlot
                subplot( nbPlots, 1, currPlot );
                currPlot = currPlot + 1;
                h = plot( timesKept, risetimes(:,k), '-ok' );
                    plotHandles = [plotHandles, h];
                    plotLegends{end+1} = sprintf('Rise Time (stim #%i)', k);
                ylabel('t [ms]') ;
                xlabel([ plotLegends{end}, '  -  t [ms]'] ) ;
                if plotWhereToPlotDrugInfoHandle == 0
                    plotWhereToPlotDrugInfoHandle = currPlot - 1;
                end
            end
            if isPPRToPlot
                subplot( nbPlots, 1, currPlot );
                currPlot = currPlot + 1;
                h = plot( timesKept, perpulseratios(:), '-ok' );
                    plotHandles = [plotHandles, h];
                    plotLegends{end+1} = strPPR;
                ylabel('PPR') ;
                xlabel([ plotLegends{end}, '  -  t [ms]'] ) ;
                if plotWhereToPlotDrugInfoHandle == 0
                    plotWhereToPlotDrugInfoHandle = currPlot - 1;
                end
            end
            if isTPulseToPlot    % otherwise, this stim is probably disabled and uniformously equal to 0
                subplot( nbPlots, 1, currPlot );
                currPlot = currPlot + 1;
                % Two y-axis, one by curve
                [ax, h1, h2] = plotyy( timesKept, tpulses(:, 1), timesKept, tpulses(:, 2) );
                    plotHandles = [plotHandles, h1];
                    plotLegends{end+1} = 'Test Pulse (Rm)';
                    set(h1,'LineStyle','-', 'Marker','o', 'Color','r');
                    set(get(ax(1),'Ylabel'),'String', 'Rm [M\Omega]'); % ylabel
                    plotHandles = [plotHandles, h2];
                    plotLegends{end+1} = 'Test Pulse (Ra)';
                    set(h2,'LineStyle','-', 'Marker','o', 'Color','b');
                    set(get(ax(2),'Ylabel'),'String', 'Ra [M\Omega]'); % ylabel
                xlabel([ plotLegends{end}, '  -  t [ms]'] ) ;
            end

            legend( plotHandles, plotLegends );
            mtit( sprintf('Results for stim #%i', k) );
            
                %% Plot the drugs time info
                subplot( nbPlots, 1, plotWhereToPlotDrugInfoHandle );
                hold on;
                ylimits = get( gca, 'YLim' );
                for i=1:size(timeWindowDrugs, 1)
                    if timeWindowDrugs{i,3} > 0
                        drugLegend = sprintf( '%s', timeWindowDrugs{i,1} );
                        h = area( [timeWindowDrugs{i,2} timeWindowDrugs{i,3}], [ylimits(2) ylimits(2)], 'DisplayName', drugLegend, 'FaceColor', 'none' );
                        set( h, 'BaseValue', ylimits(1) );
                        h = text( timeWindowDrugs{i,2}, ylimits(2)+0.05*(ylimits(2)-ylimits(1)), drugLegend, 'FontSize', 8 );
                    end
                end
                hold off;
        else
            display( sprintf('Nothing to plot for stim #%i', k) );
        end
    end
end


% Test : Check the time distribution
%figure;
%hold on;
%plot( timesKept, timesKept, 'ok', 'DisplayName', 'Integral (stim #1)' );

%%%%%%%%%%%%%%% Add the "date" column to the data %%%%%%%
columnTime = cell( size(sweepsData,1), 1 );
columnTime(2:end) = num2cell(timesKept);
columnTime{1} = 'Date of beginning';
sweepsData = horzcat(columnTime, sweepsData);

%%%%%% Saving to the workspace %%%%%%%%%%%%%%%%%%%%%%%%%%
if toDo(10)  % Save sweeps
    display('--- saving ... ---') ;
    
    % Creates a valid variable name different from any existing variable
    % name (which are listed in 'who'), and based on the string stored in
    % 'save_name'  : to_save contains a string
    to_save = genvarname(save_name, who) ;
    % Copy the content of data_to_save into a variable named after that
    % string
    eval([to_save ' = sweepsData;']);
    
    save_path = strcat(save_path, save_name) ;
    % Now, save the content of this newly created variable to the file.
    % We could just have written 
    %       display( sprintf( 'Saved to "%s.mat"', 'data_to_save') ) ;
    % but then the title in the saved matlab datasheet would have been
    % "data_to_save" instead of "ChR_GB_save_test", which is clearer
    save(save_path, to_save) ;
    display( sprintf( 'Saved to "%s.mat"', save_path) ) ;
    
    % Put result into the workspace
    display('registering result (sweeps) in the workspace ...') ;
    assignin( 'base', to_save, sweepsData );
end

display('Done !');


function notesAboutSettingsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to notesAboutSettingsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of notesAboutSettingsEdit as text
%        str2double(get(hObject,'String')) returns contents of notesAboutSettingsEdit as a double


% --- Executes during object creation, after setting all properties.
function notesAboutSettingsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notesAboutSettingsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in saveSettingsButton.
function saveSettingsButton_Callback(hObject, eventdata, handles)
% Get the filednames in GUI (ie, the GUI controls' name)
guiControls = fieldnames(handles);
% For each of them, if it's an edit box, save its value
% NB : sicne the settings panel only contains edit boxes, we don't
% deal with checkboxes and radio buttons
for i=1:numel(guiControls)
    idControl = findobj( 'Tag', guiControls{i});
    %idControl = handles.(guiControls{i});
    if strcmp( get( idControl, 'Type'), 'uicontrol' )
        if strcmp( get( idControl, 'Style'), 'edit' )
            state.(guiControls{i}) = get( idControl, 'string');
        end
    end
end
% Save the config
filenameSettings = ['matlabPlasticityGUIConfigSave_', date, '.mat'];
save( filenameSettings, 'state' );
% Tell everyone !
set( findobj( 'Tag', 'detailsConfigEdit'), 'string', sprintf( 'Settings successfully saved to "%s"', filenameSettings ) );
display( sprintf( '-- Settings successfully saved to "%s"', filenameSettings ) );


% --- Executes on button press in loadSettingsButton.
function loadSettingsButton_Callback(hObject, eventdata, handles)
[filenameSettings, path] = uigetfile( 'matlabPlasticityGUIConfigSave_*.mat', 'Sélectionnez le fichier de configuration' );
try
    % Load the values in a variable
    load( fullfile(path, filenameSettings) , 'state' );
    % And restore them to the GUI
    guiControls = fieldnames(handles);
    for i=1:numel(guiControls)
        idControl = findobj( 'Tag', guiControls{i});
        %idControl = handles.(guiControls{i});
        if strcmp( get( idControl, 'Type'), 'uicontrol' )
            if strcmp( get( idControl, 'Style'), 'edit' )
                set( idControl, 'string', state.(guiControls{i}) );
            end
        end
    end
    set( findobj( 'Tag', 'detailsConfigEdit'), 'string', sprintf( 'Settings successfully loaded from "%s"', filenameSettings ) );
    display( sprintf( '-- Settings successfully loaded from "%s"', filenameSettings ) );
catch me
    errordlg( me.message );
    set( findobj( 'Tag', 'detailsConfigEdit'), 'string', sprintf( 'Unable to load the config file "%s". Make sure it does exist within the PATH', filenameSettings ) );
end

function detailsConfigEdit_Callback(hObject, eventdata, handles)
% hObject    handle to detailsConfigEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of detailsConfigEdit as text
%        str2double(get(hObject,'String')) returns contents of detailsConfigEdit as a double


% --- Executes during object creation, after setting all properties.
function detailsConfigEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to detailsConfigEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveSweepsCheckbox.
function saveSweepsCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to saveSweepsCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveSweepsCheckbox


% --- Executes on button press in browseFolderSavePath.
function browseFolderSavePath_Callback(hObject, eventdata, handles)
% Default value : previous value
temp = findobj( 'Tag', 'folderSavePathEdit' );
save_path = get(temp, 'string') ;
directoryname = uigetdir( save_path, 'Pick a Directory');
if directoryname ~= 0
    % Add the trailing "/" and set the new path in the input box
    directoryname = strcat( directoryname, filesep() );
    set( temp, 'string', directoryname );
end


% --- Executes on button press in browseFolderRawDataPath.
function browseFolderDataPath_Callback(hObject, eventdata, handles)
% Default value : previous value
temp = findobj( 'Tag', 'folderDataPathEdit' );
rawdata_path = get(temp, 'string') ;
directoryname = uigetdir( rawdata_path, 'Pick a Directory');
if directoryname ~= 0
    % Add the trailing "/" and set the new path in the input box
    directoryname = strcat( directoryname, filesep() );
    set( temp, 'string', directoryname );
end


% --- Executes on button press in browseFolderListFilesPath.
function browseFileListFullPath_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% Default value : previous value
temp = findobj( 'Tag', 'fileListFullPathEdit' );
filelist_path = get(temp, 'string') ;
[filename,directoryname] = uigetfile('*.txt','Select the index file',filelist_path) ;
if directoryname ~= 0
    % set the new path in the input box
    directoryname = strcat( directoryname, filename );
    set( temp, 'string', directoryname );
end

% If we want PPR, we must do the analysis on the required stims
function stim2over1RadioButton_Callback(hObject, eventdata, handles)
    set( findobj( 'Tag', 'analyzeStim2' ), 'value', 1 );
    set( findobj( 'Tag', 'analyzeStim1' ), 'value', 1 );
  
% If we want PPR, we must do the analysis on the required stims
function changePPROption_Callback(hObject, eventdata, handles)
    if get( findobj( 'Tag', 'pprAnalysisCheckbox'), 'value')
        if get( findobj( 'Tag', 'stim2over1RadioButton'), 'value')
            set( findobj( 'Tag', 'analyzeStim2' ), 'value', 1 );
            set( findobj( 'Tag', 'analyzeStim1' ), 'value', 1 );
        else
            set( findobj( 'Tag', 'analyzeStim3' ), 'value', 1 );
            set( findobj( 'Tag', 'analyzeStim2' ), 'value', 1 );
        end
    end

function folderSavePathEdit_Callback(hObject, eventdata, handles)
% hObject    handle to folderSavePathEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of folderSavePathEdit as text
%        str2double(get(hObject,'String')) returns contents of folderSavePathEdit as a double



function saveResultsFilenameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to saveResultsFilenameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of saveResultsFilenameEdit as text
%        str2double(get(hObject,'String')) returns contents of saveResultsFilenameEdit as a double


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function browseFolderSavePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to browseFolderSavePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function loadDataButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function fileListFullPathEdit_Callback(hObject, eventdata, handles)
% hObject    handle to fileListFullPathEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileListFullPathEdit as text
%        str2double(get(hObject,'String')) returns contents of fileListFullPathEdit as a double



function folderDataPathEdit_Callback(hObject, eventdata, handles)
% hObject    handle to folderDataPathEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of folderDataPathEdit as text
%        str2double(get(hObject,'String')) returns contents of folderDataPathEdit as a double


% Display the threshold gradient for peak detection
function displayThresholdGradient()
    dx = str2double( get( findobj( 'Tag', 'deltaXEdit' ), 'string' ) );
    dy = str2double( get( findobj( 'Tag', 'deltaYEdit' ), 'string' ) );
    if dx == 0
        dx = 10^(-99);
    end
    gradient = dy/dx;
    set( findobj( 'Tag', 'slopeThresholdText' ), 'String', sprintf( 'dx/dy : %g', gradient ) );
    
function deltaXEdit_Callback(hObject, eventdata, handles)
    displayThresholdGradient();
    
function deltaYEdit_Callback(hObject, eventdata, handles)
    displayThresholdGradient();
    


% --- Executes on button press in analyzeStim1.
function analyzeStim1_Callback(hObject, eventdata, handles)
% hObject    handle to analyzeStim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analyzeStim1


% --- Executes on button press in analyzeStim2.
function analyzeStim2_Callback(hObject, eventdata, handles)
% hObject    handle to analyzeStim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analyzeStim2


% --- Executes on button press in analyzeStim3.
function analyzeStim3_Callback(hObject, eventdata, handles)
% hObject    handle to analyzeStim3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analyzeStim3


% --- Executes on button press in plotIntegralDataCheckbox.
function plotIntegralDataCheckbox_Callback(hObject, eventdata, handles)
    % If checked, the integral analysis must be run
    if get( findobj( 'Tag', 'plotIntegralDataCheckbox'), 'value')
        set( findobj( 'Tag', 'integralAnalysisCheckbox'), 'value', 1 );
        set( findobj( 'Tag', 'integralAnalysisCheckbox'), 'Enable', 'off' );
    else
       set( findobj( 'Tag', 'integralAnalysisCheckbox'), 'Enable', 'on' );
    end


function plotPPRDataCheckbox_Callback(hObject, eventdata, handles)
    % If checked, the PPR analysis must be run
    if get( findobj( 'Tag', 'plotPPRDataCheckbox'), 'value')
        set( findobj( 'Tag', 'pprAnalysisCheckbox'), 'value', 1 );
        set( findobj( 'Tag', 'pprAnalysisCheckbox'), 'Enable', 'off' );
    else
       set( findobj( 'Tag', 'pprAnalysisCheckbox'), 'Enable', 'on' );
    end
    

function plotDTDataCheckbox_Callback(hObject, eventdata, handles)
    % If checked, the DT analysis must be run
    if get( findobj( 'Tag', 'plotDTDataCheckbox'), 'value')
        set( findobj( 'Tag', 'dtAnalysisCheckbox'), 'value', 1 );
        set( findobj( 'Tag', 'dtAnalysisCheckbox'), 'Enable', 'off' );
    else
       set( findobj( 'Tag', 'dtAnalysisCheckbox'), 'Enable', 'on' );
    end
    
function plotRTDataCheckbox_Callback(hObject, eventdata, handles)
    % If checked, the RT analysis must be run
    if get( findobj( 'Tag', 'plotRTDataCheckbox'), 'value')
        set( findobj( 'Tag', 'rtAnalysisCheckbox'), 'value', 1 );
        set( findobj( 'Tag', 'rtAnalysisCheckbox'), 'Enable', 'off' );
    else
       set( findobj( 'Tag', 'rtAnalysisCheckbox'), 'Enable', 'on' );
    end


% --- Executes during object creation, after setting all properties.
function plotDataCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotDataCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in dtAnalysisCheckbox.
function dtAnalysisCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to dtAnalysisCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dtAnalysisCheckbox


% --- Executes on button press in rtAnalysisCheckbox.
function rtAnalysisCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to rtAnalysisCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rtAnalysisCheckbox


% --- Executes on button press in testPulseAnalysisCheckbox.
function testPulseAnalysisCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to testPulseAnalysisCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of testPulseAnalysisCheckbox


% --- Executes on button press in integralAnalysisCheckbox.
function integralAnalysisCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to integralAnalysisCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of integralAnalysisCheckbox



function timeWindowStartEdit_Callback(hObject, eventdata, handles)
% hObject    handle to timeWindowStartEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeWindowStartEdit as text
%        str2double(get(hObject,'String')) returns contents of timeWindowStartEdit as a double



function timeWindowEndEdit_Callback(hObject, eventdata, handles)
% hObject    handle to timeWindowEndEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeWindowEndEdit as text
%        str2double(get(hObject,'String')) returns contents of timeWindowEndEdit as a double


% --- Executes on button press in plotAmplitudeDataCheckbox.
function plotAmplitudeDataCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to plotAmplitudeDataCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotAmplitudeDataCheckbox


% --- Executes on button press in plotTTPDataCheckbox.
function plotTTPDataCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to plotTTPDataCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotTTPDataCheckbox


% --- Executes on button press in convertASCIIToMat.
function convertASCIIToMat_Callback(hObject, eventdata, handles)
% Loads the data (first tab)
handle = findobj( 'Tag', 'folderDataPathEdit' );
folderDataPath = get( handle, 'string' );
handle = findobj( 'Tag', 'fileListFullPathEdit' );
fileListFullPath = get( handle, 'string');
try
    convertASCIIDataToMAT( folderDataPath, fileListFullPath );
     msgbox( 'Data converted and saved in the path' );
     display( '--- Data converted and saved in the path' );
catch me
    display( '----------------------' );
    display( me.message );
    display( '----------------------' );
end