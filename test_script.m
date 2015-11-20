% lag = [5 10 15 20];
% % results_without_lag_detection = {};
% results_with_lag_detection = {};
% % for i=1:size(lag,2)
% % 	[conf fscore] = perform_evaluation_merged_causal_models_leave_one_out(500, 0.05, 10, false, lag(i));

% % 	result = struct();
% % 	result.find_lag = false;
% % 	result.confidence = conf;
% % 	result.fscore = fscore;
% % 	results_without_lag_detection{end+1} = result;
% % end
% for i=1:size(lag,2)
% 	[conf fscore lags] = perform_evaluation_merged_causal_models_leave_one_out(500, 0.05, 10, true, lag(i));
	
% 	result = struct();
% 	result.actual_lag = lag(i);
% 	result.detected_lags = lags;
% 	result.confidence = conf;
% 	result.fscore = fscore;
% 	results_with_lag_detection{end+1} = result;
% end

%conf_with_lag_no_detect = {};
%conf_with_lag_detect = {};
%top1_with_no_detect = [];
%top1_with_detect = [];
%top2_with_no_detect = [];
%top2_with_detect = [];

%for i=1:10
%i
%[conf_with_lag_no_detect{i} fscore_with_lag_no_detect] = perform_evaluation_merged_causal_models_leave_one_out(500, 0.05, 10, true, false);
%[conf_with_lag_detect{i} fscore_with_lag_detect] = perform_evaluation_merged_causal_models_leave_one_out(500, 0.05, 10, true, true);

%[res top1_with_detect(i) top2_with_detect(i)] = testNumberOfCorrectIdentification(conf_with_lag_detect{i});
%[res top1_with_no_detect(i) top2_with_no_detect(i)] = testNumberOfCorrectIdentification(conf_with_lag_no_detect{i});

%end

num_dependent = 0;

for i=1:1000

x = normrnd(10, 10, 1000, 1);
x(100:200, 1) = normrnd(100, 10, 101, 1);
y = normrnd(10, 10, 1000, 1);
y(100:200, 1) = normrnd(100, 10, 101, 1);

p_xy = discretize_2d_continuous_variables(x, y, 100);
p_x = sum(p_xy,2);
p_y = sum(p_xy,1);

entropy_x = calculate_entropy(p_x);
entropy_y = calculate_entropy(p_y);
entropy_xy = calculate_entropy(p_xy);

mutual_information = entropy_x + entropy_y - entropy_xy;
mutual_info_gain = mutual_information^2 / (entropy_x * entropy_y)
plot([x y])
pause;

if mutual_info_gain > 0.25
	num_dependent = num_dependent + 1;
end

end

num_dependent 
