function [count amp] = get_ipscs(data, nstims, thresh, trials)

% if size(data,2) ~= nstims
%     disp 'SYNTAX ERROR ... asshole'
% end

dat_shrt = data(2:size(data,1),:);
data_mat = cell2mat(dat_shrt);
datlen = size(data_mat,1);
nsweeps = (datlen)/trials;

ans_count = zeros(size(data_mat));
ans_mean = NaN(size(data_mat));
for t = 1:trials
    for n = 1:nsweeps
        for s = 1:nstims
            if data_mat(t+(trials*(n-1)),s) > thresh
                ans_count(t+(trials*(n-1)),s) = data_mat(t+(trials*(n-1)),s);
                ans_mean(t+(trials*(n-1)),s) = data_mat(t+(trials*(n-1)),s);
            end
        end
    end
end

for n = 1:nsweeps
    for s = 1:nstims
        count(n,s) = length(find(ans_count(((n-1)*(trials)+1):((n*trials)),s)));
        amp(n,s) = nanmean(ans_mean(((n-1)*(trials)+1):((n*trials)),s),1);
    end
end