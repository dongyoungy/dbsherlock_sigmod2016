function reachable_points = find_all_reachable_points(edges, idx, reachable_points)

for i=1:size(edges,2)
	if edges(idx, i) == 1
		reachable_points(end+1) = i;
		reachable_points = find_all_reachable_points(edges, i, reachable_points);
	end
end


end

