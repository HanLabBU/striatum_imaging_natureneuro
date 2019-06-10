function [C, npairs,npeaks] = peakTriggeredPairSynchSum(traces, peaks, radius)
peakinds = find(peaks);
invalid =  (peakinds <= radius) | (peakinds >= (size(traces,1)-radius+1));
peakinds(invalid) = [];
Nmsns = size(traces,2);

C = zeros(2*radius+1,1);

for p=1:length(peakinds)  
    inds = (peakinds(p)-radius):(peakinds(p)+radius);
    n = sum(traces(inds,:),2);
    n = max(cat(2,n,ones(size(n))),[],2);
    C = C + n.*(n-1)/2;
end     
npairs = (Nmsns*(Nmsns-1)/2);
npeaks = length(peakinds);

end