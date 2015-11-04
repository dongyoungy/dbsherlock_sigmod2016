function [result top_one_correct] = testNumberOfCorrectIdentification(confidence)
    num_case = size(confidence,1);
    num_samples = size(confidence{1,1},2);
    result = {};
     
    for i=1:num_case
        correct_count = zeros(num_case, 1);
        for j=1:num_samples
            correct_confidence = confidence{i,i}(j);
            other_cases = [1:num_case];
            other_cases(ismember(other_cases,i)) = [];
            other_cases(ismember(other_cases,3)) = []; % remove DB maintenance
            others = vertcat(confidence{other_cases, i});
            others = others(:,j);
            others(find(isnan(others)))=0;
            
            others_sorted = sortrows(others, -1);
            
            max_confidence_others = max(others);
            for k=1:size(others_sorted,1)
                if (correct_confidence > others_sorted(k))
                    correct_count(k,1) = correct_count(k,1) + 1;
                end
            end
            correct_count(num_case,1) = num_samples;
%             if (correct_confidence > max_confidence_others)
%                 correct_count = correct_count + 1;
%             end
        end    
        result{i} = correct_count;
    end

    total_sample = 0;
    correct_sample = 0;

    for i=1:num_case
        if i==3
            continue % skip DB maintenance
        end
        correct_count = result{i};
        correct_sample = correct_sample + correct_count(1);
        total_sample = total_sample + num_samples;
    end
    top_one_correct = correct_sample / total_sample;
end