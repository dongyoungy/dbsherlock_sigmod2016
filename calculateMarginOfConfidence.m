function [moc] = calculateMarginOfConfidence(confidence)
   moc = []; 
   num_case = size(confidence,1);
   for i=1:num_case
       conf = confidence{i,i};
       conf(isnan(conf)) = 0;
       moc(i) = mean(conf);
   end

   for i=1:num_case
       sameOtherConfidence(i,1) = mean(confidence{i,i});
       otherConfidence = [];
       for j=1:num_case
        if i == j || j==3
          continue
        end
        otherConfidence(end+1) = mean(confidence{j,i});
       end
       otherMaxConfidence = max(otherConfidence);
       moc(i) = moc(i) - otherMaxConfidence;
   end
end