function [pvals, stat, prevals, postvals] = compareEventTriggeredSigIndsBox(mvmtstruct1,mvmtstruct2,sigInds,field,radius)
%get pre vs post event time points
midpoint = (size(mvmtstruct1.(field),1)-1)/2 +1;
% get indices before center
premid = (midpoint-(radius)):(midpoint-1);
% get indices after center
postmid = (midpoint+1):(midpoint+radius);

% for each cell type, do a sign test
%negatively modulated
prevals.neg = nanmean(mvmtstruct1.(field)(premid,sigInds.neg.(field)),1);
postvals.neg = nanmean(mvmtstruct2.(field)(postmid,sigInds.neg.(field)),1);
[pvals.neg, stat.neg] = signtest_explicit(prevals.neg,postvals.neg);

%positively modulated
prevals.pos = nanmean(mvmtstruct1.(field)(premid,sigInds.pos.(field)),1);
postvals.pos = nanmean(mvmtstruct2.(field)(postmid,sigInds.pos.(field)),1);
[pvals.pos, stat.pos] = signtest_explicit((prevals.pos),postvals.pos);

% get non-modulated indices
non = ~sigInds.pos.(field) & ~sigInds.neg.(field);

%non
prevals.non = nanmean(mvmtstruct1.(field)(premid,non),1);
postvals.non = nanmean(mvmtstruct2.(field)(postmid,non),1);
[pvals.non, stat.non] = signtest_explicit(prevals.non,postvals.non);

if sum(~isnan(prevals.neg(:))) < 10 || sum(~isnan(prevals.pos)) < 10
warning('less than 10!!');
end

%construct bar plots
X = [{prevals.neg(:)}, {prevals.pos(:)}, {prevals.non(:)};
        {postvals.neg(:)}, {postvals.pos(:)}, {postvals.non(:)}];

[f,l] = box_err(X);
    title('Mean +/- SEM \DeltaF/F');
    ylabel('\DeltaF/F');
    legend(l,{'NEG','POS','NON'},'Location','NorthWest');
set(f,'XTickLabel',{'Pre-event', 'Post-event'});

end