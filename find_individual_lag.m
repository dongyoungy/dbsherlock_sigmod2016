function lags = find_individual_lag(dataset, abnormal_index, normal_index)

	% let's print biserial correlation coefficient up to X lag seconds
	max_lag = 30;
	data = dataset.data;
	numRow = size(data, 1);
	numAttr = size(data, 2);

    % calculate correlation for each lag time
    biserial_cor_sums = [];

    % find lag for each attribute
    lags = zeros(1, numAttr);

    for i=3:numAttr
        correlations = [];
        for lag=0:max_lag;
            lagged_abnormal_index = abnormal_index{i} - lag;
            lagged_normal_index = normal_index;
            if min(lagged_abnormal_index) < 1
                lagged_abnormal_index = [1:max(lagged_abnormal_index)];
            end

            if isempty(lagged_normal_index)
				lagged_normal_index = setdiff([1:numRow], lagged_abnormal_index);
                %lagged_normal_index = [];
                %for j=1:size(data,1)
                    %if ~ismember(j, lagged_abnormal_index) && data(j,2) > 0
                        %lagged_normal_index(end+1) = j;
                    %end
                %end
            end

            mean_abnormal = mean(data(lagged_abnormal_index, i));
            mean_normal = mean(data(lagged_normal_index, i));
            std_dev = std(data(:, i));

            % ignore attribute with std. deviation of 0.
            if (std_dev == 0)
                break;
            end
            num_abnormal = size(lagged_abnormal_index, 2);
            num_normal = size(lagged_normal_index, 2);
            num_total = num_abnormal + num_normal;
            ratio_abnormal = num_abnormal / (num_abnormal + num_normal);
            u = norminv(ratio_abnormal);
            h = exp(-1 * (u^2) / 2) / sqrt(2*pi);

            biserial_cor = ((mean_abnormal - mean_normal) / std_dev) * ((num_abnormal * num_normal) / (h *  num_total^2));
            correlations(end+1) = abs(biserial_cor);
        end
        [max_cor ind] = max(correlations);
        if isempty(ind) || max_cor < 0.7
            lags(i) = 0;
        else
            lags(i) = ind - 1;
        end
    end
end
