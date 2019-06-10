% use Welford algorithm to update mean and variance (https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance)
function stats = online_variance(stats,cdata)
    for s=1:size(cdata,2) 
        if isnan(cdata(1,s))
            continue
        end
        stats.n = stats.n + 1;
        delta = cdata(:,s)-stats.mn;
        stats.mn = stats.mn + delta/stats.n;
        delta2 = cdata(:,s)-stats.mn;
        stats.m2 = stats.m2 + delta.*delta2;
       if mod(s,100000) == 0
           fprintf('%0.5f\n',s/size(cdata,2));
       end
    end
end
