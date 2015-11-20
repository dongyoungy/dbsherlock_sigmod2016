function distance_knn = get_euclidean_distance(data, knn)
	data_size = size(data, 1);
	dimension = size(data, 2);
	minimum = repmat(min(data), data_size, 1);
	range = repmat(max(data)-min(data), data_size, 1);
	zero_range = find(range == 0);
	range(zero_range) = 1;
	data = (data - minimum)./range;
	distance_knn = [];
	for i = 1:data_size
		distances = [];
		for j = 1:data_size
			if i == j
				continue
			end
			distance = 0;
			for k=1:dimension
				distance = distance + (data(i,k)-data(j,k))^2;
			end
			distance = sqrt(distance);
			distances(end+1) = distance;
		end
		distances = sort(distances);
		distances = distances(knn);
		distance_knn = horzcat(distance_knn, distances);
	end
end
