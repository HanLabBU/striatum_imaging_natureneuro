function pwData = comparePeakWidthsComboBox(mouseno, pctileLo, pctileHi)

pw = peakWidthsAll(mouseno, pctileLo, pctileHi);

pwByROIMSN = cat(1, pw.msn);
pwByROICHI = cat(1, pw.chi);
pwByROIFSI = cat(1, pw.fsi);

pwROIHiMSN = cat(1,pw.msnhi);
pwROIHiCHI = cat(1,pw.chihi);
pwROIHiFSI = cat(1,pw.fsihi);

pwROILoMSN = cat(1,pw.msnlo);
pwROILoCHI = cat(1,pw.chilo);
pwROILoFSI = cat(1,pw.fsilo);

meanROICHI = cellfun(@nanmean, pwByROICHI);
meanROIMSN = cellfun(@nanmean, pwByROIMSN);
meanROIFSI = cellfun(@nanmean, pwByROIFSI);

meanROIMSNHi = cellfun(@nanmean, pwROIHiMSN);
meanROICHIHi = cellfun(@nanmean, pwROIHiCHI);
meanROIFSIHi = cellfun(@nanmean, pwROIHiFSI);

meanROIMSNLo = cellfun(@nanmean, pwROILoMSN);
meanROICHILo = cellfun(@nanmean, pwROILoCHI);
meanROIFSILo = cellfun(@nanmean, pwROILoFSI);

pwData.msn.all = meanROIMSN;
pwData.msn.lo = meanROIMSNLo;
pwData.msn.hi = meanROIMSNHi;

pwData.fsi.all = meanROIFSI;
pwData.fsi.lo = meanROIFSILo;
pwData.fsi.hi = meanROIFSIHi;

pwData.chi.all = meanROICHI;
pwData.chi.lo = meanROICHILo;
pwData.chi.hi = meanROICHIHi;



% construct bar graph stuff
mnMat = [{meanROIMSN}, {meanROICHI}, {meanROIFSI};...
    {(meanROIMSNLo)}, {(meanROICHILo)}, {(meanROIFSILo)};...
    {(meanROIMSNHi)}, {(meanROICHIHi)}, {(meanROIFSIHi)}];
[ax,l] = box_err(mnMat);
title('Mean +/- SEM peak width');
ylabel('Seconds')
set(ax,'XTickLabel',{'All', 'Lo', 'Hi'});
legend(l,{'MSN','CHI','FSI'});
end