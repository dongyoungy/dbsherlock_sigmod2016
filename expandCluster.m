function [visit, current_cluster, if_cluster] = expandCluster(data, i , visited, neighbor, is_cluster, eps, minPts)
        
        current_cluster = [i];
        is_cluster(i) = 1;
        j = 1;
        neighbor2 = [];
        while j <= size(neighbor,2)
                union_flag = 0;
                if visited(neighbor(j)) == 0
                        visited(neighbor(j)) = 1;
                        neighbor2 = regionQuery(data, neighbor(j), eps);
                        if size(neighbor2, 2) >= minPts
                                union_flag = 1;
                        end
                end
                
                if is_cluster(neighbor(j)) == 0
                        current_cluster = [current_cluster, neighbor(j)];
                        is_cluster(neighbor(j)) = 1;
                end
                
                if union_flag == 0
                    j = j + 1; 
                else
                    neighbor = union(neighbor, neighbor2); 
                    j = 1;
                end
        end
        
        visit = visited;
        if_cluster = is_cluster;
        
end