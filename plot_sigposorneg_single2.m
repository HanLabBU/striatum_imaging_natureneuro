function plot_sigposorneg_single2(peaksDY, sigIndsDY, tstatsDY, suffix)
 taxis = .0469*(-50:50);
    sigindspos = cat(1,sigIndsDY.msn.pos,sigIndsDY.chi.pos,sigIndsDY.fsi.pos);
    sigindsneg = cat(1,sigIndsDY.msn.neg,sigIndsDY.chi.neg,sigIndsDY.fsi.neg);
    tvalpos = cat(1,tstatsDY.msn.pos,tstatsDY.chi.pos, tstatsDY.fsi.pos);
    tvalneg = cat(1,tstatsDY.msn.neg, tstatsDY.chi.neg, tstatsDY.fsi.neg);
    %just for msns right now
    n.pos = sum(sigindspos);
    n.tot = length(sigindspos);
    n.neg = sum(sigindsneg);

    peaksAll = cat(2,peaksDY.msn,peaksDY.chi,peaksDY.fsi);
    
    roipos = peaksAll(:,logical(sigindspos));
    tvalpos = tvalpos(logical(sigindspos)); %get only positive z values
    
    roineg = peaksAll(:,logical(sigindsneg));
    tvalneg = tvalneg(logical(sigindsneg)); % get only negative z values
    
    msnnone = peaksAll(:,~logical(sigindspos) & ~logical(sigindsneg)); % get fluorescence for those not modulated
    
    figure;
    shadedErrorBar(taxis, nanmean(msnnone,2),serrMn(msnnone,2),'k');
    hold on;
    shadedErrorBar(taxis,nanmean(roipos,2), serrMn(roipos,2),'r');
    shadedErrorBar(taxis,nanmean(roineg,2), serrMn(roineg,2),'b');
    text(-2,.08,sprintf('prop. pos: %d',n.pos/n.tot));
    text(-2,.06,sprintf('prop. neg: %d',n.neg/n.tot));
    savePDF(gcf,sprintf('figures/%s/onset_posorneg_shadederrbar_%s.pdf',date,suffix));
    %now plot false color images

    figure;
    [~,j] = sort(tvalpos,'descend');
    [~,i] = sort(tvalneg,'descend');
    pon = cat(1,roineg(:,i)',roipos(:,j)');
    imagesc(taxis, 1:size(pon,1),pon); colormap(jet); colorbar
    xlabel('Time [s]')
    ylabel('ROI');
    savePDF(gcf,sprintf('figures/%s/onset_posorneg_sorted_%s.pdf',date,suffix));
    caxis([-.05 .8])
    hold off
            
end