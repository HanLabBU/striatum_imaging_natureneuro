function [chi2, p, df, yatesused, e] = chi2tbl(tbl,yates)
if nargin < 2
    yates = 1;
end
yatesused = 0;
df = (size(tbl,1)-1)*(size(tbl,2)-1);
coltot = sum(tbl,1);
rowtot = sum(tbl,2);
tot = sum(sum(tbl));
colprops = coltot/tot;
colpropsrep = repmat(colprops,size(tbl,1),1);
e = bsxfun(@times,colpropsrep,rowtot);
if any(e(:) < 5) || sum(tbl(:)) < 25
    if sum(tbl(:)) < 25 || ~any(e(:) < 5)
        disp('sum less than 25, using yates correction');
    end
    chi2 = sum(sum((abs(tbl-e)-.5*yates).^2./e));
    yatesused = yates;
else
    chi2 = sum(sum((abs(tbl-e)).^2./e));
end
p = chi2cdf(chi2,df,'upper');
disp(sprintf('total counts: %d, minimum expected: %d',sum(tbl(:)),min(e(:))));
end