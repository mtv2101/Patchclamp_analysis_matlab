function varargout = ChR_evoked_events_analysis1(varargin)
% CHR_EVOKED_EVENTS_ANALYSIS1 M-file for ChR_evoked_events_analysis1.fig
%      CHR_EVOKED_EVENTS_ANALYSIS1, by itself, creates a new CHR_EVOKED_EVENTS_ANALYSIS1 or raises the existing
%      singleton*.
%
%      H = CHR_EVOKED_EVENTS_ANALYSIS1 returns the handle to a new CHR_EVOKED_EVENTS_ANALYSIS1 or the handle to
%      the existing singleton*.
%
%      CHR_EVOKED_EVENTS_ANALYSIS1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHR_EVOKED_EVENTS_ANALYSIS1.M with the given input arguments.
%
%      CHR_EVOKED_EVENTS_ANALYSIS1('Property','Value',...) creates a new CHR_EVOKED_EVENTS_ANALYSIS1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChR_evoked_events_analysis1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChR_evoked_events_analysis1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChR_evoked_events_analysis1

% Last Modified by GUIDE v2.5 31-May-2010 11:40:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChR_evoked_events_analysis1_OpeningFcn, ...
                   'gui_OutputFcn',  @ChR_evoked_events_analysis1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before ChR_evoked_events_analysis1 is made visible.
function ChR_evoked_events_analysis1_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% Default path
[p1,p2] = matlabPathDependingOnComputer();
temp = getfield(handles, 'save_path_edit') ;
set(temp, 'string', strcat( p1, '/Users/cedric/Desktop/data/slice_ephys')  ) ;
temp = getfield(handles, 'file_list_path_edit') ;
set(temp, 'string', strcat( p2, 'file_list1.txt') );
temp = getfield(handles, 'path_raw_data_edit') ;
set(temp, 'string', strcat( p1, '/Users/cedric/Desktop/data/slice_ephys')  ) ;
temp = getfield(handles, 'single_file_name_edit');
set(temp, 'string', strcat( p1, '/Users/cedric/Desktop/data/slice_ephys' ) );
% Display the threshold gradient for peak detection
displayThresholdGradient( handles );


% --- Outputs from this function are returned to the command line.
function varargout = ChR_evoked_events_analysis1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in OK_pushbutton.
function OK_pushbutton_Callback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to OK_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

display('begin data processing...') ;
% ######################################################## Setting path ###

temp = handles.save_path_edit;
save_path = get(temp, 'string') ;

temp = handles.save_name_edit;
save_name = get(temp, 'string') ;

% #################################################### END Setting path ###



% ###################################################### Configurations ###
temp =  getfield(handles, 'sampling_rate_edit') ;
sampling_rate = str2double(get(temp, 'string')) ;

temp =  handles.stim_nb_edit;
nbStims = str2double(get(temp, 'string')) ;

temp =  handles.bss_time_edit ;
bss_time = str2double(get(temp, 'string')) ;
temp =  handles.bss_rise_edit ;
bss_rise = str2double(get(temp, 'string')) ;
begin_spike_smooth = [bss_time, bss_rise] ;

% Which stims to analyse ? By default, all of them
temp = handles.stim_range;
stimRange = get(temp, 'string') ;
if isempty(stimRange)
    stimRange = sprintf( '1-%d', nbStims );
end


temp =  getfield(handles, 'stim_begin_edit') ;
stimBegin = get(temp, 'string') ;
stimBegin = regexp(stimBegin, '\_', 'split') ;

temp =  getfield(handles, 'stim_dur_edit') ;
stimDur = get(temp, 'string') ;

temp =  getfield(handles, 'stim_excl_edit') ;
stimExcl = get(temp, 'string') ;

stim = zeros(nbStims,3) ;
for i=1:nbStims
    stim(i,1) = str2double( stimBegin{i} ) ;
	stim(i,2) = str2double( stimDur ) ;
	stim(i,3) = str2double( stimExcl ) ;
end

max_min_smooth = zeros(2,2) ;
smoothing_time = zeros(1,2) ;

temp =  getfield(handles, 'smoothing_time_1_edit') ;
smoothing_time(1,1) = str2double(get(temp, 'string')) ;
temp =  getfield(handles, 'smoothing_time_2_edit') ;
smoothing_time(1,2) = str2double(get(temp, 'string')) ;

