function range = getSweepRangeFromSelectionMatrix( statusSweepArray )
% Takes the array from Sweep_Selection (statusSweepArray) and outputs only the range of sweep numbers selected.
% The 3rd column of statusSweepArray is a vector of 0 and 1 defining the
% status of the rows/sweeps in dataSweepArray (valid or invalid)

    nbSweeps = size(statusSweepArray, 1);
    selectedRows = statusSweepArray(2:end,2:3); % The 1st component of the vector is the title, skip it : rpws from 2 to 'end'
    selectedRows = cell2mat(selectedRows);
    selectedRows = selectedRows( find( selectedRows(:,2) == 1 ), 1 );    % Only keep the sweep numbers
    format = '';
    for i=1:numel(selectedRows)-1
        format = strcat( format, '%d;' );
    end
    format = strcat( format, '%d' );
    range = sprintf( format, selectedRows );
end