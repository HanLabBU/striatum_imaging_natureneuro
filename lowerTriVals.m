function output = lowerTriVals(X)
    lowertri = tril(ones(size(X)),-1);
    output = X(logical(lowertri(:)));
end