temp =  getfield(handles, 'begin_window_analysis') ;
analysisTimeWindow(1) = str2double(get(temp, 'string')) ;
temp =  getfield(handles, 'end_window_analysis') ;
analysisTimeWindow(2) = str2double(get(temp, 'string')) ;


% temp = getfield(handles, 'plot_saf_check') ;
% toDo(5) = get(temp, 'value') ;

% temp = getfield(handles, 'plot_max_check') ;
% toDo(6) = get(temp, 'value') ;

% Which sweeps to analyze, which ones to exclude ?
temp = handles.sweep_range;
sweepRange = get(temp, 'string') ;

% Percentage windows for rise and decay time
riseAndDecayThresholds = zeros(4,1);
temp = handles.thres1_rise_time;
riseAndDecayThresholds(1) = str2double( get(temp, 'string') ) / 100.0;
temp = handles.thres2_rise_time;
riseAndDecayThresholds(2) = str2double( get(temp, 'string') ) / 100.0;
temp = handles.thres2_decay_time;   % the highest threshold (100% by default)
riseAndDecayThresholds(3) = str2double( get(temp, 'string') ) / 100.0;
temp = handles.thres1_decay_time;   % the lowest threshold (63% by default)
riseAndDecayThresholds(4) = str2double( get(temp, 'string') ) / 100.0;

temp = handles.list_files_check;
list_files_check = get(temp, 'value') ;

temp = handles.single_file_check;
single_file_check = get(temp, 'value') ;

toDo = zeros(1,11) ;
% Plot options
toDo(1) = get(handles.plot_data_check, 'value') ;
toDo(2) = get(handles.plot_mean_check, 'value') ;
toDo(3) = get(handles.plot_integral_check, 'value') ;
% Analysis options
toDo(4) = get(handles.analyse_peaks, 'value') ;
toDo(5) = get(handles.analyse_integrals, 'value') ;
toDo(6) = get(handles.analyse_ppr, 'value') ;   % Per Pulse Ratio
toDo(7) = get(handles.analyse_rt, 'value') ;    % Rise time
toDo(8) = get(handles.analyse_dt, 'value') ;    % Decay time
toDo(9) = get(handles.analyse_tpulse, 'value'); % Test pulse fit
% Save options
toDo(10) = get(handles.saveall_check, 'value') ;
toDo(11) = get(handles.saveonlymean_check, 'value') ;

% PPR, more detailed
toDo(6) = toDo(6) * ( get( handles.ppr_stim1, 'Value' ) + 2*get( handles.ppr_stim3, 'Value' ) );     % 0 = no ; 1 = stim2/stim1 ; 2 = stim3/stim2


default_config = {sampling_rate, nbStims, stim, max_min_smooth, smoothing_time} ;

% ################################################## END Configurations ###

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% File lists or single file options %%%%%%%%%%
[nbFiles, fileNames, filePaths, fileOptions, fileSweepNumbers] = getFilenamesAndOptions( handles );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if all files of the file list do exist ; otherwise, print an error
% and return. Use the function from checkifFilesExistInDirectory.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if list_files_check == 1
    file_list_path = get( handles.file_list_path_edit, 'string') ;
    display( sprintf( 'Checking that all files from "%s" exist ...', file_list_path ) ) ;
else
    display( sprintf( 'Checking that the data file "%s" exists ...', char(fileNames{1}) ) ) ;
end
[allOK, missingIndex] = checkifFilesExistInDirectory( filePaths );
if allOK == 0
    display( sprintf('Error : missing data file "%s"', char(fileNames{missingIndex})) );
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% searching maximum number of stimulations
max_nbStims = nbStims ;
if single_file_check == 0
    
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

strPPR = 'PPR (disabled)';
if toDo(6) == 1
    strPPR = 'PPR (stim2/stim1)';
elseif toDo(6) == 2
	strPPR = 'PPR (stim3/stim2)';
end
sweepsData{1,2*max_nbStims+nbBeforeStimsCols+1} = strPPR;
meansData = sweepsData; % same structure

