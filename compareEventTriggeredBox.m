function [pvals, stat, prevals, postvals] = compareEventTriggeredBox(mvmtstruct1,mvmtstruct2,radius)
%get pre vs post event time points
midpoint = (size(mvmtstruct1.mvmt,1)-1)/2 +1;
premid = (midpoint-(radius)):(midpoint-1);
postmid = (midpoint+1):(midpoint+radius);

% for each cell type, do a ranksum
%msn
prevals.msn = nanmean(mvmtstruct1.msn(premid,:),1);
postvals.msn = nanmean(mvmtstruct2.msn(postmid,:),1);
[pvals.msn, stat.msn] = signtest_explicit(prevals.msn,postvals.msn);

%fsi
prevals.fsi = nanmean(mvmtstruct1.fsi(premid,:),1);
postvals.fsi = nanmean(mvmtstruct2.fsi(postmid,:),1);
[pvals.fsi, stat.fsi] = signtest_explicit((prevals.fsi),postvals.fsi);

%chi
prevals.chi = nanmean(mvmtstruct1.chi(premid,:),1);
postvals.chi = nanmean(mvmtstruct2.chi(postmid,:),1);
[pvals.chi, stat.chi] = signtest_explicit(prevals.chi,postvals.chi);


%construct bar plots
mnmat = [{(prevals.msn(:))}, {(prevals.chi(:))}, {(prevals.fsi(:))};
        {(postvals.msn(:))}, {(postvals.chi(:))}, {(postvals.fsi(:))}];
    
[ax,l] = box_err( mnmat );
    title('Mean +/- SEM \DeltaF/F');
    ylabel('\DeltaF/F');
    legend(l,{'MSN','CHI','FSI'},'Location','NorthWest');
set(ax,'XTickLabel',{'Pre-event', 'Post-event'});

end