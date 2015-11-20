function test_DBSCAN

cwd = pwd;
data = load('dbsherlock_datasets.mat');
for i=1:11
	for test_idx=1:11
		test_data = data.test_datasets{i,test_idx}.data;
		test_data = expand_normal_region(test_data, 480, data.abnormal_regions{i,test_idx}, data.normal_regions{i,test_idx});
		abnormal_region = DBScan(test_data, data.test_datasets{i,test_idx}.field_names, 0.01, 3);
		intersection = size(intersect(data.abnormal_regions{i,test_idx}, abnormal_region),2) / size(data.abnormal_regions{i,test_idx},2)
		%test_case = i
		%pause;
	end
end


end

