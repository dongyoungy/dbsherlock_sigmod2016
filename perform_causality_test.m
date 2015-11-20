function perform_causality_test(num_discrete, diff_threshold, abnormal_multiplier, introduce_lag, find_lag, expand_normal, expand_size)

	cwd = pwd;

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

	num_samples = 10000;

	num_exact_cause = 0;
	num_contain_cause = 0;
	num_incorrect = 0;
	num_should_be_filtered = 0;
	num_should_not_be_filtered = 0;
	num_filtered_correct = 0;
	num_filtered_incorrect = 0;

	num_before_false_positive = 0;
	num_before_false_negative = 0;


    tic;

	%domain_knowledge = [1 2; 3 4];
	%train_param.domain_knowledge = domain_knowledge;

	for i=1:num_samples
		[dataset g domain_knowledge root_causes correct_filter_list] = generate_synthetic_dataset(6, 600, 60, 100);
		train_param.domain_knowledge = domain_knowledge;
		train_param.correct_filter_list = correct_filter_list;
		abnormal_region = [100:159];
		normal_region = [];
		pred_index = [];
		pred_index_before = [];

		clearCausalModels(cwd);

		%domain_knowledge 
		%plot(g)
		[e c p extra] = explainExperimentSigmod2015_v2(dataset, abnormal_region, normal_region, [], train_param);
		%extra
		root_causes = root_causes + 2;
		%pause;
		if ~isempty(p)
			pred_index = cell2mat(p(:,1));
		end
		if ~isempty(extra.predicates_before)
			pred_index_before = cell2mat(extra.predicates_before(:,1));
		end

		if size(intersect(pred_index, root_causes'), 1) == size(pred_index, 1)
			num_exact_cause = num_exact_cause + 1;
		elseif size(intersect(pred_index, root_causes'), 1) >= size(root_causes, 2)
			num_contain_cause = num_contain_cause + 1;
		else
			num_incorrect = num_incorrect + 1;
			%domain_knowledge 
			%pred_index
			%root_causes
			%pause;
		end

		num_should_be_filtered = num_should_be_filtered + extra.num_should_be_filtered;
		num_should_not_be_filtered = num_should_not_be_filtered + extra.num_should_not_be_filtered;
		num_filtered_correct = num_filtered_correct + extra.num_filtered_correct;
		num_filtered_incorrect = num_filtered_incorrect + extra.num_filtered_incorrect;

		num_before_false_positive = num_before_false_positive + extra.before_false_positive;
		num_before_false_negative = num_before_false_negative + extra.before_false_negative;
		
	end

	num_filtered_correct 
	num_should_be_filtered
	num_filtered_incorrect 
	num_should_not_be_filtered 
	num_before_false_positive 
	num_before_false_negative 
	num_exact_cause 
	num_contain_cause 
	num_incorrect 
	num_samples
    timeElapsed = toc
end
