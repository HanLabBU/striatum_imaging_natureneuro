function C = segmentCorr(traces, segs)
mat = tril(ones(size(traces,2)),-1);
pairs = zeros(sum(mat(:)),2);
[pairs(:,1),pairs(:,2)] = find(mat);
C = nan(sum(mat(:)),size(segs,1));
for p=1:size(segs,1)
    inds = segs(p,1):segs(p,2);
    C(:,p) = corr_fast(traces(inds,pairs(:,1)),traces(inds,pairs(:,2)))/size(segs,1);
end
C = sum(C,2);
end