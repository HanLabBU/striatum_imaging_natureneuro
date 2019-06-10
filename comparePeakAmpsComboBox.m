function paData = comparePeakAmpsCombo(mouseno, pctileLo, pctileHi) % done

[peakAmps, peakAmpsHi, peakAmpsLo] = meanPeakAmplitude(mouseno, pctileLo, pctileHi);
ampsByROIMSN = cat(1, peakAmps.msn);

ampsByROICHI = cat(1, peakAmps.chi);

ampsByROIFSI = cat(1, peakAmps.fsi);

ampsByROIMSNHi = cat(1, peakAmpsHi.msn);
ampsByROICHIHi = cat(1, peakAmpsHi.chi);
ampsByROIFSIHi = cat(1, peakAmpsHi.fsi);

ampsByROIMSNLo = cat(1, peakAmpsLo.msn);
ampsByROICHILo = cat(1, peakAmpsLo.chi);
ampsByROIFSILo = cat(1, peakAmpsLo.fsi);

meanROICHI = cellfun(@nanmean, ampsByROICHI);
meanROIMSN = cellfun(@nanmean, ampsByROIMSN);
meanROIFSI = cellfun(@nanmean, ampsByROIFSI);

meanROICHILo = cellfun(@nanmean, ampsByROICHILo);
meanROIFSILo = cellfun(@nanmean, ampsByROIFSILo);
meanROIMSNLo = cellfun(@nanmean, ampsByROIMSNLo);

meanROICHIHi = cellfun(@nanmean, ampsByROICHIHi);
meanROIFSIHi = cellfun(@nanmean, ampsByROIFSIHi);
meanROIMSNHi = cellfun(@nanmean, ampsByROIMSNHi);


%next, compute for low and high velocity segments


paData.msn.all = meanROIMSN;
paData.fsi.all = meanROIFSI;
paData.chi.all = meanROICHI;

paData.msn.hi = meanROIMSNHi;
paData.fsi.hi = meanROIFSIHi;
paData.chi.hi = meanROICHIHi;

paData.msn.lo = meanROIMSNLo;
paData.chi.lo = meanROICHILo;
paData.fsi.lo = meanROIFSILo;

% construct bar graph stuff
X = [{meanROIMSN}, {meanROICHI}, {meanROIFSI};...
    {(meanROIMSNLo)} {(meanROICHILo)} {(meanROIFSILo)};...
    {(meanROIMSNHi)} {(meanROICHIHi)} {(meanROIFSIHi)}];

[ax,l] = box_err(X);
ylabel('\DeltaF/F')
set(ax, 'XTickLabel',{'All','Lo', 'Hi'});
legend(l,'MSN','CHI','FSI');
title(['Peak Amplitudes']);


end


