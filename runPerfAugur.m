function [abnormal_region] = runPerfAugur(data)
	%data = dataset.data;
	latency = data(:,2);
	latency(isnan(latency)) = 0;
	len = size(latency, 1);
	range = [1:len];

	scores = zeros(len, len);

	normal_median = median(latency);

	for s = 1:len
		for e = s:len
			abnormal = [s:e];

			% normal = setdiff(range, abnormal);
			% normal_latency = latency(normal);
			% normal_median = median(normal_latency);

			abnormal_latency = latency(abnormal);
			% abnormal_latency(find(abnormal_latency==0)) = [];
			abnormal_median = median(abnormal_latency);
			scores(s,e) = (abnormal_median - normal_median) * log(abs((e-s+1)));
			%scores(s,e) = (abnormal_median - normal_median) * 2 * abs((e-s+1));
		end
	end

	[v,ind] = max(scores);
	[v1, ind1] = max(max(scores));
	max_score = v1;
	anomaly_start = ind(ind1);
	anomaly_end = ind1;
	abnormal_region = [anomaly_start:anomaly_end];
end
