function reslt = keepOnlySelectedSweeps( statusSweepArray, dataSweepArray )
% Takes the array from Sweep_Selection (statusSweepArray), and the saved data from
% ChR_evoked_events_analysis (dataSweepArray), and outputs only the valid data.
% The 3rd column of statusSweepArray is a vector of 0 and 1 defining the
% status of the rows/sweeps in dataSweepArray (valid or invalid)

    nbSweeps = size(dataSweepArray, 1);
    if size(statusSweepArray, 1) ~= nbSweeps
        display( 'Error : data section and data array do not have the same number of sweeps' );
        return;
    end
    selectedRows = statusSweepArray(2:end,3); % The 1st component of the vector is the title, skip it
    selectedRows = [1;cell2mat(selectedRows)]; % but now, add a 1, because we want to keep the title in dataSweepArray
    dataSweepArray(selectedRows == 0,:)=[ ];
    display( '---' );
    display( sprintf(' Keeping %d sweeps (from %d), after selection.', size(dataSweepArray,1)-1, nbSweeps-1) ); % "-1" is for the title
    reslt = dataSweepArray;
end

