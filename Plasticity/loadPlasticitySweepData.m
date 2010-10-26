function loadPlasticitySweepData( folderDataPath, fileListFullPath, figureHandle )
% Load the raw data from the file list and pretreat it (organize it in
% sweeps). Throws an exception if the data file is not found.
    
    % Opens the file list and retrieve all options about data files by
    % parsing their names
    [nbFiles, fileNames, fileBeginnings, filePaths, options, fileSweepNumbers] = getFilenamesAndOptions( folderDataPath, fileListFullPath );
    % The cell containing, for every file, the sweep data :
    %   data{fileIndex}(timeIndex, sweepIndex)
    data = cell( nbFiles, 1 );
    
    % Table containing the sweep size
    sweepSize = zeros( nbFiles, 1 );
    
    % Cell containing the array with, for each sweeps, the date of
    % beginning
    timeBeginSweeps = cell( nbFiles, 1 );

    % Load the data
    for i=1:nbFiles
        filename = char( fileNames{i} );
        filepath = char( filePaths{i} );
        
        if ~( exist( filepath, 'file' ) && ~exist( filepath, 'dir' ) )
            errString = sprintf('Error : the file "%s" (%s) couldn''t be found', filename, filepath);
            warndlg( errString );
            ME = MException( 'MATLAB:FileNotFound', errString );
            throw(ME);
        end
        
        % Don't filter the sweeps
        sweepsToKeep = 1:fileSweepNumbers(i);

        display(strcat('loading ''', filename, '''...')) ;
            rawData = load( filepath ) ;
            rawData = rawData.rawData; % change, to use .mat format
        display('data loaded') ;
        
        %%%%%%%%%%%%%%%%%%%%% ASCII raw Data file to Data matrix %%%%%%%%%%%%%%%%%%
        % nbSweeps will now contain the number of sweeps actually treated
        % (taking "sweepsToKeep" into account) : here, nbSweeps remains the
        % same since sweepsToKeep = 1:nbSweeps
        [data{i}, sweepSize(i), fileSweepNumbers(i), timeBeginSweeps{i}] = preteatRawData( rawData, fileSweepNumbers(i), sweepsToKeep );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end
    display( sprintf('--- Loaded %d files into workspace ---', nbFiles) );
    
    % Informations about the times (beginning and end) of the files, and
    % the dates of each sweep in the file
    dataTimeInfo = cell( nbFiles, 3 );
    for i=1:nbFiles
        dataTimeInfo{i,1} = fileBeginnings(i);  % in milliseconds !
        dataTimeInfo{i,2} = fileBeginnings(i) + (timeBeginSweeps{i}(end) + sweepSize(i));  % in milliseconds
        dataTimeInfo{i,3} = timeBeginSweeps{i};
    end
    
    % Save the data
    assignin( 'base', 'plasticityFileSweepNumbers', fileSweepNumbers ); 
    assignin( 'base', 'plasticityFileSweepSizes', sweepSize ); 
    assignin( 'base', 'plasticityFileListNames', fileNames );
    assignin( 'base', 'plasticityFileListOptions', options );
    assignin( 'base', 'plasticityDataTimeInfo', dataTimeInfo );
    assignin( 'base', 'plasticityData', data );
    
    % Plot the data
    display( '--- Plotting in preview window ---' );
    display( '----- one sweep by file, translated to time 0' );
    axes( figureHandle ); % make the preview axes the current ones
    cla; % clear figure
    for i=1:nbFiles
        % In order to see something, we translate all the sweeps to make
        % them start at 0
        hold on,plot( data{i}( :, fileSweepNumbers(i)+2 ) - data{i}( 1, fileSweepNumbers(i)+2 ), data{i}( :, fileSweepNumbers(i) ) );
    end
    display( '--- Preview plotting done ---' );

end

function [nbFiles, filenames, filebeginnings, filepaths, options, nbSweeps] = getFilenamesAndOptions( folderDataPath, fileListFullPath )
    filenames = cell( 0 );
    filebeginnings = zeros( 0 );
    filepaths = cell( 0 );
    options = cell( 0 );
    nbSweeps = zeros( 0 );
    nbFiles = 0;

    %%%%%%%%%%%%%%%%%%%%% reading the file list %%%%%%%%%%%%%%%%%%%%%
    % ex : 20090210_3_07_29_ChR2_GB
        if exist( fileListFullPath, 'file' ) && ~exist( fileListFullPath, 'dir' )
            fid = fopen(fileListFullPath);
            fileList = textscan(fid, '%s %s %s %s %s %s %s %s' ) ; 
            % Un champ de plus que dans les autres scripts :
            % la date de début de l'enregistrement, en ms (dernier champ)
            % 20090126	3	07	28	ChR2	GB	-   123213432
            fclose(fid);
%             if numel(fileList{1}) ~= numel(fileList{8}) % problem with the file : invalid format (missing fields)
%                 errString = sprintf('Error : the file "%s" was ill-formed', fileListFullPath);
%                 warndlg( errString );
%                 ME = MException( 'MATLAB:WrongFormat', errString );
%                 throw(ME);
%             end
        else
            errString = sprintf('Error : the file "%s" couldn''t be found', fileListFullPath);
            warndlg( errString );
            ME = MException( 'MATLAB:FileNotFound', errString );
            throw(ME);
        end  
    %%%%%%%%%%%%%%%%%%%%% END reading the file list %%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%% Analysis of the file names %%%%%%%%%%%%%%%%%%%%%
    expdate_cells = fileList{1} ;      % class = cell : folder (and date)
    inf1_cells = fileList{2} ;         % class = cell
    inf2_cells = fileList{3} ;         % class = cell
    inf3_cells = fileList{4} ;         % class = cell : number of sweeps in the file
    type1_cells = fileList{5} ;        % class = cell
    type2_cells = fileList{6} ;        % class = cell

    nbFiles = numel( expdate_cells ) ;

    filenames = cell( nbFiles, 1 );
    filebeginnings = zeros( nbFiles, 1 );
    filepaths = cell( nbFiles, 1 );
    options = cell( nbFiles, 1 );
    nbSweeps = zeros( nbFiles, 1 );
    for i = 1:nbFiles
        path = strcat( folderDataPath, expdate_cells{i}, filesep() );
        strfilename = strcat( expdate_cells{i}, '_', inf1_cells{i}, '_', inf2_cells{i}, '_', inf3_cells{i}, '_', type1_cells{i}, '_',type2_cells{i}, '.asc' );
        strfilename = strrep(strfilename, '.asc', '.mat'); % added to handle the case of .mat files
        filenames{i,:} = cellstr( strfilename );
        strfilename = strcat( path, strfilename );
        filebeginnings(i) = str2double( fileList{8}{i} ) ;
        filepaths{i,:} = cellstr( strfilename );
        options{i, :} = fileList{7}{i};
        nbSweeps(i) = str2double( inf3_cells{i} ) ;
    end
end
