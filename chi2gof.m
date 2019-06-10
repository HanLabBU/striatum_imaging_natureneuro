
function stats = chi2gof(n,yates)
numel = length(n);
ntot = sum(n);
psr = sum(n)/ntot/numel;
e = repmat(psr*ntot, 1,numel);

if any(e < 5) || (nargin > 1 && yates) || sum(n) < 25
    if sum(n) < 25
        disp('sum < 25');
    end
    fprintf('using yates correction unless otherwise specified\n');
    stats.chi2 = sum((abs(n-e)-.5).^2./e);
    stats.yatesused = 1;
else
    stats.chi2 = sum((n-e).^2./e);
    stats.yatesused = 0;
end


stats.df = numel-1;
stats.p = chi2cdf(stats.chi2, stats.df, 'upper');
disp(sprintf('%dx1 total counts: %d, min expected: %d',length(n),sum(n), min(e)));
stats.e = e;
end
