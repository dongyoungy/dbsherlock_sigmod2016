function root_causes = find_root_causes(edges, idx, root_causes)

num_var = size(edges, 1);

if sum(edges(:,idx)) ~= 0
	for i=1:num_var
		if edges(i,idx) == 1
			root_causes = find_root_causes(edges, i, root_causes);
		end
	end
else
	root_causes(end+1) = idx;
end

end
