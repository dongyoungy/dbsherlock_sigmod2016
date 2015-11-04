% to use with mix cases

function result = testNumberOfCorrectIdentificationInTopK(confidence, K)
    
    
    mix_cases = [9:14];
    num_case = size(mix_cases,2);
    num_samples = 11;
    result = {};
    correct_answers = [2 6 8;1 7 0;1 5 0;1 6 0; 1 2 0; 1 8 0];
     
    for i=1:num_case
        case_no = mix_cases(i);
        correct_count = zeros(num_samples, 1);
        for j=1:num_samples
            confidences = [];
            for n=1:8
                confidences(n,1) = n;
                confidences(n,2) = confidence{n, case_no}(j);
            end
            confidences = sortrows(confidences, -2);
            top_k = confidences([1:K],1);
            
%             correct_answers(i,:)
            for k=1:K
%                 top_k(k)
                if (ismember(top_k(k), correct_answers(i,:)))
                    
                    correct_count(j) = correct_count(j) + 1;
                end
            end
        end    
        result{i} = correct_count;
    end
end