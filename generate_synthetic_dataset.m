function [dataset g domain_knowledge root_causes correct_filter_list] = generate_synthetic_dataset(num_var, length, abnormal_length, abnormal_start)

	assert(abnormal_length < length);
	assert(abnormal_start < length);
	assert(num_var > 1);

	dataset = struct();

	% 1 - timestamp, 2 - response variable (latency?)
	data = zeros(length, num_var + 2);
	data(:,1) = [1:length]';

	% generate adjacency graph with no cycle.
	while true
		edges = randi([0 1], num_var+1, num_var+1);
		edges(1:num_var+2:end) = 0;
		%if sum(edges(1,:)) == 0 || sum(edges(:,num_var+1)) == 0 || sum(edges(num_var+1,:)) > 0
			%continue;
		%end
		if sum(edges(:,num_var+1)) == 0 || sum(edges(num_var+1,:)) > 0
			continue
		end

		%invalid = false;
		%for i=1:size(domain_knowledge,1)
			%s = domain_knowledge(i,1);
			%e = domain_knowledge(i,2);

			%% cannot allow reverse arrow compared to domain knowledge
			%if edges(e,s) == 1
				%invalid = true;
				%break;
			%end
		%end
		%if invalid
			%continue
		%end

		edges_n = edges;
		got_cycle = false;
		for i=2:num_var+1
			edges_n = edges_n * edges;
			if trace(edges_n) ~= 0
				got_cycle = true;
				break;
			end
		end

		if ~got_cycle
			break;
		end
	end

	root_causes = [];
	%for i=1:num_var
		%if sum(edges(:,i)) == 0
			%root_causes(end+1) = i;
		%end
	%end
	
	root_causes = find_root_causes(edges, num_var+1, root_causes);
	root_causes = unique(root_causes);
	%other_var = setdiff([1:num_var], root_causes);
	%random_var = other_var(randperm(size(other_var,2)));

	% generate domain knowledge
	domain_knowledge = [];
	for i=1:size(root_causes, 2)
		cause = root_causes(i);
		other_var = setdiff([1:num_var], cause);
		random_var = other_var(randperm(size(other_var,2)));
		effect_size = randi([1 size(random_var,2)]);

		domain_knowledge(i, 1) = cause;
		for j=1:effect_size
			isCycle = false;
			% detect cycle between root causes.
			for k=1:i-1
				if random_var(j) == domain_knowledge(k, 1)
					isCycle = true;
				end
			end
			if isCycle
				continue
			end
			domain_knowledge(i, j+1) = random_var(j);
		end
	end
	
	correct_filter_list = {};
	paths = {};
	% find all attributes that should be filtered.
	for i=1:size(domain_knowledge,1)
		root = domain_knowledge(i, 1);
		reachable_points = [];
		reachable_points = find_all_reachable_points(edges, root, reachable_points);
		a_path = struct();
		a_path.from = root;
		a_path.to = reachable_points;
		paths{i} = a_path;

		effects = domain_knowledge(i, 2:end);
		should_be_filtered = intersect(reachable_points, effects);
		should_not_be_filtered = setdiff(effects, reachable_points);
		correct_filter_list{i,1} = root;
		correct_filter_list{i,2} = should_be_filtered;
		correct_filter_list{i,3} = should_not_be_filtered;
		%correct_filter_list(i,:) = correct_filter_list(i,:) + 2;
	end

	% similar to PerfAugur's synthetic data
	%normal_mu = 10;
	%normal_sigma = 10;
	%abnormal_mu = 100;
	%abnormal_sigma = 10;
	%noise_mu = -20;
	%noise_sigma = 5;
	%noise_ratio = 0.4;
	%cause_coeff = randi([1 5]);
	%cause_coeff = randi([-10 10]);
	num_confound = 0;

	coeffs = randi([-10 10], num_var+1, num_var+1);
	while ~isempty(find(coeffs==0))
		coeffs = randi([-10 10], num_var+1, num_var+1);
	end
	for i=1:num_confound
		confound_coeffs{i} = randi([-10 10], 1, num_var+1);
		while confound_coeffs{i}==0
			confound_coeffs{i} = randi([-10 10], 1, num_var+1);
		end
	end
	coeffs = coeffs .* edges;

	g = digraph(edges);
	topo_order = toposort(g);

	% generate cause variable
	%cause_var = normrnd(normal_mu, normal_sigma, length, 1);
	% add abnormal region
	%cause_var(abnormal_start:abnormal_start+abnormal_length-1, 1) = normrnd(abnormal_mu, abnormal_sigma, abnormal_length, 1);

	% hidden confound variable
	confound_var = {};
	for i=1:num_confound
		confound_var{i} = normrnd(normal_mu, normal_sigma, length, 1);
	end
	
	%data(:,2) = cause_var * cause_coeff + normrnd(0, 1, length, 1);
	%data(:,3) = cause_var;
	for i=1:size(root_causes, 2)
		idx = root_causes(i);

		%normal_mu = randi([10 20]);
		%normal_sigma = randi([10 20]);
		%abnormal_mu = randi([50 100]);
		%abnormal_sigma = randi([10 20]);

		normal_mu = 10;
		normal_sigma = 10;
		abnormal_mu = 100;
		abnormal_sigma = 10;
		% generate cause variable
		cause_var = normrnd(normal_mu, normal_sigma, length, 1);
		% add abnormal region
		cause_var(abnormal_start:abnormal_start+abnormal_length-1, 1) = normrnd(abnormal_mu, abnormal_sigma, abnormal_length, 1);

		% add error
		data(:,idx+2) = cause_var + normrnd(0, 1, length, 1);

		cause_coeff = randi([-10 10]);
		while cause_coeff == 0
			cause_coeff = randi([-10 10]);
		end

		data(:,2) = data(:,2) + data(:,idx+2) * cause_coeff + normrnd(0, 1, length, 1);
	end

	for i=1:size(topo_order,2)
		idx = topo_order(i);
		%if idx==1 || idx==num_var+1
		%if idx==num_var+1 || ~isempty(find(root_causes==idx))
		if ~isempty(find(root_causes==idx))
			continue
		end

		% variable with no incoming edge.
		if sum(edges(:,idx)) == 0
			data(:,idx+2) = normrnd(0, 1, length, 1);
			continue
		end

		if idx==num_var + 1
			idx = 0;
			for j=1:num_var
				data(:,idx+2) = data(:,idx+2) + data(:,j+2) .* coeffs(j, num_var+1);
			end
		else
			for j=1:num_var
				data(:,idx+2) = data(:,idx+2) + data(:,j+2) .* coeffs(j, idx);
			end
		end


		%data(:, idx+2) = normrnd(normal_mu * randi([2 10], 1, 1), normal_sigma * randi([2 10], 1, 1), length, 1);
		for j=1:num_confound
			data(:,idx+2) = data(:,idx+2) + (confound_var{j} .* confound_coeffs{j}(idx));
		end
		% add error
		data(:,idx+2) = data(:,idx+2) + normrnd(0, 1, length, 1);

		%noise_idx = unique(randi([1 size(data(:,idx+2),1)], 1, floor(size(data(:,idx+2),1) * noise_ratio)));
		%num_noise = size(noise_idx, 2);
		%data(noise_idx, idx+2) = normrnd(noise_mu, noise_sigma, num_noise, 1);

		%data(:,idx+2) = data(:,idx+2) + (confound_var{2} .* confound_coeffs{2}(idx)) + normrnd(0, 1, length, 1);
		%data(:,idx+2) = data(:,idx+2) + (confound_var2 .* confound_coeffs2(idx));
	end

	%data
	%root_causes 

	dataset.data = data;
	field_names = {};
	field_names{1} = 'Epoch';
	field_names{2} = 'Response';
	for i=1:num_var
		field_names{2+i} = ['Pred_' num2str(i)];
	end
	dataset.field_names = field_names;
end
