function rtData = compareRiseTimesComboBox(mouseno, pctileLo, pctileHi)

segLengths = riseTimesAll2(mouseno,pctileLo, pctileHi);



fnames = fieldnames(segLengths);
for f=1:numel(fnames)
    seglengthsroi.(fnames{f}) = cat(1,segLengths.(fnames{f}));
    segmeansroi.(fnames{f}) = cellfun(@nanmean,seglengthsroi.(fnames{f}));
end


rtData.msn.all = segmeansroi.msn;
rtData.msn.hi = segmeansroi.msnhi;
rtData.msn.lo = segmeansroi.msnlo;

rtData.fsi.all = segmeansroi.fsi;
rtData.fsi.hi = segmeansroi.fsihi;
rtData.fsi.lo = segmeansroi.fsilo;

rtData.chi.all = segmeansroi.chi;
rtData.chi.hi = segmeansroi.chihi;
rtData.chi.lo = segmeansroi.chilo;


X = [{(segmeansroi.msn)} {(segmeansroi.chi)} {(segmeansroi.fsi)};...
    {(segmeansroi.msnlo)} {(segmeansroi.chilo)} {(segmeansroi.fsilo)}; ...
    {(segmeansroi.msnhi)} {(segmeansroi.chihi)} {(segmeansroi.fsihi)}];

figure;
 [ax,l] = box_err(X);
    title('Rise Time');
    ylabel('Seconds')
    set(ax,'XTickLabel',{'All', 'Lo','Hi'});
    legend(l,{'MSN', 'CHI','FSI'});
end