function distance = euclidian_distance(latency, s, e, anomaly_size)
	
    A = latency(s:s+anomaly_size-1);
    B = latency(e:e+anomaly_size-1);
    
    %A = sort(A)
    %B = sort(B);
    
	distance = 0;
	for i = 1:anomaly_size
		distance = distance + (A(i) - B(i))^2;
	end 
	distance = sqrt(distance);
end