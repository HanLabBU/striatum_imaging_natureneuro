function stats = chi2statspw(tbl,dim,yates,correct)
if dim==2
    tbl = tbl';
end

pairs = nchoosek(1:size(tbl,1),2);
stats.df = zeros(max(pairs(:,1))+1);
stats.p = zeros(max(pairs(:,1))+1);
stats.chi2 = zeros(max(pairs(:,1))+1);
stats.yates = zeros(max(pairs(:,1))+1);
ptemp = zeros(size(pairs,1),1);
for p=1:size(pairs,1)
    currp = pairs(p,:);
    p1 = currp(1);
    p2 = currp(2);
    currtbl = [tbl(p1,:); tbl(p2,:)];
    [stats.chi2(p1,p2), ptemp(p), stats.df(p1,p2), stats.yates(p1,p2)] = ...
        chi2tbl(currtbl,yates);
end

if correct
%     ptemp = holmbonferroni(ptemp);
    ptemp = ptemp*size(pairs,1);
end

for p=1:size(pairs,1)
    currp = pairs(p,:);
    p1 = currp(1);
    p2 = currp(2);
    stats.p(p1,p2) = ptemp(p);
end

end