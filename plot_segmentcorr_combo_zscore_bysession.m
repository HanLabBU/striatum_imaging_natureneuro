function st = plot_segmentcorr_combo_zscore_bysession(peakmvmt,peakmvmtshuffles)
suffix = mouseSuffix('good');
inner = struct('in',nan(length(suffix),1),'out',nan(length(suffix),1));
X = struct('hi',inner,'lo',inner);
X2 = struct('hi',nan(length(suffix),1),'lo',nan(length(suffix),1));
for m=1:numel(suffix)
    mousedata = loadMouse(suffix(m));
    if mousedata.isCHI
        in = peakmvmt.chi(m).msnin;
        out = peakmvmt.chi(m).msnout;
    else
        in = peakmvmt.fsi(m).msnin;
        out = peakmvmt.fsi(m).msnout;
    end
    assert(~isempty(in) && ~isempty(out));
    
    X.hi.in(m) = mean(in(:,1));
    X.lo.in(m) = mean(in(:,2));
    X.hi.out(m) = mean(out(:,1));
    X.lo.out(m) = mean(out(:,2));
    X2.hi(m) = mean(cat(1,in(:,1),out(:,1)));
    X2.lo(m) = mean(cat(1,in(:,2),out(:,2)));
end

indiff.vals = (X.hi.in)-(X.lo.in);
outdiff.vals = (X.hi.out)-(X.lo.out);

Xhiall = X2.hi;
Xloall = X2.lo;

indiff.control = (peakmvmtshuffles.x_hi_in-peakmvmtshuffles.x_lo_in);
outdiff.control = (peakmvmtshuffles.x_hi_out-peakmvmtshuffles.x_lo_out);

Xhicontrol = peakmvmtshuffles.x_hi;
Xlocontrol = peakmvmtshuffles.x_lo;


st.diffs = [nanmean(indiff.vals) nanmean(outdiff.vals) nanmean(indiff.control) nanmean(outdiff.control)];
figure
[ax,l] = box_err([{indiff.vals},{indiff.control}; {outdiff.vals},{outdiff.control}]);
set(ax,'XTickLabel',{'< 100 \mum','> 100 \mum'});
legend(l,{'Data','Shuffled'});
set(ax,'XTickLabelRotation',45);
ylabel('Difference of mean Pearson CC, Hi-Lo movement');
title('Difference in ROI Correlation');
savePDF(gcf,sprintf('figures/%s/hispd-lospd_corr_diff_box.pdf',date));

[st.diff.incontrol.p, st.diff.incontrol.st] = signtest_explicit(indiff.vals,indiff.control);
[st.diff.inout.p, st.diff.inout.st] = signtest_explicit(indiff.vals, outdiff.vals);
[st.diff.outcontrol.p, st.diff.outcontrol.st] = signtest_explicit(outdiff.vals, outdiff.control);
[st.diff.outincontrol.p, st.diff.outincontrol.st] = signtest_explicit(outdiff.control,indiff.control);

figure
[ax,l] = box_err([{Xhiall}, {Xhicontrol}; {Xloall}, {Xlocontrol}]);
set(ax,'XTickLabel',{'Hi speed','Lo speed'});
legend(l,{'Data','Shuffled'});
set(ax,'XTickLabelRotation',45);
ylabel('Mean Pearson CC, hi vs lo speed');
title('ROI Correlation, combined');
savePDF(gcf,sprintf('figures/%s/hispd-lospd_corr_combinedrois_box.pdf',date));

[st.hilo.hicontrol.p, st.hilo.hicontrol.st] = signtest_explicit(Xhiall,Xhicontrol);
[st.hilo.hivslo.p, st.hilo.hivslo.st] = signtest_explicit(Xhiall, Xloall);
[st.hilo.locontrol.p, st.hilo.locontrol.st] = signtest_explicit(Xloall, Xlocontrol);
[st.hilo.control.p, st.hilo.control.st] = signtest_explicit(Xhicontrol, Xlocontrol);

end