% settings & analysis
% Saving default parameters (each loop incrementation, restore them)
stimBegin_default = stimBegin ;
stimDur_default = str2double( stimDur ) ;
stimExcl_default = str2double( stimExcl ) ;
sweepRange_default = sweepRange;
stimRange_default = stimRange;
invertResults = 0;

for ID=1:nbFiles
    display( sprintf('----Treating record %d----', ID) )
    if single_file_check == 0
    
        % re-setting default parameters
        sampling_rate = default_config{1,1} ;
        nbStims = default_config{1,2};
        stim = default_config{1,3} ;
        smoothing_time = default_config{1,5} ;
        stimBegin = stimBegin_default ;
        stimDur = stimDur_default ;
        stimExcl = stimExcl_default ;
        sweepRange = sweepRange_default;
        stimRange = stimRange_default;
        
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
                    sampling_rate = str2double(str(index(1)+1:size(str,2))); 
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
   end 
    
    nbSweeps = fileSweepNumbers(ID);
    file_name = char( fileNames{ID} );
    file_path = char( filePaths{ID} );
    
    display(strcat('loading ''',file_name,'''...')) ;
    raw_data = load(file_path) ;
    display('data loaded') ;
    
    % The sweeps we don't want to be excluded from the analysis
    sweepsToKeep = getSweepRange( sweepRange, nbSweeps );
    
    % Hijack getSweepRange to use it for getting the stims we want to
    % analyse
    stimsToAnalyse = getSweepRange( stimRange, nbStims );
    
    % if we need to revert the results in order for ChR to work (some of the experiment have inverted results, du to the
    % diff of potential)
    toDo(12) = invertResults;
    
    %%%%%%%%%%%%%%%%%%%%% ASCII raw Data file to Data matrix %%%%%%%%%%%%%%%%%%

    [data, sweepSize, nbSweeps] = preteatRawData( raw_data, nbSweeps, sweepsToKeep );

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Main computation ; append the new results to the already computed data
    newdata = Code_Calcul_Event_Properties( file_name, data, sweepSize, nbSweeps, sweepsToKeep, sampling_rate, nbStims, stim, stimsToAnalyse, begin_spike_smooth, smoothing_time, analysisTimeWindow, toDo, riseAndDecayThresholds );
    nbSweepRecords = numel(sweepsToKeep);
    nbRecordsAlready = size(sweepsData,1);
    nbFields = size(sweepsData,2);
    if size(newdata,1)>nbSweeps
        newdata = newdata(1:nbSweeps,:);
    end
    for i=1:nbSweepRecords
        for j=1:nbFields
            [sweepsData{nbRecordsAlready+i, j}] = [newdata{i,j}];
        end
    end
    nbRecordsAlready = size(meansData,1);
    for j=1:nbFields
        [meansData{nbRecordsAlready+1, j}] = [newdata{nbSweepRecords,j}];
    end

end

% Display the result
if toDo(10)
    display( '--- Sweeps ---' );
    display( sweepsData );
end
if toDo(11) 
    display( '--- Means ---' );
    display( meansData );
end

% And save it, if it was asked
if toDo(10)  % Save sweeps
    display('saving...') ;
    
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

if toDo(11)    % Save mean
    %data_to_save_mean
    display('saving...') ;
    
    save_name_mean = strcat(save_name, '_mean');
    to_save = genvarname(save_name_mean, who) ;
    eval([to_save ' = meansData;']);
    save_path = strcat(save_path, save_name_mean ) ;
    save(save_path, to_save) ;
    display( sprintf( 'Saved to "%s.mat"', save_path) ) ;
    
    % Put result into the workspace
    display('registering result (means) in the workspace ...') ;
    assignin( 'base', to_save, meansData );
end


display('Done ! :)') ;
% ########################################### END Analysis of the files ###

function [nbFiles, filenames, filepaths, options, nbSweeps] = getFilenamesAndOptions( handles )
    filenames = cell( 0 );
    filepaths = cell( 0 );
    options = cell( 0 );
    nbSweeps = zeros( 0 );
    nbFiles = 0;

    list_files_check = get( handles.list_files_check, 'value' );
    %single_file_check = get( handles.single_file_check, 'value' );
    data_path = get( handles.path_raw_data_edit, 'string' ) ;
    file_list_path = get( handles.file_list_path_edit, 'string') ;
    file_single_path = get( handles.single_file_name_edit, 'string' ) ;
    %%%%%%%%%%%%%%%%%%%%% reading the file list %%%%%%%%%%%%%%%%%%%%%
    % ex : 20090210_3_07_29_ChR2_GB
     if list_files_check == 1
        if exist( file_list_path, 'file' ) && ~exist( file_list_path, 'dir' )
            fid = fopen(file_list_path);
            fileList = textscan(fid, '%s %s %s %s %s %s %s') ;
            fclose(fid);
        else
            display( sprintf('Error : the file "%s" couldn''t be found', file_list_path) );
            return;
        end  
    else
        % All this is done to use single files and list of files the same way :
        % we create a phony list of only one file, and set the right data_path
        [data_path, file_single_path, ext, versn] = fileparts(file_single_path);
        [data_path, tmp, ext, versn] = fileparts(data_path); % remove the last part of the folder (which is 'expdate' and will be added below
        data_path = strcat( data_path, filesep() );
        fileList = regexp(file_single_path, '\_', 'split') ;
        fileList = {{fileList{1}}, {fileList{2}}, {fileList{3}}, {fileList{4}}, {fileList{5}},  {fileList{6}}, {'-'}};    
    end
    %%%%%%%%%%%%%%%%%%%%% END reading the file list %%%%%%%%%%%%%%%%%%%%%

    % ############################################### Analysis of the files ###
    expdate_cells = fileList{1} ;      % class = cell
    inf1_cells = fileList{2} ;         % class = cell
    inf2_cells = fileList{3} ;         % class = cell
    inf3_cells = fileList{4} ;         % class = cell
    type1_cells = fileList{5} ;        % class = cell
    type2_cells = fileList{6} ;        % class = cell

    nbFiles = numel( expdate_cells ) ;

    filenames = cell( nbFiles, 1 );
    filepaths = cell( nbFiles, 1 );
    options = cell( nbFiles, 1 );
    nbSweeps = zeros( nbFiles, 1 );
    for i = 1:nbFiles
        path = strcat( data_path, expdate_cells{i}, filesep() );
        strfilename = strcat( expdate_cells{i}, '_', inf1_cells{i}, '_', inf2_cells{i}, '_', inf3_cells{i}, '_', type1_cells{i}, '_',type2_cells{i}, '.asc' );
        filenames{i,:} = cellstr( strfilename );
        strfilename = strcat( path, strfilename );
        filepaths{i,:} = cellstr( strfilename );
        options{i, :} = fileList{7}{i};
        nbSweeps(i) = str2double( inf3_cells{i} ) ;
    end


% --- Executes on button press in browseFolderSavePath.
function browseFolderSavePath_Callback(hObject, eventdata, handles)
% Default value : previous value
temp = handles.save_path_edit;
save_path = get(temp, 'string') ;
directoryname = uigetdir( save_path, 'Pick a Directory');
if directoryname ~= 0
    % Add the trailing "/" and set the new path in the input box
    directoryname = strcat( directoryname, filesep() );
    set( temp, 'string', directoryname );
end


% --- Executes on button press in browseFolderRawDataPath.
function browseFolderRawDataPath_Callback(hObject, eventdata, handles)
% Default value : previous value
temp = handles.path_raw_data_edit;
rawdata_path = get(temp, 'string') ;
directoryname = uigetdir( rawdata_path, 'Pick a Directory');
if directoryname ~= 0
    % Add the trailing "/" and set the new path in the input box
    directoryname = strcat( directoryname, filesep() );
    set( temp, 'string', directoryname );
end


% --- Executes on button press in browseFolderListFilesPath.
function browseFileListPath_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% Select the radio button 'file list'
set( handles.list_files_check, 'Value', 1.0 );
% Default value : previous value
temp = handles.file_list_path_edit;
filelist_path = get(temp, 'string') ;
[filename,directoryname] = uigetfile('*.txt','Select the index file',filelist_path) ;
if directoryname ~= 0
    % set the new path in the input box
    directoryname = strcat( directoryname, filename );
    set( temp, 'string', directoryname );
end

% --- Executes on button press in browseDataFilePath.
function browseDataFilePath_Callback(hObject, eventdata, handles)
% Select the radio button 'file list'
set( handles.single_file_check, 'Value', 1.0 );
% Default value : previous value
temp = handles.single_file_name_edit;
filelist_path = get(temp, 'string') ;
[filename,directoryname] = uigetfile('*.asc','Select the index file', filelist_path) ;
if directoryname ~= 0
    % set the new path in the input box
    directoryname = strcat( directoryname, filename );
    set( temp, 'string', directoryname );
end


function save_path_edit_Callback(hObject, eventdata, handles)
% hObject    handle to save_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of save_path_edit as text
%        str2double(get(hObject,'String')) returns contents of save_path_edit as a double


% --- Executes during object creation, after setting all properties.
function save_path_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to save_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function save_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to save_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of save_name_edit as text
%        str2double(get(hObject,'String')) returns contents of save_name_edit as a double


% --- Executes during object creation, after setting all properties.
function save_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to save_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function single_file_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to single_file_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of single_file_name_edit as text
%        str2double(get(hObject,'String')) returns contents of single_file_name_edit as a double


% --- Executes during object creation, after setting all properties.
function single_file_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to single_file_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function path_raw_data_edit_Callback(hObject, eventdata, handles)
% hObject    handle to path_raw_data_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path_raw_data_edit as text
%        str2double(get(hObject,'String')) returns contents of path_raw_data_edit as a double


% --- Executes during object creation, after setting all properties.
function path_raw_data_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path_raw_data_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function file_list_path_edit_Callback(hObject, eventdata, handles)
% hObject    handle to file_list_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_list_path_edit as text
%        str2double(get(hObject,'String')) returns contents of file_list_path_edit as a double


% --- Executes during object creation, after setting all properties.
function file_list_path_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_list_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function smoothing_time_1_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function smoothing_time_2_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sampling_rate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sampling_rate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampling_rate_edit as text
%        str2double(get(hObject,'String')) returns contents of sampling_rate_edit as a double


% --- Executes during object creation, after setting all properties.
function sampling_rate_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampling_rate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function smoothing_time_2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to smoothing_time_2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothing_time_2_edit as text
%        str2double(get(hObject,'String')) returns contents of smoothing_time_2_edit as a double



function smoothing_time_1_edit_Callback(hObject, eventdata, handles)
% hObject    handle to smoothing_time_1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothing_time_1_edit as text
%        str2double(get(hObject,'String')) returns contents of smoothing_time_1_edit as a double



function stim_nb_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function stim_nb_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nbStims_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stim_begin_edit_Callback(hObject, eventdata, handles)
% hObject    handle to stimBegin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stimBegin_edit as text
%        str2double(get(hObject,'String')) returns contents of stimBegin_edit as a double


% --- Executes during object creation, after setting all properties.
function stim_begin_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimBegin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stim_dur_edit_Callback(hObject, eventdata, handles)
% hObject    handle to stimDur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stimDur_edit as text
%        str2double(get(hObject,'String')) returns contents of stimDur_edit as a double


% --- Executes during object creation, after setting all properties.
function stim_dur_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimDur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimExcl_edit_Callback(hObject, eventdata, handles)
% hObject    handle to stimExcl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stimExcl_edit as text
%        str2double(get(hObject,'String')) returns contents of stimExcl_edit as a double


% --- Executes during object creation, after setting all properties.
function stimExcl_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimExcl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bss_rise_edit_Callback(hObject, eventdata, handles)
displayThresholdGradient( handles );


% --- Executes during object creation, after setting all properties.
function bss_rise_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bss_rise_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Display the threshold gradient for peak detection
function displayThresholdGradient( handles )
    dx = str2double( get( handles.bss_time_edit, 'string' ) );
    dy = str2double( get( handles.bss_rise_edit, 'string' ) );
    if dx == 0
        dx = 10^(-99);
    end
    gradient = dy/dx;
    set( handles.slope_dxdy, 'String', sprintf( 'dx/dy : %g', gradient ) );

function bss_time_edit_Callback(hObject, eventdata, handles)
displayThresholdGradient( handles );


% --- Executes during object creation, after setting all properties.
function bss_time_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bss_time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function begin_window_analysis_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function saveall_check_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function stim_excl_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function plot_data_check_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in plot_data_check.
function plot_data_check_Callback(hObject, eventdata, handles)



function stim_excl_edit_Callback(hObject, eventdata, handles)
% hObject    handle to stim_excl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim_excl_edit as text
%        str2double(get(hObject,'String')) returns contents of stim_excl_edit as a double



function sweep_range_Callback(hObject, eventdata, handles)
% hObject    handle to sweepRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Select the radio button 'file list'
set( handles.single_file_check, 'Value', 1.0 );


% --- Executes during object creation, after setting all properties.
function sweep_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sweepRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in analyse_tpulse.
function analyse_tpulse_Callback(hObject, eventdata, handles)
% hObject    handle to analyse_tpulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analyse_tpulse



function thres1_rise_time_Callback(hObject, eventdata, handles)
% hObject    handle to thres1_rise_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres1_rise_time as text
%        str2double(get(hObject,'String')) returns contents of thres1_rise_time as a double


% --- Executes during object creation, after setting all properties.
function thres1_rise_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres1_rise_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thres2_rise_time_Callback(hObject, eventdata, handles)
% hObject    handle to thres2_rise_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres2_rise_time as text
%        str2double(get(hObject,'String')) returns contents of thres2_rise_time as a double


% --- Executes during object creation, after setting all properties.
function thres2_rise_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres2_rise_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thres1_decay_time_Callback(hObject, eventdata, handles)
% hObject    handle to thres1_decay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres1_decay_time as text
%        str2double(get(hObject,'String')) returns contents of thres1_decay_time as a double


% --- Executes during object creation, after setting all properties.
function thres1_decay_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres1_decay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thres2_decay_time_Callback(hObject, eventdata, handles)
% hObject    handle to thres2_decay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres2_decay_time as text
%        str2double(get(hObject,'String')) returns contents of thres2_decay_time as a double


% --- Executes during object creation, after setting all properties.
function thres2_decay_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres2_decay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_mean_check.
function plot_mean_check_Callback(hObject, eventdata, handles)
% hObject    handle to plot_mean_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_mean_check


% --- Executes on button press in plot_integral_check.
function plot_integral_check_Callback(hObject, eventdata, handles)
doIntegralAnalysis = get(handles.analyse_integrals, 'value') ;
isPlotChecked = get( handles.plot_integral_check, 'Value' );
if ~doIntegralAnalysis && isPlotChecked
    set( handles.analyse_integrals, 'value', 1 );
    warndlg( 'To plot integral data, the integral analysis must be done.' );
end


% --- Executes on button press in analyse_rt.
function analyse_rt_Callback(hObject, eventdata, handles)
% hObject    handle to analyse_rt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analyse_rt


% --- Executes on button press in analyse_dt.
function analyse_dt_Callback(hObject, eventdata, handles)
% hObject    handle to analyse_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analyse_dt


% --- Executes on button press in analyse_peaks.
function analyse_peaks_Callback(hObject, eventdata, handles)
% hObject    handle to analyse_peaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analyse_peaks


% --- Executes on button press in analyse_integrals.
function analyse_integrals_Callback(hObject, eventdata, handles)
doIntegralAnalysis = get(handles.analyse_integrals, 'value') ;
isPlotChecked = get( handles.plot_integral_check, 'Value' );
if ~doIntegralAnalysis && isPlotChecked
    set( handles.plot_integral_check, 'value', 1 );
    warndlg( 'To plot integral data, the integral analysis must be done.' );
end


% --- Executes on button press in analyse_ppr.
function analyse_ppr_Callback(hObject, eventdata, handles)
% hObject    handle to analyse_ppr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analyse_ppr



function stim_range_Callback(hObject, eventdata, handles)
% hObject    handle to stim_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim_range as text
%        str2double(get(hObject,'String')) returns contents of stim_range as a double


% --- Executes during object creation, after setting all properties.
function stim_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function end_window_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to end_window_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_window_analysis as text
%        str2double(get(hObject,'String')) returns contents of end_window_analysis as a double


% --- Executes during object creation, after setting all properties.
function end_window_analysis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_window_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function begin_window_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to begin_window_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of begin_window_analysis as text
%        str2double(get(hObject,'String')) returns contents of begin_window_analysis as a double
