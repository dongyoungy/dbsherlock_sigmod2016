function [confidence fscore detected_lag_accuracies] = perform_merged_causal_models_leave_one_out(num_discrete, diff_threshold, abnormal_multiplier, introduce_lag, find_lag, expand_normal, expand_size)

    cwd = pwd;
    data = load('dbsherlock_datasets.mat');

	num_case = size(data.test_datasets, 1);
    % num_case = 2;
	num_samples = size(data.test_datasets, 2);
    % num_samples = 2;

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
        test_param.introduce_lag = true;
		test_param.lag_min = 20;
		test_param.lag_max = 30;
    end

    if find_lag
        test_param.find_lag = true;
    end

    if expand_normal
        train_param.expand_normal_region = true;
        train_param.expand_normal_size = expand_size;
    end

	detected_lag_accuracies = [];

    tic;
           
    for batch=1:num_samples

        samples = [1:num_samples];
        test_samples = batch;
        samples(ismember(samples,test_samples)) = [];
        train_samples = samples;

        clearCausalModels(cwd);

        % construct a causal model from multiple training samples.
        for i=1:num_case
            for j=1:size(train_samples,2)
                train_idx = train_samples(j);
                train_param.cause_string = causes{i};
                train_param.model_name = ['cause' num2str(i) '-' num2str(train_idx)];
                % explainExperimentSigmod2015_v2(data.test_datasets{i,train_idx}, data.abnormal_regions{i,train_idx}, data.normal_regions{i,train_idx}, [], num_discrete, diff_threshold, outlier_multiplier, true, causes{i}, ['cause' num2str(i) '-' num2str(train_idx)]);
                [e c p detected_lag_accuracy] = explainExperimentSigmod2015_v2(data.test_datasets{i,train_idx}, data.abnormal_regions{i,train_idx}, data.normal_regions{i,train_idx}, [], train_param);
				detected_lag_accuracies = horzcat(detected_lag_accuracies, detected_lag_accuracy);
                % lags(end+1) = lag;
            end
        end

        % calculate confidence
        for i=1:num_case
            for j=1:size(test_samples,2)
                test_idx = test_samples(j);

                % explanation = explainExperimentSigmod(datasets{c,test_idx}.fields{1}, datasets{c,test_idx}.fields{2}, outliers{c,test_idx}, num_discrete, diff_threshold, outlier_multiplier);
                % explanation = explainExperimentSigmod2015_v2(data.test_datasets{i,test_idx}, data.abnormal_regions{i,test_idx}, data.normal_regions{i,test_idx}, [], num_discrete, diff_threshold, outlier_multiplier);
                explanation = explainExperimentSigmod2015_v2(data.test_datasets{i,test_idx}, data.abnormal_regions{i,test_idx}, data.normal_regions{i,test_idx}, [], test_param);
                for k=1:num_case
					c2 = k;
                    compare = strcmp(explanation, causes{c2});
                    idx = find(compare(:,1));
                    if ~isempty(idx)
                        confidence{k,i}(end+1) = explanation{idx, 2};
                        fscore{k,i}(end+1) = explanation{idx, 4};
                    end
                end
            end
        end
    end
    
    save('evaluation_merged_causal_models_leave_one_out', 'confidence');
    timeElapsed = toc
end
