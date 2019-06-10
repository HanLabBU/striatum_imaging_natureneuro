% compareAUC
function aucData = compareAUCComboBox(mouseno, pctileLo, pctileHi)

auc = peakAUCAll(mouseno, pctileLo, pctileHi);


aucByROIMSN = cat(1, auc.msn);
aucByROICHI = cat(1, auc.chi);
aucByROIFSI = cat(1,auc.fsi);

aucByROIMSNHi = cat(1, auc.msnhi);
aucByROICHIHi = cat(1, auc.chihi);
aucByROIFSIHi = cat(1, auc.fsihi);

aucByROIMSNLo = cat(1, auc.msnlo);
aucByROICHILo = cat(1, auc.chilo);
aucByROIFSILo = cat(1, auc.fsilo);


dt = .0469;
meanROICHI = cellfun(@nanmean, aucByROICHI);
meanROIMSN = cellfun(@nanmean, aucByROIMSN);
meanROIFSI = cellfun(@nanmean, aucByROIFSI);

meanROIMSNLo = cellfun(@nanmean, aucByROIMSNLo);
meanROIFSILo = cellfun(@nanmean, aucByROIFSILo);
meanROICHILo = cellfun(@nanmean, aucByROICHILo);

meanROIMSNHi = cellfun(@nanmean, aucByROIMSNHi);
meanROIFSIHi = cellfun(@nanmean, aucByROIFSIHi);
meanROICHIHi = cellfun(@nanmean, aucByROICHIHi);

aucData.msn.all = meanROIMSN;
aucData.fsi.all = meanROIFSI;
aucData.chi.all = meanROICHI;

aucData.msn.hi = meanROIMSNHi;
aucData.fsi.hi = meanROIFSIHi;
aucData.chi.hi = meanROICHIHi;

aucData.msn.lo = meanROIMSNLo;
aucData.fsi.lo = meanROIFSILo;
aucData.chi.lo = meanROICHILo;

 
mnMat = [{meanROIMSN} {meanROICHI} {meanROIFSI};...
    {meanROIMSNLo} {meanROICHILo} {meanROIFSILo};...
    {meanROIMSNHi} {meanROICHIHi} {meanROIFSIHi}];


[ax,l] = box_err(mnMat);
   title('Area Under the Curve'); 
set(ax,'XTickLabel', {'All', 'Lo','Hi'});
legend(l,{'MSN','CHI','FSI'});
ylabel('Mean AUC (  \DeltaF/F * s )');
    