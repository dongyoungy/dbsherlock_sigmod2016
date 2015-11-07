function causal_predicates = find_causal_rule3(data, predicates, num_bagging)
	numRow = size(data,1);
	num_predicates = size(predicates,1);
	causal_predicates = {};

	odd_ratios = [];
	n_12s = [];
	n_21s = [];

	for B=1:num_bagging
		sample_data = [];
		rowCount = 1;
		variable_matrix = zeros(numRow, num_predicates+1);
		samples = randi(numRow, 1, numRow);
		for i=1:size(samples,2)
			if B == 1
				sample_data(rowCount,:) = data(i,:);
			else
				sample_data(rowCount,:) = data(samples(1,i),:);
			end
			rowCount = rowCount + 1;
		end
		% sample_data = data;

		for i=1:numRow
			for j=1:num_predicates
				predicate = predicates(j,:);
				attr_index = predicate{1,1};
				lb = predicate{1,5};
				ub = predicate{1,6};

				if sample_data(i, attr_index) > lb && sample_data(i, attr_index) <= ub
					variable_matrix(i, j) = 1;
				end
			end
			variable_matrix(i,end) = data(i,end);
		end

		associated_predicates = predicates; 
		% associated_predicates = [];

		% find associate rule w.r.t. abnormality
		% for i=1:num_predicates
		% 	z = find(variable_matrix(:,end)==-1);
		% 	p = find(variable_matrix(:,i)==1);
		% 	not_z = find(variable_matrix(:,end)==1);
		% 	not_p = find(variable_matrix(:,i)==0);

		% 	supp_p_z = size(intersect(p, z), 1);
		% 	supp_p_not_z = size(intersect(p, not_z), 1);
		% 	supp_not_p_z = size(intersect(not_p, z), 1);
		% 	supp_not_p_not_z = size(intersect(not_p, not_z), 1);
		% 	odd_ratio = (supp_p_z * supp_not_p_not_z) / (supp_not_p_z * supp_p_not_z);

		% 	low_ci = exp(log(odd_ratio) - 0.67 * (sqrt((1/supp_p_z) + (1/supp_p_not_z) + (1/supp_not_p_z) + (1/supp_not_p_not_z))));
		% 	% if odd ratio is significantly higher than 1.
		% 	% if low_ci > 1
		% 	if odd_ratio > 1
		% 		associated_predicates(end+1, 1) = i;
		% 	end
		% end

		size_diff(1) = size(predicates,1);
		size_diff(2) = size(associated_predicates,1);

		numAttr = size(associated_predicates, 1);

		% isExclusive = zeros(numAttr, numAttr);

		% % check for exclusive variables
		% for p=1:size(associated_predicates, 1)
		% 	for q=1:size(associated_predicates, 1)
		% 		if p == q
		% 			continue
		% 		end

		% 		% check for exclusive variables between P and Q
		% 		P = find(variable_matrix(:,p)==1);
		% 		Q = find(variable_matrix(:,q)==1);
		% 		not_P = find(variable_matrix(:,p)==0);
		% 		not_Q = find(variable_matrix(:,q)==0);

		% 		supp_P_Q = size(intersect(P, Q), 1);
		% 		supp_P_not_Q = size(intersect(P, not_Q), 1);
		% 		supp_not_P_Q = size(intersect(not_P, Q), 1);
		% 		supp_not_P_not_Q = size(intersect(not_P, not_Q), 1);

		% 		epsilon = 0.2 * size(Q,1);
		% 		if supp_P_Q < epsilon || supp_not_P_Q < epsilon
		% 			isExclusive(p, q) = 1;
		% 		end
		% 		%

		% 	end
		% end

		% size(predicates)
		% size(associated_predicates)

		% for each associate (relevant) predicate/variables
		for i=1:size(associated_predicates,1)

			predicate_index = i;
			% predicate_index = associated_predicates(i, 1);

			% build fair data set
			predicate = predicates(predicate_index,:);
			data_fair = [];
			data_p = variable_matrix(find(variable_matrix(:,predicate_index)==1),:);
			data_not_p = variable_matrix(find(variable_matrix(:,predicate_index)==0),:);
			if size(data_p,1) < size(data_not_p,1)
				small_p = data_p;
				big_p = data_not_p;
			else
				big_p = data_p;
				small_p = data_not_p;
			end

			n_12 = 0;
			n_21 = 0;

			for j=1:size(small_p,1)
				t_j = small_p(j,:);
				big_p_size = size(big_p,1);
				for k=1:big_p_size
					if (k > big_p_size)
						break;
					end
					t_k = big_p(k,:);
					fair = true;
					match_count = 0;
					unmatch_count = 0;
					num_control_var = 0;
					for p=1:size(associated_predicates,1)
						if i == p
							continue
						end

						% if isExclusive(i,p) == 1
						% 	continue
						% end

						num_control_var = num_control_var + 1;

						if t_j(p) ~= t_k(p)
							fair = false;
							unmatch_count = unmatch_count + 1;
						else
							match_count = match_count + 1;
						end
					end

					if ~fair
						if (match_count > unmatch_count) && (((t_j(1,end) == -1 && t_j(1,predicate_index) == 1) || (t_j(1,end)==1 && t_j(1,predicate_index)==0)) && ((t_k(1,end) == -1 && t_k(1,predicate_index) == 1) || (t_k(1,end)==1 && t_k(1,predicate_index)==0)))
						% if (match_count > 0.7 * num_control_var) && (((t_j(1,end) == -1 && t_j(1,predicate_index) == 1) || (t_j(1,end)==1 && t_j(1,predicate_index)==0)) && ((t_k(1,end) == -1 && t_k(1,predicate_index) == 1) || (t_k(1,end)==1 && t_k(1,predicate_index)==0)))
							fair = true;
						end
					end

					% if (match_count < unmatch_count)
					% if (match_count < 0.7 * numAttr)
					% 	fair = false;
					% end

					% if ~fair
					% 	if ((t_j(1,end) == -1 && t_j(1,predicate_index) == 1) || (t_j(1,end)==1 && t_j(1,predicate_index)==0)) && ((t_k(1,end) == -1 && t_k(1,predicate_index) == 1) || (t_k(1,end)==1 && t_k(1,predicate_index)==0))
					% 		fair = true;
					% 	end
					% end
					% if ~(((t_j(1,end) == -1 && t_j(1,predicate_index) == 1) || (t_j(1,end)==1 && t_j(1,predicate_index)==0)) && ((t_k(1,end) == -1 && t_k(1,predicate_index) == 1) || (t_k(1,end)==1 && t_k(1,predicate_index)==0)))
					% 	fair = false;
					% end

					if fair
						data_fair(end+1,:) = t_j;
						data_fair(end+1,:) = t_k;
						big_p(k,:) = [];
						big_p_size = size(big_p,1);

						if ((t_j(1,end) == -1 && t_j(1,predicate_index) == 1) || (t_j(1,end)==1 && t_j(1,predicate_index)==0)) && ((t_k(1,end) == -1 && t_k(1,predicate_index) == 1) || (t_k(1,end)==1 && t_k(1,predicate_index)==0))
							n_12 = n_12 + 1;
						elseif ((t_j(1,end) == -1 && t_j(1,predicate_index) == 0) || (t_j(1,end)==1 && t_j(1,predicate_index)==1)) && ((t_k(1,end) == 1 && t_k(1,predicate_index) == 1) || (t_k(1,end)==-1 && t_k(1,predicate_index)==0))
							n_21 = n_21 + 1;
						end
							
						break;
					end
				end
			end

			% if there is a fair dataset.
			if size(data_fair, 1) > 0
				% z = find(data_fair(:,end)==-1);
				% p = find(data_fair(:,predicate_index)==1);
				% not_z = find(data_fair(:,end)==1);
				% not_p = find(data_fair(:,predicate_index)==0);

				% supp_p_z = size(intersect(p, z), 1);
				% supp_p_not_z = size(intersect(p, not_z), 1);
				% supp_not_p_z = size(intersect(not_p, z), 1);
				% supp_not_p_not_z = size(intersect(not_p, not_z), 1);

				% n_11 = supp_p_z + supp_not_p_z;
				% n_12 = supp_p_z + supp_not_p_not_z;
				% n_21 = supp_p_not_z + supp_not_p_z;
				% n_22 = supp_p_not_z + supp_not_p_not_z;

				% n_12 = supp_p_z * supp_not_p_not_z;
				% n_21 = supp_p_not_z * supp_not_p_z;
				% disp 'fair data set'

				pass_pair = false;
				% replace 0 with 1 to avoid infinite odd ratio (as mentioned in the paper).
				if n_21 == 0
					n_21 = 1;
					if n_12 >= 0
						pass_pair = true;
					end
				end

				odd_ratio = n_12/n_21;
				odd_ratios(end+1) = odd_ratio;
				n_12s(end+1) = n_12;
				n_21s(end+1) = n_21;
				low_ci = exp(log(odd_ratio) - 1.96 * sqrt((1/n_12) + (1/n_21)));
				if low_ci > 1 || pass_pair
				% if odd_ratio > 0.9
					found = false;
					for p=1:size(causal_predicates,1)
						if causal_predicates{p,1} == predicate{1,1}
							found = true;
							break;
						end
					end
					if ~found
						causal_predicates(end+1,:) = predicate;
					end
				end
			end
		end
	end
	size_diff(3) = size(causal_predicates, 1);
	if (size_diff(3) == 0)
		odd_ratios
		n_12s
		n_21s
	end
	% size_diff
end