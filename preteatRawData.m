function [pretreatedData, sweepSize, newNbSweeps, timeBeginSweep] = preteatRawData( rawData, nbSweeps, sweepsToKeep )
% Reorganize raw data (sweeps one after another) in a matrix (lines =
% indexes of the measures, columns = sweeps)
% The last column is for the date of each measure, the one before is for
% the mean sweep.

% PRETREATMENT transfer from ASCII raw Data file to Data matrix (one column
% per sweep + 2)
display('----- begin data pre-treatment...') ;

[nbLinesRD, nbColumnsRD] = size( rawData );

sweepSize = nbLinesRD/nbSweeps ;
pretreatedData = zeros( sweepSize, nbSweeps+2 );

if int32(sweepSize) ~= sweepSize
    display('Error : sweeps have not all the same length');
    return;
else
    sweepSize = int32(sweepSize) ;
end


% alignement des sweeps en colonne
timeBeginSweep = zeros(nbSweeps,1);
for i=1:nbSweeps
    sweepStart = (i-1)*sweepSize+1 ;
    sweepEnd = i*sweepSize ;
    timeBeginSweep(i) = rawData(sweepStart, 2)*1e3;
    pretreatedData(1:sweepSize,i) = rawData(sweepStart:sweepEnd ,3) * 1e12 ;  % in pA
end

% avant derniere colonne (nb_sweep+1) = moyenne
pretreatedData(:, nbSweeps+1) = mean(pretreatedData(:,sweepsToKeep),2);

% derniere colonne (nb_sweep+2) = temps
pretreatedData(1:sweepSize, nbSweeps+2) = rawData(1:sweepSize,2)*1e3 ;  % en ms

% only keeping the sweeps we want
sweepRange = sort( unique([sweepsToKeep nbSweeps+1 nbSweeps+2]));
pretreatedData = pretreatedData( :, sweepRange);
newNbSweeps = numel( sweepsToKeep );


display('----- transfer from ASCII raw Data file to Data matrix (one column per sweep + 2) done')

end