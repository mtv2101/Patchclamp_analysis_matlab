function [out] = get_ipscs(datatable, nstims, thresh, trials, exclude)

%% get_ipscs will open the data table produced by
%% CHR_EVOKED_EVENTS_ANALYSIS1 and will analyze the
%% first suprathreshold event in the stimilus train
%%
%% datatable
%% nstims = scalar
%% thresh = two scalars (pA) [low high]
%% trials = vector [(num sweeps trial 1) (trial 2) ...etc]
%% exclude = vector [list of excluded sweeps]
%%
%% Matt Valley Dec 2010

fname = cell(length(trials),1);
for n = 1:length(trials)
    indx_strt = sum(trials(1:n))-trials(n)+2;
    fname{n} = datatable{indx_strt,1};
end

dat_shrt = datatable(2:size(datatable,1),10:25);
data_mat = cell2mat(dat_shrt);
datlen = size(data_mat,1);

amp_data = data_mat(:,13:15); %23:27 if 5 stims
intgrl_data = data_mat(:,10:12); %18:22 if 5 stims
decay_data = data_mat(:,4:6); %8:12 if 5 stims
rise_data = data_mat(:,1:3);  %3:7 if 5 stims
access = datatable(2:size(datatable,1),6);
for n = 1:length(trials)
    for x = 1:3
        access{(x+((n-1)*datlen))} = NaN;
    end
end
access = cell2mat(access);

[amp_count amp_mean amp_first amp_others] = firstevents(amp_data, nstims, thresh, exclude);
firstmask = ~isnan(amp_first);
othersmask = ~isnan(amp_others);
amp_paired = amp_data.*(logical(firstmask+othersmask));
intgrl_first = intgrl_data.*firstmask;
rise_first = rise_data.*firstmask;
decay_first = decay_data.*firstmask;

    function [count amp ans_first ans_second] = firstevents(data, nstims, thresh, exclude)
        ans_zero = zeros(size(data));
        ans_nan = NaN(size(data));
        ans_first = NaN(size(data));
        ans_second = ans_first;
        for n = 1:size(data,1)
            if n ~= exclude
                for s = 1:nstims
                    if data(n,s) >= thresh(1) && data(n,s) <= thresh(2)
                        ans_zero(n,s) = data(n,s);
                        ans_nan(n,s) = data(n,s);
                        if s == 1
                            ans_first(n,s) = data(n,s);
                        else
                            if find(data(n,1:(s-1)) >= thresh(1)) % also exclude first responses that follow a suprathreshold response
                                ans_first(n,s) = NaN;
                            else
                                ans_first(n,s) = data(n,s);
                            end
                            if data(n,s-1) >= thresh(1) && data(n,s-1) <= thresh(2) % find the following responses after a first one for PPR
                                ans_second(n,s) = data(n,s);
                            end
                        end
                    end
                end
            end
        end
        for n = 1:length(trials)
            for s = 1:nstims
                count(n,s) = length(find(ans_zero((((n-1)*trials(n))+1):((n*trials(n))),s)));
                amp(n,s) = nanmean(ans_nan((((n-1)*trials(n))+1):((n*trials(n))),s),1);
            end
        end
    end

amp_lin = nansum(amp_first,2);
zero_sweeps = find(amp_lin == 0); % eliminate sweeps with no detected events
amp_lin(zero_sweeps) = NaN;
int_lin = sum(intgrl_first,2);
int_lin(zero_sweeps) = NaN;
rise_lin = sum(rise_first,2);
rise_lin(zero_sweeps) = NaN;
decay_lin = sum(decay_first,2);
decay_lin(zero_sweeps) = NaN;

%%%%%%%%%%%%%%%% output summary table

out = cell(length(trials)+1,6);
out{1,1} = 'mean amplitude'; out{1,2} = 'mean integral'; out{1,3} = 'mean risetime'; out{1,4} = 'mean decaytime'; out{1,5} = 'mean Ra';
for n = 1:length(trials)
    indx_strt = sum(trials(1:n))-trials(n)+1;
    range = indx_strt:sum(trials(1:n)); % the sweeps in a trial
    mn_amp(n) = nanmean(amp_lin(range));
    mn_int(n) = nanmean(int_lin(range));
    mn_rise(n) = nanmean(rise_lin(range));
    mn_decay(n) = nanmean(decay_lin(range));
    access_mean(n) = nanmean(access(range));
    out{n+1,1} = mn_amp(n); out{n+1,2} = mn_int(n); out{n+1,3} = mn_rise(n); out{n+1,4} = mn_decay(n); out{n+1,5} = access_mean(n);
end
access_change = access_mean(length(trials))/access_mean(1);
out{1,6} = 'Ra change';
out{2,6} = access_change;

