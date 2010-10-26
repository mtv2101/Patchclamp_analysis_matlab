function doQuickSweepsPlot( nbSweeps, sweepsToKeep, samplingRate, nbStims, stim, rawData, smoothingTimes, fileName )
% Make a quick lot of the sweep data, in order to visualize it and
% determine which are the best settings to treat the sweeps.

    %%%%%%%%%%%%%%%%%%%%% ASCII raw Data file to Data matrix %%%%%%%%%%%%%%%%%%

    [data, sweepSize, nbSweeps] = preteatRawData( rawData, nbSweeps, sweepsToKeep );

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    smoothingX_1 = ( smoothingTimes(1,1) / samplingRate ) + 1 ;
    smoothingX_2 = ( smoothingTimes(1,2) / samplingRate ) + 1 ;

    %%%%%%%%%%%%%%%%%%%%%%% GLOBAL INFO FOR EACH STIM %%%%%%%%%%%%%%%%%%%%%%%%%

    [indexBeginStims, indexEffectiveBeginStims, indexEndStims, iBegArt, indexEndArtifact, iEndAns] = getStimsUsefulPoints( sweepSize, stim, samplingRate );

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

    figure
    hold on;
    for i=1:nbSweeps
        plot(smoothedData(:, nbSweeps+2), smoothedData(:, i), 'b', 'DisplayName', sprintf( 'Sweep %d', sweepsToKeep(i) ) );
    end
    ylims = get(gca, 'Ylim');
    color = [1 0.9 0.9];
    for k=1:nbStims
        x0 = smoothedData(indexBeginStims(k), nbSweeps+2);
        x1 = smoothedData(indexEndStims(k), nbSweeps+2);
        area( [x0  x1], [ylims(1) ylims(1)], ylims(2), 'DisplayName', sprintf( 'Stim %d', k ), 'FaceColor', color, 'LineStyle', 'none' );
        color = circshift( color, [0 1] );
    end
    title( sprintf( '%s : quick plot of sweeps', fileName ) ,'Interpreter','none');
    hold off;

end

