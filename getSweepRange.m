function sweepRange = getSweepRange( strSweepRange, nbSweeps )
% Gets '5;10-20;34-67' and returns [5 10:20 34:67]
    sweepRange = [ ];
    rangesStr = regexp(strSweepRange, ';', 'split');
    for i=1:numel(rangesStr)
        c = str2double( rangesStr(i) );
        if  ~isnan([c])
            sweepRange = [sweepRange c];
        elseif numel(char(rangesStr(i))) > 0
            tmp = textscan( char(rangesStr(i)), '%d-%d' );
            if numel( tmp ) ~= 2
                display( sprintf( 'Invalid range input : %s', strSweepRange) );
                sweepRange = [1:nbSweeps];
                return;
            else
                a = tmp{1};
                b = tmp{2};
                sweepRange = [sweepRange a:b];
            end
        end
    end
    sweepRange = sort( unique(sweepRange) );
    
    if isempty( sweepRange )
        sweepRange = 1:nbSweeps;
    elseif( sweepRange( numel(sweepRange) ) > nbSweeps )
        display( 'Range input contains sweeps beyond number of sweeps.' );
        sweepRange = 1:nbSweeps;
    end
end

