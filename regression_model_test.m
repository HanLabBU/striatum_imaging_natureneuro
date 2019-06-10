function [c,z] = regression_model_test(b,test_data, no_reps)
    if nargin < 3
        no_reps = 0;
    end
    c = nan(size(b));
    z = nan(size(c,1),size(c,2),no_reps);
    for m=1:size(b,1)
        for j=1:size(b,2)
            if isempty(b{m,j})
                continue
            end
            yhat = test_data{m}(j).X*b{m,j};
            y = test_data{m}(j).Y;
            c(m,j) = corr(yhat, y);
        end
    end
end