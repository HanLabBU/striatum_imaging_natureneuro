function Xout = bin(X, edges, taxis)
    taxis = taxis-taxis(1);
    if numel(edges) == 1
        edges = 0:edges:(taxis(end)+edges);
    end
    Xout = nan(length(edges)-1,size(X,2));
    for b=1:length(edges)-1
        inds = taxis >= edges(b) & taxis < edges(b+1);
        Xout(b,:) = nanmean(X(inds,:),1);
    end
end