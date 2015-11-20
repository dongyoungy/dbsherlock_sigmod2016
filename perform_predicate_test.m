function [predicates_before predicates_after_filter predicates_after filtered_lists corr_filtered_list corr_after_list corr_diff] = perform_predicate_test(num_discrete, diff_threshold, abnormal_multiplier, introduce_lag, find_lag, expand_normal, expand_size)

    cwd = pwd;
    data = load('dbsherlock_datasets.mat');

	num_case = size(data.test_datasets, 1);
    %num_case = 1;
	num_samples = size(data.test_datasets, 2);
    %num_samples = 11;

    confidence = cell(num_case, num_case);
    fscore = cell(num_case, num_case);

    causes{1} = 'Extra workload from separate clients';
    causes{2} = 'Stress on IO';
    causes{3} = 'Database maintenance';
    causes{4} = 'mysqldump';
    causes{5} = 'Table restore';
    causes{6} = 'Stress on CPU with poll()';
    causes{7} = 'Flush log/table';
    causes{8} = 'Network congestion';
	causes{9} = 'Lock Contention';
    causes{10} = 'Poor Physical Design';
    causes{11} = 'Poorly Written Query';
    
    train_param = ExperimentParameter;
    test_param = ExperimentParameter;

    train_param.create_model = true;

    if ~isempty(num_discrete)
        train_param.num_discrete = num_discrete;
        test_param.num_discrete = num_discrete;
    end
    if ~isempty(diff_threshold)
        train_param.diff_threshold = diff_threshold;
        test_param.diff_threshold = diff_threshold;
    end
    if ~isempty(abnormal_multiplier)
        train_param.abnormal_multiplier = abnormal_multiplier;
        test_param.abnormal_multiplier = abnormal_multiplier;
    end
    
    if introduce_lag
        train_param.introduce_lag = true;
		train_param.lag_min = 10;
		train_param.lag_max = 20;
    end

    if find_lag
        train_param.find_lag = true;
    end

    if expand_normal
        train_param.expand_normal_region = true;
        train_param.expand_normal_size = expand_size;
    end

	detected_lag_accuracies = [];

    tic;

	predicates_before = {};
    predicates_after = {};
    predicates_after_filter = {};
    filtered_lists = {};
    corr_filtered_list = {};
    corr_after_list = {};
    corr_diff = zeros(num_case, num_samples);

	for i=1:num_case
        filtered_list = [];
		for j=1:num_samples
			clearCausalModels(cwd);
			[e c p detected_lag_accuracy p2 p3] = explainExperimentSigmod2015_v2(data.test_datasets{i,j}, data.abnormal_regions{i,j}, data.normal_regions{i,j}, [], train_param);
			% if j == 1
			% 	x = cell2mat(p(:,1));
   %              y = cell2mat(p2(:,1));
			% else
			% 	x = vertcat(x, cell2mat(p(:,1)));
   %              y = vertcat(y, cell2mat(p2(:,1)));
			% end
            new_data = expand_normal_region(data.test_datasets{i,j}.data, train_param.expand_normal_size, data.abnormal_regions{i,j}, data.normal_regions{i,j});
            predicates_after{i,j} = p;
            predicates_before{i,j} = p2;
            predicates_after_filter{i,j} = p3;
            after = cell2mat(p(:,1));
            before = cell2mat(p2(:,1));
            filtered = setdiff(before, after);
            filtered_list = vertcat(filtered_list, filtered);
            corr_filtered = [];

            if ~isempty(filtered)
                corr_filtered = calculate_correlation(filtered, new_data, data.abnormal_regions{i,j}, data.normal_regions{i,j});
            end
            corr_after = calculate_correlation(after, new_data, data.abnormal_regions{i,j}, data.normal_regions{i,j});

            if ~isempty(filtered)
                corr_diff(i,j) = corr_after - corr_filtered;
            end

            corr_filtered_list{i,j} = corr_filtered;
            corr_after_list{i,j} = corr_after;
		end
        filtered_lists{end+1} = unique(filtered_list);
	end

    timeElapsed = toc
end