%%%%%%%%%%%%%%%% plotting

fig1 = figure;
for n = 1:length(trials)
    indx_strt = sum(trials(1:n))-trials(n)+1;
    range = indx_strt:sum(trials(1:n)); % the sweeps in a trial
    xtime = (range)./4;
    if mod(n,2) == 1
        color = 'k';
    else
        color = 'r';
    end
    
    subplot(5,2,1:2);scatter(xtime, amp_lin(range), color, 'filled');
    xlabel('time (min)');
    ylabel('ipsc amplitude (pA)');
    title(['first ipsc amplitude over time (15sec ISI, threshold = ', num2str(thresh), ')']);
    leg1{n} = ([fname{n},'  Average = ',num2str(mn_amp(n))]);
    hold on;
    
    subplot(5,2,3:4);scatter(xtime, int_lin(range), color, 'filled');
    axis([0 max(xtime) min(int_lin) max(int_lin)]);
    xlabel('time (min)');
    ylabel('ipsc integral (pC)');
    title(['first ipsc integral over time)']);
    leg2{n} = ([fname{n},'  Average = ', num2str(mn_int(n))]);
    hold on;
    
    subplot(5,2,5:6);scatter(xtime, rise_lin(range), color, 'filled');
    axis([0 max(xtime) 0 max(rise_lin)]);
    xlabel('time (min)');
    ylabel('ipsc risetime (ms)');
    title(['first ipsc risetime (20-80%)']);
    leg3{n} = ([fname{n},'  Average = ', num2str(mn_rise(n))]);
    hold on;
    
    subplot(5,2,7:8);scatter(xtime, decay_lin(range), color, 'filled');
    axis([0 max(xtime) 0 max(decay_lin)]);
    xlabel('time (min)');
    ylabel('ipsc decaytime (ms)');
    title(['first ipsc decaytime (100-63%)']);
    leg4{n} = ([fname{n},'  Average = ', num2str(mn_decay(n))]);
    hold on;
    
    subplot(5,2,9:10);scatter(xtime, access(range), color, 'filled');
    xlabel('time (min)');
    ylabel('Ra (Mohm)');
    title('Access resistance over time (15sec ISI)');
    leg5{n} = ([fname{n},'  Average = t.b.a']);
    hold on;
end

subplot(5,2,1:2);
l1 = legend(leg1,'Location', 'EastOutside');
set(l1,'Position',[0.9143 0.8122 0.3008 0.09935]);
subplot(5,2,3:4);
l2 = legend(leg2,'Location', 'EastOutside');
set(l2,'Position',[0.9143 0.6428 0.3008 0.09935]);
subplot(5,2,5:6);
l3 = legend(leg3,'Location', 'EastOutside');
set(l3,'Position',[0.9143 0.4722 0.3008 0.09935]);
subplot(5,2,7:8);
l4 = legend(leg4,'Location', 'EastOutside');
set(l4,'Position',[0.9143 0.3006 0.3008 0.09935]);
subplot(5,2,9:10);
l5 = legend(leg5,'Location', 'EastOutside');
set(l5,'Position',[0.9143 0.1273 0.3008 0.09935]);

subplot(5,2,1:2);
allamps = amp_data(:);
alltimes = repmat(((1:length(amp_lin))')./4, nstims, 1);
scatter(alltimes, allamps, [], [.3 .3 .3]);
axis([0 max(alltimes(:)) 0 max(allamps)]);
hold on
upper = repmat(thresh(1),1,100);
lower = repmat(thresh(2),1,100);
plot(upper, 'b');
hold on; plot(lower, 'b');

fig2 = figure;
for n = 1:length(trials)
    indx_strt = sum(trials(1:n))-trials(n)+1;
    range = indx_strt:sum(trials(1:n)); % the sweeps in a trial
    if mod(n,2) == 1
        color = 'k';
    else
        color = 'r';
    end
    
    subplot(1,2,1)
    i = int_lin(range);
    a = amp_lin(range);
    scatter(i(:),a(:),color, 'filled');
    %axis([0 max(int_lin) 0 max(amp_lin)]);
    xlabel('ipsc integral');
    ylabel('ipsc amplitude (pA)');
    title('amplitude vs. decay time of first ChR2 evoked ipsc (15sec ISI)');
    hold on
    
    subplot(1,2,2)
    dd = decay_lin(range);
    aa = access(range);
    scatter(dd,aa,color, 'filled');
    %axis([0 max(decay_lin) min(access) max(access)]);
    xlabel('decay-time to 63% (ms)');
    ylabel('Access Resistance (Mohm)');
    title('decay time vs. access resistance');
    hold on
end

end