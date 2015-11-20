function [abnormal_region3] = runAnomalyDetection2(dataset, anomaly_size)
	data = dataset.data;
	latency = data(:,2);
	latency(isnan(latency)) = 0;
	len = size(latency, 1);
	range = [1:len];

	scores = zeros(len, len);

	normal_median = median(latency);
	anomaly_density = 0.2;
	largest_density = 0;

	latency_start = find(latency, 1, 'first');
	latency_end = find(latency, 1, 'last');
	shift_left = latency_start - 1;
	latency = latency(latency_start:latency_end);

	[outlier, outlier_size] = outlier_detection(latency);
    outlier = sort(outlier);
    abnormal_region3 = [1:1];
 	for i = 1:outlier_size
 		for j = i:outlier_size
 			if outlier(j) - outlier(i) >= 10
 				density = (j-i+1)/(outlier(j)-outlier(i)+1);
 				if density > anomaly_density && density > largest_density 
 					largest_density = density;
 					abnormal_region3 = [outlier(i):outlier(j)]; 
 				end
 			end
 		end
     end
	
	if size(abnormal_region3, 2) == 1
		for i = 1:outlier_size
	 		for j = (i+1):outlier_size
 				density = (j-i+1)/(outlier(j)-outlier(i)+1);
 				if  density > largest_density 
 					largest_density = density;
 					abnormal_region3 = [outlier(i):outlier(j)]; 
 				end
	 		end
     	end
	end

	abnormal_region3 = abnormal_region3 + shift_left;
end



