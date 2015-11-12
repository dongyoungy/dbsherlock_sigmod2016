function [outlier, outlier_size] = outlier_detection(latency_in)
    
    latency_size = size(latency_in, 1);
    latency_median = median(latency_in);
    
    latency = latency_in;
    [latency, index] = sort(latency);
    temp = [];
    
    for i = 1:floor(latency_size/2)
        for j = (floor(latency_size/2)+1):latency_size
                if latency(i) ~= latency(j)
                    tmp = (latency(j)+latency(i)-2*latency_median)/(latency(j)-latency(i));
                    temp = [temp,tmp];
                end
        end
    end
   
    mc = median(temp);
    
   q3 = quantile(latency_in, 0.75);
   q1 = quantile(latency_in, 0.25);
   IQR = q3 - q1;
   
   L = 0;
   U = 0;
  
   if mc >= 0
        L = q1 - 1.5*exp(-1.5*mc)*IQR;
        U = q3 + 1.5*exp(2*mc)*IQR;
   else
        L = q1 - 1.5*exp(-2*mc)*IQR;
        U = q3 + 1.5*exp(1.5*mc)*IQR;
   end


   
    %plot(latency);
    
   outlier = [];
   outlier_size = 0;
   
   for k = 1:latency_size
        if  latency_in(k) >= U
            outlier_size = outlier_size + 1;
            outlier = [outlier, k];
        end
   end

   
   if outlier_size <= 0.05*latency_size
      outlier_size = floor(0.05*latency_size);
      outlier = index(latency_size-outlier_size+1:latency_size);
   end

end