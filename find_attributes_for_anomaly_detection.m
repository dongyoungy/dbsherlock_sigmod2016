function [attr_index_list attributes] = find_attributes_for_anomaly_detection(data)

	%data = dataset.data;
	%field_names = dataset.field_names;

	numRow = size(data,1);
	numAttr = size(data,2);
	window_size = 5;
	attributes = {};
	attr_index_list = [];
	attr_count = 1;

	for i=2:numAttr
		%attribute_name = field_names{i};
		%if ~isempty(strfind(attribute_name, 'dbmsCum'))
			%continue;
		%end

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
		max_window_mean_diff = 0;

		for j=1:len-window_size+1
			window_mean(j) = median(column_data(j:j+window_size-1));
			if j > 1
				mean_diff = abs(window_mean(j) - window_mean(j-1));
				if mean_diff > max_window_mean_diff 
					max_window_mean_diff = mean_diff;
				end
			end
		end
		if max_window_mean_diff > 0.4
			attr_index_list(end+1) = i;
			attributes{attr_count,1} = i;
			attributes{attr_count,2} = max_window_mean_diff;
			%attributes{attr_count,3} = field_names{i};
			attr_count = attr_count + 1;
		end
	end
end
