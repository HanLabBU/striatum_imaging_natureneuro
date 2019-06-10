
function [c, samples] = kfoldvalidate_all(traces,y, num_folds)
    c = nan(size(traces,2),num_folds);
    samples.pred = [];
    samples.c = [];
    randints = randperm(size(traces,2),min(size(traces,2),5));
    for roi=1:size(traces,2)
        currtr = traces(:,roi);
        x = zscore(currtr);
        X = cat(2,ones(size(x,1),1),x);
        [c(roi,:), ~] = kfoldvalidate(X,y,num_folds);
        if any(roi == randints)
            %train on whole dataset
            b = regress(y,X);
            samples.pred = cat(2,samples.pred,X*b);
            samples.c = cat(1,samples.c,nanmean(c(roi,:)));
        end
    end
end