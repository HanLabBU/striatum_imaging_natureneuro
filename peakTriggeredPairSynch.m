function C = peakTriggeredPairSynch(traces, peaks, radius, ind1,ind2)
peakinds = find(peaks);
invalid =  (peakinds <= radius) | (peakinds >= (size(traces,1)-radius+1));
peakinds(invalid) = [];

pairs = nchoosek(1:size(traces,2),2);
C = [];
for p=1:length(peakinds)  
    inds = (peakinds(p)-radius):(peakinds(p)+radius);
    C = cat(2,C,traces(inds([ind1 ind2]),pairs(:,1)) & traces(inds([ind1 ind2]),pairs(:,2)));
end     
C = sparse(C');
end