function [confidence_orig confidence_pa confidence_dbscan] = perform_evaluation_anomaly_detection(num_discrete, diff_threshold, abnormal_multiplier, introduce_lag, find_lag)
%function [confidence fscore detected_lag_accuracies] = perform_evaluation_anomaly_detection(num_discrete, diff_threshold, abnormal_multiplier, introduce_lag, find_lag)

		cwd = pwd;
		data = load('dbsherlock_datasets.mat');

		num_case = size(data.test_datasets, 1);
		%num_case = 1;
		num_samples = size(data.test_datasets, 2);
		%num_samples = 11;

		confidence_orig = cell(num_case, num_case);
		confidence_pa = cell(num_case, num_case);
		confidence_dbscan = cell(num_case, num_case);
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

								% run our own anomaly detection algorithm
								%abnormal_region = runAnomalyDetection2(data.test_datasets{i,test_idx});
								test_data = data.test_datasets{i,test_idx}.data;
								test_data = expand_normal_region(test_data, 480, data.abnormal_regions{i,test_idx}, data.normal_regions{i,test_idx});
								abnormal_region_dbscan = DBScan(test_data, data.test_datasets{i,test_idx}.field_names, 0.01, 3);
								%abnormal_region_pa = runPerfAugur(test_data);
								%abnormal_region_orig = data.abnormal_regions{i, test_idx};

								new_test_data = struct();
								new_test_data.data = test_data;
								new_test_data.field_names = data.test_datasets{i, test_idx}.field_names;

								%explanation = explainExperimentSigmod2015_v2(data.test_datasets{i,test_idx}, data.abnormal_regions{i,test_idx}, data.normal_regions{i,test_idx}, [], test_param);
								%explanation = explainExperimentSigmod2015_v2(data.test_datasets{i,test_idx}, abnormal_region, data.normal_regions{i,test_idx}, [], test_param);
								%explanation_orig = explainExperimentSigmod2015_v2(new_test_data, abnormal_region_orig, data.normal_regions{i,test_idx}, [], test_param);
								%explanation_pa = explainExperimentSigmod2015_v2(new_test_data, abnormal_region_pa, data.normal_regions{i,test_idx}, [], test_param);
								explanation_dbscan = explainExperimentSigmod2015_v2(new_test_data, abnormal_region_dbscan, data.normal_regions{i,test_idx}, [], test_param);
								%for k=1:num_case
										%c2 = k;
										%compare = strcmp(explanation_orig, causes{c2});
										%idx = find(compare(:,1));
										%if ~isempty(idx)
												%confidence_orig{k,i}(end+1) = explanation_orig{idx, 2};
												%%fscore{k,i}(end+1) = explanation{idx, 4};
										%end
								%end
								%for k=1:num_case
										%c2 = k;
										%compare = strcmp(explanation_pa, causes{c2});
										%idx = find(compare(:,1));
										%if ~isempty(idx)
												%confidence_pa{k,i}(end+1) = explanation_pa{idx, 2};
												%%fscore{k,i}(end+1) = explanation{idx, 4};
										%end
								%end
								for k=1:num_case
										c2 = k;
										compare = strcmp(explanation_dbscan, causes{c2});
										idx = find(compare(:,1));
										if ~isempty(idx)
												confidence_dbscan{k,i}(end+1) = explanation_dbscan{idx, 2};
												%fscore{k,i}(end+1) = explanation{idx, 4};
										end
								end
						end
				end
		end
		
		%save('evaluation_merged_causal_models_anomaly_detection', 'confidence');
		timeElapsed = toc
end
