
function [c,b] = kfoldvalidate(X,y,num_folds)
    test_len = floor(length(y)/num_folds);
    fold_steps = 0:(test_len):length(y);
    b = nan(size(X,2),num_folds);
    c = nan(1,num_folds);
    for j=1:num_folds
        train_inds = setdiff(1:size(y,1),(fold_steps(j)+1):fold_steps(j+1));
        test_inds = (fold_steps(j)+1):(fold_steps(j+1));
        xtrain = X(train_inds,:);
        ytrain = y(train_inds);
        if any(isnan(xtrain))
            continue
        end
        b(:,j) = regress(ytrain,xtrain);
        y_pred = X(test_inds,:)*b(:,j);
        c(j) = corr(y_pred,y(test_inds));
    end
end