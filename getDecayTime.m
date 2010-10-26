function [iStart, iEnd, decayTime, amplitude] = getDecayTime( data, nbSweep, baseLine, indexPeak, indexEnd, percentBegin, percentEnd, samplingRate )
% Compute the time between the date we are at 'percentBegin' % of the max
% value (which is the value at indexPeak, minus the baseLine) and the date
% we are at 'percentEnd' % of the max value, considering only points
% between 'indexBegin' and 'indexPeak', for the sweep 'nbSweep'

    decayTime = 0;
    iStart = 0;
    iEnd = 0;
    amplitude = 0;
    
    % fprintf( 'Decay time between %.2f and %.2f\n', percentBegin, percentEnd );
    
    if indexPeak > size(data, 1) || indexEnd > size(data, 1) || nbSweep > size(data, 2)
        display( 'Invalid parameters for getDecayTime()' );
        return;
    elseif indexPeak <= 0
        return;
    end

    maxValue = data( indexPeak, nbSweep );
    endValue = data( indexEnd, nbSweep );

    if maxValue <= endValue
        %display( 'Invalid parameters for getDecayTime() : max is below the end' );
        return;
    end
    
    amplitude = maxValue - baseLine;
    firstLevel = amplitude * percentBegin + baseLine;
    secondLevel = amplitude * percentEnd + baseLine;

    % When do we get below the second level, starting at the peak ?
    iStart = indexPeak;
    while( data( iStart, nbSweep ) > secondLevel && iStart < indexEnd )
        iStart = iStart + 1;
    end

    % When do we get below the first level, starting at the previous index ?
    iEnd = iStart;
    while( data( iEnd, nbSweep ) > firstLevel && iEnd < indexEnd )
        iEnd = iEnd + 1;
    end
    
    % Restart from iEnd and see when we reach the second level
    iStart = iEnd;
    while( iStart >= 1 && data( iStart, nbSweep ) < secondLevel )
        iStart = iStart - 1;
    end
    
    if iStart <= size(data, 1)   
        decayTime = (iEnd - iStart) * samplingRate;
    end

end