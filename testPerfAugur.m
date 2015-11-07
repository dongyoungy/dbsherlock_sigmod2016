function [precisions recalls] = testPerfAugur

    data = load('dbsherlock_datasets.mat');

    num_case = size(data.test_datasets, 1);
    num_samples = size(data.test_datasets, 2);

    precisions = {};
    recalls = {};

    for i=1:num_case
    	precisions{i} = [];
    	recalls{i} = [];
    	for j=1:num_samples
    		perfaugur_region = runPerfAugur(data.test_datasets{i,j});
    		correct_region = data.abnormal_regions{i,j};

    		tp = size(intersect(perfaugur_region, correct_region), 2);

    		precision = tp / size(perfaugur_region, 2);
    		recall = tp / size(correct_region, 2);

    		precisions{i}(end+1) = precision;
    		recalls{i}(end+1) = recall;
    	end
    end
end