function outlier = DBScan(data, field_names, eps, minPts, abnormal_region, normal_region)

		%data = dataset.data;
		%data = expand_normal_region(data, 300, abnormal_region, normal_region);

		latency = data(:,2);
		start_index = find(latency, 1, 'first');
		end_index = find(latency, 1, 'last');
		data = data(start_index:end_index,:);

		[attr_list attrs] = find_attributes_for_anomaly_detection(data, field_names);
		data = data(:, [attr_list]);
		distances = get_euclidean_distance(data, minPts);
		%eps = quantile(distances, .99)/2
		eps = max(distances)/3;
		%plot((sort(distances)))
		
		%eps = median(distances)
		%eps = median(distances);
		%distances = sort(distances)
		%distances(1:minPts+20)
		%mean(distances(1:minPts))
		%pause;

		data_size = size(data, 1);

		cluster_size = 0;
		visited = zeros(1, data_size);
		is_cluster = zeros(1, data_size);
		
		for i=1:data_size
				if visited(i) == 0
						visited(i) = 1;
						neighbor = regionQuery(data, i, eps);
						if size(neighbor, 2) < minPts
								visited(i) = 2;
						else
								cluster_size = cluster_size + 1;
								[visited, clustering{cluster_size}, is_cluster] = expandCluster(data, i , visited, neighbor, is_cluster, eps, minPts);
						end
				end
		end

		noise = find(visited == 2);
		
		 if size(clustering,2) < 2
			 disp('found only one cluster. returning noise as anomaly');
			 %size(clustering{1})
			 %noise
			 %error('cluster size should be greater than 1.');
		 end
		%assert(size(clustering,2) > 1);
		outlier = [];
		smallest_size = floor(data_size * 0.2);
		
		for k=1:size(clustering, 2)
			   if size(clustering{k}, 2) <= smallest_size
					%smallest_size = size(clustering{k}, 2);
					outlier = horzcat(outlier, clustering{k});
			   end
				 %clustering{k} + start_index - 1
		end
		if ~isempty(outlier)
			outlier = outlier + start_index - 1;
		else
			outlier = noise + start_index - 1;
		end
end
