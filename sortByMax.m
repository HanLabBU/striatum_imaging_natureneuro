%rows are samples, columns are rois 
function [X, I] = sortByMax(X)
    zs = find(sum(X) == 0 | isnan(sum(X)));
    
    Z = X(:,zs);
    X(:,zs) = [];
    [~, i] = max(X,[],1);
    [~, I] = sort(i);
    X = X(:,I);
end