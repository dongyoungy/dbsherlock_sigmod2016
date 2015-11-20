function [attr_index_list attributes] = find_attributes_for_anomaly_detection(data, field_names)

%data = dataset.data;
%field_names = dataset.field_names;

	numRow = size(data,1);
	numAttr = size(data,2);
	corr = corrcoef(data);
	window_size = 20;
	attributes = {};
	attr_index_list = [];
	attr_count = 1;

	for i=2:numAttr
		if ~isempty(field_names)
			attribute_name = field_names{i};
			if ~isempty(strfind(attribute_name, 'dbmsCum')) || ~isempty(strfind(attribute_name, 'osInter')) || ~isempty(strfind(attribute_name, 'osAlloc'))
				continue;
			end
		end

		column_data = data(:,i);
		data_range = range(column_data);

		% skip data with 0 range
		if data_range == 0
			continue
		end

		column_data = column_data / data_range; % normalize
		start_index = find(column_data, 1, 'first');
		end_index = find(column_data, 1, 'last');
		column_data = column_data(start_index:end_index);
		len = size(column_data,1);

		window_mean = [];
		median_value = median(column_data);
		max_window_mean_diff = 0;

		%median_diff = sum(abs(column_data - median_value));

		for j=1:len-window_size+1
			window_mean(j) = median(column_data(j:j+window_size-1));
			median_diff = abs(window_mean(j) - median_value);
			if median_diff > max_window_mean_diff 
				max_window_mean_diff = median_diff;
			end

			%if j > 1
				%mean_diff = abs(window_mean(j) - window_mean(j-1));
				%if mean_diff > max_window_mean_diff 
					%max_window_mean_diff = mean_diff;
				%end
			%end
		end
		%if abs(corr(2,i)) > 0.2
		if max_window_mean_diff > 0.3
		%if median_diff > 0.0
			attr_index_list(end+1) = i;
			attributes{attr_count,1} = i;
			attributes{attr_count,2} = max_window_mean_diff;
			%attributes{attr_count,2} = abs(corr(2,i));
			attributes{attr_count,3} = field_names{i};
			attr_count = attr_count + 1;
		end
	end
end
