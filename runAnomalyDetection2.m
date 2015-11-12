function [abnormal_region, abnormal_region2, abnormal_region3] = runAnomalyDetection2(dataset, anomaly_size)
	data = dataset.data;
	latency = data(:,2);
	latency(isnan(latency)) = 0;
	len = size(latency, 1);
	range = [1:len];

	scores = zeros(len, len);

	normal_median = median(latency);

	for s = 1:len
		for e = s:len
			abnormal = [s:e];

			 %normal = setdiff(range, abnormal);
			 %normal_latency = latency(normal);
			 %normal_mean = mean(normal_latency);

            
            

			abnormal_latency = latency(abnormal);
			% abnormal_latency(find(abnormal_latency==0)) = [];
			abnormal_median = median(abnormal_latency);
            abnormal_mean = mean(abnormal_latency);
			% scores(s,e) = (abnormal_median - normal_median) * log(abs((e-s+1)));
			scores(s,e) = (abnormal_median - normal_median) * 2 * abs((e-s+1));
		end
	end

	[v,ind] = max(scores);
	[v1, ind1] = max(max(scores));
	max_score = v1;
	anomaly_start = ind(ind1);
	anomaly_end = ind1;
	abnormal_region = [anomaly_start:anomaly_end];







	anomaly_density = 0.2;
	largest_density = 0;

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

	assert(size(abnormal_region3, 2) > 1);


    plot(latency)
    






    
	%anomaly detection alternative

	normal = ones(len, 1)*normal_median;
	latency = [latency;normal];

	%anomaly_size = min(1/4*len, anomaly_size);
	best_distance_so_far = 0;
	anomaly_start = 1;
    %anomaly_size = 10;

        
         for s = 1:(len - anomaly_size+1)
             nearest_distance = Inf;
            for e = 1:(len - anomaly_size+1)
                if abs(s - e) >= anomaly_size
                    nearest_distance = min(euclidian_distance(latency, s, e, anomaly_size), nearest_distance);
                end
                if nearest_distance < best_distance_so_far
                    break
                end
            end
            if nearest_distance > best_distance_so_far
                best_distance_so_far = nearest_distance;
                anomaly_start = s;
                abnormal_region2 = [anomaly_start:anomaly_start + anomaly_size-1];
            end
        end

        %anomaly_size = anomaly_size+1;
    %end

	%comment this line for perfaugur 
	%abnormal_region = [anomaly_start:anomaly_start + anomaly_size-1];



end



