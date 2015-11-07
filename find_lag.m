function lag = find_lag(dataset, abnormal_index, normal_index)

	% let's print biserial correlation coefficient up to X lag seconds
	max_lag = 30;
	data = dataset.data;
	numRow = size(data, 1);
	numAttr = size(data, 2);

    % if isempty(normal_index)
    %     normal_index = [];
    %     for i=1:size(data,1)
    %         if ~ismember(i, abnormal_index) && data(i,2) > 0
    %             normal_index(end+1) = i;
    %         end
    %     end
    % end

    % calculate correlation for each lag time
    biserial_cor_sums = [];

    for lag=0:max_lag;

    	lagged_abnormal_index = abnormal_index - lag;
    	lagged_normal_index = normal_index;

    	if min(lagged_abnormal_index) < 1
    		lagged_abnormal_index = [1:max(lagged_abnormal_index)];
    	end

    	if isempty(lagged_normal_index)
    		lagged_normal_index = [];
    		for i=1:size(data,1)
    			if ~ismember(i, lagged_abnormal_index) && data(i,2) > 0
    				lagged_normal_index(end+1) = i;
    			end
    		end
    	end

    	biserial_cor_sum = 0;

    	for i=3:numAttr
			mean_abnormal = mean(data(lagged_abnormal_index, i));
			mean_normal = mean(data(lagged_normal_index, i));
			std_dev = std(data(:, i));

			% ignore attribute with std. deviation of 0.
			if (std_dev == 0)
				continue
			end
			num_abnormal = size(lagged_abnormal_index, 2);
			num_normal = size(lagged_normal_index, 2);
			num_total = num_abnormal + num_normal;
			ratio_abnormal = num_abnormal / (num_abnormal + num_normal);
			u = norminv(ratio_abnormal);
			h = exp(-1 * (u^2) / 2) / sqrt(2*pi);

			biserial_cor = ((mean_abnormal - mean_normal) / std_dev) * ((num_abnormal * num_normal) / (h *  num_total^2));
			if isnan(biserial_cor)
				error('biserial correlation should not be NaN.');
			end

			if abs(biserial_cor) > 0.4 % mild correlation
				biserial_cor_sum = biserial_cor_sum + abs(biserial_cor);
			end
    	end
    	biserial_cor_sums(end+1) = biserial_cor_sum;
    end
	[m ind] = max(biserial_cor_sums);
	lag = ind - 1;
end