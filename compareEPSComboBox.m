% compare EPS between chis and msns
function epsData = compareEPSComboBox(mouseno)
meanEPS = meanActiveRegions(mouseno);
meanEPSSeg = meanActiveRegionsSegments(mouseno, 1, 5);

msnAll = cat(2,meanEPS.msn);
fsiAll = cat(2,meanEPS.fsi);
chiAll = cat(2,meanEPS.chi);

epsData.msn.all = msnAll;
epsData.fsi.all = fsiAll;
epsData.chi.all = chiAll;

msnseg = cat(2,meanEPSSeg.msn);
chiseg = cat(2,meanEPSSeg.chi);
fsiseg = cat(2,meanEPSSeg.fsi);

epsData.msn.lo = cat(2,msnseg.lo);
epsData.chi.lo = cat(2,chiseg.lo);
epsData.fsi.lo = cat(2,fsiseg.lo);

epsData.msn.hi = cat(2,msnseg.hi);
epsData.chi.hi = cat(2,chiseg.hi);
epsData.fsi.hi = cat(2,fsiseg.hi);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % barGraph
figure;

mnMat = [{msnAll}, {chiAll}, {fsiAll};...
    {epsData.msn.lo} {epsData.chi.lo} {epsData.fsi.lo};...
    {epsData.msn.hi} {epsData.chi.hi} {epsData.fsi.hi}];

[ax,l] = box_err(mnMat);
ylabel('Events per second');
title('Events per second'); 
set(ax,'XTickLabel',{'All', 'Lo', 'Hi'});
legend(l,{'MSN','CHI','FSI'});
end