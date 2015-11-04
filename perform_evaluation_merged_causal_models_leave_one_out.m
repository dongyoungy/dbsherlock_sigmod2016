function [confidence fscore] = perform_merged_causal_models_leave_one_out(num_discrete, diff_threshold, outlier_multiplier)

    cwd = pwd;
    data = load('dbsherlock_datasets.mat');

    num_case = size(data.test_datasets, 1);
    % num_case = 10;
    num_samples = size(data.test_datasets, 2);
    % num_samples = 7;

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
    
    if isempty(num_discrete)
        num_discrete = 500;
    end
    if isempty(outlier_multiplier)
        outlier_multiplier = 10;
    end
    if isempty(diff_threshold)
        diff_threshold = 0.2;
    end
    
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
                explainExperimentSigmod2015_v2(data.test_datasets{i,train_idx}, data.abnormal_regions{i,train_idx}, data.normal_regions{i,train_idx}, [], num_discrete, diff_threshold, outlier_multiplier, true, causes{i}, ['cause' num2str(i) '-' num2str(train_idx)]);
            end
        end

        % calculate confidence
        for i=1:num_case
            for j=1:size(test_samples,2)
                test_idx = test_samples(j);

                % explanation = explainExperimentSigmod(datasets{c,test_idx}.fields{1}, datasets{c,test_idx}.fields{2}, outliers{c,test_idx}, num_discrete, diff_threshold, outlier_multiplier);
                explanation = explainExperimentSigmod2015_v2(data.test_datasets{i,test_idx}, data.abnormal_regions{i,test_idx}, data.normal_regions{i,test_idx}, [], num_discrete, diff_threshold, outlier_multiplier);
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
