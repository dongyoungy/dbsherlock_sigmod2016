function new_predicates = filter_predicates_with_correlation(predicates, data, abnormal_region, normal_region)

    numPred = size(predicates, 1);
    new_predicates = {};

	if isempty(normal_region)
		normal_region = [];
		for i=1:size(data,1)
			if ~ismember(i, abnormal_region) && data(i,2) > 0
				normal_region(end+1) = i;
			end
		end
	end

    count = 1;

	for n=1:numPred

        pred = predicates(n,:);
        i = pred{1,1};

		mean_abnormal = mean(data(abnormal_region, i));
		mean_normal = mean(data(normal_region, i));
		std_dev = std(data(:, i));

        % ignore attribute with std. deviation of 0.
        if (std_dev == 0)
        	break;
        end
        num_abnormal = size(abnormal_region, 2);
        num_normal = size(normal_region, 2);
        num_total = num_abnormal + num_normal;
        ratio_abnormal = num_abnormal / (num_abnormal + num_normal);
        ratio_normal = num_normal / (num_abnormal + num_normal);
        u = norminv(ratio_normal);
        h = exp(-1 * (u^2) / 2) / sqrt(2*pi);

        % biserial_cor = ((mean_abnormal - mean_normal) / std_dev) * ((num_abnormal * num_normal) / (h *  num_total^2));
        biserial_cor = ((mean_abnormal - mean_normal) / std_dev) * sqrt((num_abnormal * num_normal) / (num_total^2));
        cor = abs(biserial_cor);
        if (cor > 0.1)
            new_predicates(count, :) = pred;
            count = count + 1;
        end
    end
end