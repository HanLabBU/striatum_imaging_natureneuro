function Xout = reshapeSpCell(X) %should be cell with entries that are sparse matrices of identical size
    Xout = cell(0);
    numShuffles = size(X{1},2);
    numROIs = numel(X);
    lenCell = size(X{1},1);
    for s=1:numShuffles
        currcell = sparse(lenCell,numROIs);
        for r=1:numROIs
            currcell(:,r) = X{r}(:,s);
        end
        Xout{s} = sparse(currcell);
    end

end