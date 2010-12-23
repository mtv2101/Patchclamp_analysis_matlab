function [iStart, iEnd, riseTime, amplitude] = getRiseTime( data, nbSweep, baseLine, indexBegin, indexPeak, percentBegin, percentEnd, samplingRate )
% Compute the time between the date we are at 'percentBegin' % of the max
% value (which is the value at indexPeak, minus the baseLine) and the date
% we are at 'percentEnd' % of the max value, considering only points
% between 'indexBegin' and 'indexPeak', for the sweep 'nbSweep'

    riseTime = 0;
    iStart = 0;
    iEnd = 0;
    amplitude = 0;
    
    %fprintf( 'Rise time between %.2f and %.2f\n', percentBegin, percentEnd );
    
    if indexPeak > size(data, 1) || indexBegin > size(data, 1) || nbSweep > size(data, 2)
        display( 'Invalid parameters for getRiseTime()' );
        return;
    elseif indexPeak <= 0
        return;
    end

    maxValue = data( indexPeak, nbSweep );
    startValue = data( indexBegin, nbSweep );

%     if maxValue <= startValue
%         display( 'Invalid parameters for getRiseTime() : max is below the beginning' );
%         return;0
%     end
    
    amplitude = maxValue - baseLine;
    firstLevel = amplitude * percentBegin + baseLine;
    secondLevel = amplitude * percentEnd + baseLine;

    % When do we get below the second level, starting at the end ?
    iEnd = indexPeak;
    while( data( iEnd, nbSweep ) > secondLevel )
        iEnd = iEnd - 1;
    end

    % When do we get below the first level, starting at the previous index ?
    iStart = iEnd;
    while( data( iStart, nbSweep ) > firstLevel )
        iStart = iStart - 1;
    end
    
    % Restart from iStart and see when we reach the second level
    iEnd = iStart;
    while( iEnd <= size(data, 1) && data( iEnd, nbSweep ) < secondLevel )
        iEnd = iEnd + 1;
    end
    
    if iEnd <= size(data, 1)   
        riseTime = (iEnd - iStart) * samplingRate;
    end

end