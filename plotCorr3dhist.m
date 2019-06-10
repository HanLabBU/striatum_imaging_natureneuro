function plotCorr3dhist(corrcoeff,sigonly,normalized)

fnames = fieldnames(corrcoeff);
for f=1:numel(fnames)
    figure
    d = corrcoeff.(fnames{f}).d2;
    d = bsxfun(@times,d, datasample([-1 1], length(d))');
    bins = -1300:50:1300;
    if sigonly
        inds = find(corrcoeff.(fnames{f}).p <.05);
    else
        inds = 1:size(d,1);
    end
    N = hist3(d(inds,:),{bins, bins});
    if normalized == 1
        N2 = N./nanmean(N(:));
    elseif normalized == 2
        Nall = hist3(d,{bins,bins});
        N2 = N./Nall;
    elseif normalized == 3
        N2 = N./sum(N(:));
    else
        N2 = N;
    end
    imagesc(bins, bins, N2'); axis xy
    title('MSN-MSN');
    %caxis([0 22])
    colorbar
    title(sprintf('Color = num significant/mean in each bin'));
    savePDF(gcf,sprintf('figures/%s/corrcoeff_3dhist_%s.pdf',date,fnames{f}));

    figure;
    plot(bins,log(nansum(N2,2)));
    xlabel('Distance in X Direction [\um]');
    ylabel('Count (normalized)');%ylim([0 250]);
    xlim([-750 750]);
    ylim([0 6]);
    savePDF(gcf,sprintf('figures/%s/corrcoeff_2dhist_xdirection_%s.pdf',date,fnames{f}));

    figure;
    plot(bins,log(nansum(N2,1)));
    xlabel('Distance in Y Direction [\um]');
    ylabel('Count (normalized');
    xlim([-750 750]);
    ylim([0 6]);
    savePDF(gcf,sprintf('figures/%s/corrcoeff_2dhist_ydirection_%s.pdf',date,fnames{f}));



end
end