function plotAllCorrScatter(suffix)
for m=1:numel(suffix)
    load([suffix{m} '_pairwiseasymmcorr_rp2.mat']);
    corrdata = squeezeACorr(corrdata);
    figure
    plotCorrScatter(corrdata,0);
    
    %next few lines from:
    set(gcf,'NextPlot','add');
    axes;
    h = title(suffix{m});
    set(gca,'Visible','off');
    set(h,'Visible','on'); 
    %%%%%%%%%%%%%%%%%%%%%
    savePDF(gcf,sprintf('figures/%s/%s_acorr_scatter.pdf',date,suffix{m}));
end

end