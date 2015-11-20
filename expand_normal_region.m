function new_data = expand_normal_region(data, expand_size, abnormal_region, normal_region)

	numAttr = size(data, 2);
	if isempty(normal_region)
		normal_region = [];
		for i=1:size(data,1)
			if ~ismember(i, abnormal_region) && data(i,2) > 0
				normal_region(end+1) = i;
			end
		end
	end

	last_epoch = data(end, 1);
	new_normal_region = zeros(expand_size, numAttr);
	new_epoch = [last_epoch+1:last_epoch+expand_size]';
	new_normal_region(:,1) = new_epoch;
	for i = 2:numAttr
		mu = mean(data(normal_region, i));
		sigma = std(data(normal_region, i));
		new_normal = normrnd(mu, sigma/4, 1, expand_size);
		new_normal(new_normal<0) = 0;
		new_normal_region(:,i) = new_normal;
	end
	new_data = vertcat(data, new_normal_region);
end
