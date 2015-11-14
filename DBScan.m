function outlier = DBScan(data, eps, minPts)

        data_size = size(data, 1);

        cluster_size = 0;
        visited = zeros(1, data_size);
        is_cluster = zeros(1, data_size);
        
        for i=1:data_size
                if visited(i) == 0
                        visited(i) = 1;            
                        neighbor = regionQuery(data, i, eps);
                        if size(neighbor, 2) < minPts
                                visited(i) = 2;
                        else
                                cluster_size = cluster_size + 1;
                                [visited, clustering{cluster_size}, is_cluster] = expandCluster(data, i , visited, neighbor, is_cluster, eps, minPts);
                        end
                end
        end
        
%         if size(clustering,2) ~= 1
%             size(clustering,2)
%             error('cluster size should be 1.');
%         end
        assert(size(clustering,2) > 1);
        smallest_size = data_size;
        
        for k=1:size(clustering, 2)
               if size(clustering{k}, 2) <= smallest_size
                    smallest_size = size(clustering{k}, 2);
                    outlier = clustering{k};
               end
        end
        
        
end