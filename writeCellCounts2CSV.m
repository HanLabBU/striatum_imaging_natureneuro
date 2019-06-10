function writeCellCounts2CSV(fi,cc)
suffix= mouseSuffix('good');
fprintf(fi,'Mouse name,is cholinergic, #MSNs, #PVs, #CHIs\n');
for m=1:numel(cc)
    fprintf(fi,'%s,%d,%d,%d,%d\n',suffix{m},cc(m).isCHI, cc(m).msn,cc(m).fsi, cc(m).chi);

end

fprintf(fi,'Totals:,%d,%d,%d,%d\n',sum([cc.isCHI]), sum([cc.msn]), sum([cc.fsi]), sum([cc.chi]));

end