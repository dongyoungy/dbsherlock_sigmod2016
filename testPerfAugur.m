function [precisions recalls] = testPerfAugur

    data = load('dbsherlock_datasets.mat');

    num_case = size(data.test_datasets, 1);
    num_samples = size(data.test_datasets, 2);

    precisions = {};
    recalls = {};

    for i=1:num_case
    	precisions{i} = [];
    	recalls{i} = [];
    	for j=1:3
    		[perfaugur_region, perfaugur_region2, abnormal_region3] = runPerfAugur(data.test_datasets{i,j}, size(data.abnormal_regions{i, j}, 2));
    		correct_region = data.abnormal_regions{i,j};
            
    		tp = size(intersect(perfaugur_region, correct_region), 2);

            %mm = abnormal_region3(1)
            %nn = correct_region(1)
            %nnsize = size(data.abnormal_regions{i, j}, 2)
            %mmsize = size(abnormal_region3, 1)

    		precision1 = tp / size(perfaugur_region, 2);
    		recall1 = tp / size(correct_region, 2);

            tp2 = size(intersect(perfaugur_region2, correct_region), 2);
            
            precision2 = tp2/size(perfaugur_region2, 2);
            recall2 = tp2/size(correct_region, 2);

            tp3 = size(intersect(abnormal_region3, correct_region), 2);
            
            precision3 = tp3/size(abnormal_region3, 2);
            recall3 = tp3/size(correct_region, 2);
            
            
    		precisions{i}(end+1) = precision3;
    		recalls{i}(end+1) = recall3;
    	end
    end
end