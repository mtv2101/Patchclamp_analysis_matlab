function rep = test_pulse_analysis(file_name, data, data_to_save, time_points, samplingRate, U_pulse_value, nbSweeps, toDo, ID, handleFigure )

% What to do ?
doFitTP = toDo(1);
doPlot = toDo(2);
doSave = toDo(3);

doFitTP = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WORKING DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%
% The data, but recentered on 0 (data - mean(data))
for i=1:nbSweeps+1
    data( :, i ) = data( :, i ) - mean( data( :, i ) );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1ere colonne de time_points = temps en ms
% 2eme colonne de time_points = # de la ligne  correspondant au temps dans
% le tableau des donnees reorganisee


for i=1:3
    time_points(i,2) = int32(time_points(i,1) / samplingRate) + 1;
end

% ############################################### calcul des base lines ###

data_lastrow = data(:,size(data,2)); %this is set in "reteatRawData" to equal time samples

if length(nbSweeps) > 1
    data_sweepmean = mean(data(:,nbSweeps),2);
    for i = nbSweeps
        baseline_1 = zeros( time_points(2,2),1);
        baseline_1_value = mean(mean(data(1:time_points(1,2),nbSweeps),1),2);
        baseline_1(:,1) = baseline_1_value ;
        baseline_2 = zeros(time_points(3,2),1);
        baseline_2_value = mean(mean(data(time_points(2,2):time_points(3,2), nbSweeps),1),2);
        baseline_2(:,1) = baseline_2_value ;
    end
    % calcul du minimum test pulse
    [value_min,index_min] = min(data_sweepmean(1:time_points(2,2)));
else
    baseline_1 = zeros( time_points(2,2),1);
    baseline_1_value = mean(data(1:time_points(1,2),nbSweeps+1),1) ;
    baseline_1(:,1) = baseline_1_value ;
    baseline_2 = zeros(time_points(3,2),1);
    baseline_2_value = mean(data(time_points(2,2):time_points(3,2), nbSweeps+1),1) ;
    baseline_2(:,1) = baseline_2_value ;
    % calcul du minimum test pulse
    [value_min,index_min] = min([data(1:time_points(2,2),nbSweeps+1)]) ;
end

%  calcul Ra
Ra = U_pulse_value / abs(baseline_1_value - value_min) * 1e3 ; % en MOhm

% Calcul alternatif de ra : moyenne des valeurs et pas valeur sur la
% moyenne
altRa = zeros( 1, nbSweeps );
for i=1:nbSweeps
    [valMin,indMin] = min([data(1:time_points(2,2),i)]) ;
    bl1val = mean( data(1:time_points(1,2), i),1 ) ;
    altRa(i) = U_pulse_value / abs(bl1val - valMin) * 1e3 ; % en MOhm
end
altRa = mean( altRa );

display( sprintf('Ra (mean of all Ra(i)) : %f', altRa) );
display( sprintf('Ra (computed on the mean) : %f', Ra) );


%  calcul Ra

Ra = U_pulse_value / abs(baseline_1_value - value_min) * 1e3 ; % en MOhm

%  calcul Rm

Rm = U_pulse_value * abs(abs(1/(baseline_1_value - baseline_2_value))-1/abs(baseline_1_value - value_min)) * 1e3 ; % en MOhm

% ########################################## fitting of the test pulse ####

