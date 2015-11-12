classdef ExperimentParameter < handle
	properties
		delay = 0;
		num_discrete = 500;
		diff_threshold = 0.2;
		abnormal_multiplier = 10;
		create_model = false;
		cause_string = 'Cause';
		model_name = '';
		find_lag = false;
		introduce_lag = false;
		lag_min = 0;
		lag_max = 0;
	end
end % end classdef