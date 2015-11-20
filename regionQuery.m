function neighbor = regionQuery(data, i, eps)
        data_size = size(data, 1);
        dimension = size(data, 2);
        minimum = repmat(min(data), data_size, 1);
        range = repmat(max(data)-min(data), data_size, 1);
        zero_range = find(range == 0);
        range(zero_range) = 1;
        data = (data - minimum)./range;
        neighbor = [];
        for j = 1:data_size
                distance = 0;
                for k=1:dimension
                    distance = distance + (data(i,k)-data(j,k))^2;
                end
                %non_zero_data = find(max(data) ~= min(data));
                distance = sqrt(distance);
                if distance <= eps
                        neighbor = [neighbor, j];
                end
        end
end