if doFitTP
    
    display('fitting test pulse...')
    
    if length(nbSweeps) > 1
        YDecay=data_sweepmean;
        TimeDecay=data_lastrow;
        %time when to begin the fit(% the gap)
        index_time_fit_begin = index_min ;
        while (data_sweepmean(index_time_fit_begin,:) < (0.5*value_min + baseline_2_value*0.5 ))
            index_time_fit_begin = index_time_fit_begin + 1;
        end
    else
        YDecay=data(:, nbSweeps+1) ;
        TimeDecay=data_lastrow;
        
        %time when to begin the fit(% the gap)
        index_time_fit_begin = index_min ;
        while (data(index_time_fit_begin, nbSweeps+1) < (0.5*value_min + baseline_2_value*0.5))
            index_time_fit_begin = index_time_fit_begin + 1;
        end
    end
    time_fit_begin=data_lastrow(index_time_fit_begin,:);
    
    %time when to stop the fit
    time_fit_end = data_lastrow(1,:) + time_points(2,1) + 0.5*(time_points(3,1)-time_points(2,1)); % offset "data(1, nbSweeps+2)" in case the data doesn't start at t=0
    outliers = excludedata(TimeDecay,YDecay,'domain',[time_fit_begin time_fit_end]);
    x=TimeDecay(~outliers);
    Ydata=YDecay(~outliers);
    
    % 1) Define model and fit options
    exp_fit = fittype('a*exp(-(x-K)/T)+b','coefficients',{'a','K','T','b'}, 'independent','x') ;
    options = fitoptions('a*exp(-(x-K)/T)+b') ;
    
    % To set initial values of fitting parameters:
    DI = value_min - baseline_2_value ;
    time_min = data_lastrow(index_min,:);
    options.Startpoint = [DI time_min 0.3 baseline_2_value] ;
    
    
    % To set allowed limits for the fitting parameters
    % (to constrain the fit choose finite values):
    options.Lower = [-Inf time_min-1 0 -Inf];
    options.Upper = [Inf time_min+1 10 Inf];
    
    % fit options
    options.TolFun = 1e-30 ;
    options.TolX = 1e-30 ;
    options.MaxFunEvals = 2000 ;
    options.MaxIter = 200 ;
    
    % 2) Do the fit
    [ffit,gof] = fit(x,Ydata,exp_fit,options) ;
    
    % 3) retrieve fit parameters and confidence intervals
    fitparam = coeffvalues(ffit); fitcfi = confint(ffit) ;
    
    % 4) To visualize the fit:
    a=fitparam(1); K=fitparam(2) ; T = fitparam(3) ; b = fitparam(4) ;
    
    x1=x;
    f1=a*exp(-(x-K)/T)+b;
    
    Tau_TestPulse1= T ; %ms
    
    rsquare_fit_TestPulse1=gof.rsquare;
    
    % Problem : a bad precision on Ra gives a bad one on capa
    capa = Tau_TestPulse1 / Ra * 1e3;   % en pF
    if capa > 1e10; capa = capa * 1e-12; end
    if Ra < 1e-4; Ra = Ra * 1e12 ;  end
    if Rm < 1e-4; Rm = Rm * 1e12;  end
    
    % Display results
    display( sprintf( 'Capacitance (pF) : \t\t %f', capa ) );          % pF
    display( sprintf( 'Access resistance (MOhm) : \t %f', Ra ) );      % MOhm
    display( sprintf( 'Membran resistance (MOhm) : \t %f', Rm ) );     % MOhm
    
else 
    capa = 1; %value pad
    rsquare_fit_TestPulse1 = 1; %value pad
end

% ########################################################## END fit ###




% ########################################################## plot ####

if doPlot
    if length(nbSweeps) == 1
    display('plotting...')
    
    figure( handleFigure ); % use the graph provided in parameters
    currTitle = get( get(gca,'Title'), 'String' );
    if length(currTitle) > 0
        currTitle = strcat( currTitle, ' / Test Pulse analysis' );
    else
        currTitle = sprintf( '%s : Test Pulse analysis', file_name );
    end
    figure
    title( currTitle ,'Interpreter','none');
    hold on, plot(data_lastrow, data(:, nbSweeps+1),'r');
    hold on, legend( 'Mean sweep' );
    
%         plot(data_lastrow(time_points(1,2),:), data_sweepmean(time_points(1,2),:), 'bo') ;
%         plot(data_lastrow(time_points(2,2),:), data_sweepmean(time_points(2,2),:), 'bo') ;
%         plot(data_lastrow(time_points(3,2),:), data_sweepmean(time_points(3,2),:), 'bo') ;
%         plot(data_lastrow(time_points(2,2),:), baseline_1(:,1),'b');
%         plot(data_lastrow(time_points(3,2),:), baseline_2(:,1),'b');  
        plot(data_lastrow(time_points(1,2),:), data(time_points(1,2),nbSweeps+1), 'bo') ;
        plot(data_lastrow(time_points(2,2),:), data(time_points(2,2),nbSweeps+1), 'bo') ;
        plot(data_lastrow(time_points(3,2),:), data(time_points(3,2),nbSweeps+1), 'bo') ;
        plot(data(1:time_points(2,2), nbSweeps+2), baseline_1(:,1),'b');
        plot(data(1:time_points(3,2), nbSweeps+2), baseline_2(:,1),'b');    
    end

    %fit    
    if doFitTP
        plot(x1,f1,'--b','linewidth',2);
    end    
end

if doSave
    %if doFitTP
        data_to_save{ID+1,1} = file_name ;
        data_to_save{ID+1,2} = capa ;
        data_to_save{ID+1,3} = rsquare_fit_TestPulse1 ;
        data_to_save{ID+1,4} = Rm ;
        data_to_save{ID+1,5} = Ra ;
        
%     else
%         display('Nothing to save !') ;
%     end
end

rep = data_to_save ;

end