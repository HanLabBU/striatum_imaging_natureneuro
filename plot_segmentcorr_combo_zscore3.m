function st = plot_segmentcorr_combo_zscore2(peakmvmt,peakmvmtshuffles)
inner = struct('in',[],'out',[]);
X = struct('hi',inner,'lo',inner);
suffix = mouseSuffix('good');
for m=1:numel(peakmvmt.fsi)
    mousedata = loadMouse(suffix(m));
    if mousedata.isCHI
        in = peakmvmt.chi(m).msnin;
        out = peakmvmt.chi(m).msnout;
        intin = peakmvmt.chi(m).intin;
        intout = peakmvmt.chi(m).intout;
    else
        in = peakmvmt.fsi(m).msnin;
        out = peakmvmt.fsi(m).msnout;
        intin = peakmvmt.fsi(m).intin;
        intout = peakmvmt.fsi(m).intout;
    end
    if ~isempty(in)
        X.hi.in = cat(1,X.hi.in, in(:,1));
        X.lo.in = cat(1,X.lo.in, in(:,2));
    end
    if ~isempty(out)
        X.hi.out = cat(1,X.hi.out, out(:,1));
        X.lo.out = cat(1,X.lo.out, out(:,2));
    end
    
    if ~isempty(intin)
        X.hi.in = cat(1,X.hi.in, intin(:,1));
        X.lo.in = cat(1,X.lo.in, intin(:,2));
    end
    if ~isempty(intout)
        X.lo.out = cat(1,X.lo.out, intout(:,2));
        X.hi.out = cat(1,X.hi.out, intout(:,1));
    end
end

indiff.vals = (X.hi.in)-(X.lo.in);
outdiff.vals = (X.hi.out)-(X.lo.out);

Xhiall = cat(1,X.hi.in,X.hi.out);
Xloall = cat(1,X.lo.in,X.lo.out);

indiff.control = (peakmvmtshuffles.x_hi_in-peakmvmtshuffles.x_lo_in);
outdiff.control = (peakmvmtshuffles.x_hi_out-peakmvmtshuffles.x_lo_out);

Xhicontrol = cat(1,peakmvmtshuffles.x_hi_in,peakmvmtshuffles.x_hi_out);
Xlocontrol = cat(1,peakmvmtshuffles.x_lo_in,peakmvmtshuffles.x_lo_out);


st.diffs = [nanmean(indiff.vals) nanmean(outdiff.vals) nanmean(indiff.control) nanmean(outdiff.control)];
figure
bar_err(1:2,[nanmean(indiff.vals) nanmean(indiff.control); nanmean(outdiff.vals) nanmean(outdiff.control)],...
    [serrMn(indiff.vals) serrMn(indiff.control);  serrMn(outdiff.vals) serrMn(outdiff.control)]);
set(gca,'XTickLabel',{'< 100 \mum','> 100 \mum'});
legend('Data','Shuffled');
set(gca,'XTickLabelRotation',45);
ylabel('Difference of mean Pearson CC, Hi-Lo movement, z-scored');
title('Difference in ROI Correlation');
savePDF(gcf,sprintf('figures/%s/hispd-lospd_corr_diff.pdf',date));

[st.diff.incontrol.p, st.diff.incontrol.st] = signtest_explicit(indiff.vals,indiff.control);
[st.diff.inout.p, st.diff.inout.st] = ranksum_explicit(indiff.vals, outdiff.vals);
[st.diff.outcontrol.p, st.diff.outcontrol.st] = signtest_explicit(outdiff.vals, outdiff.control);

% now, combine inside and outside
mns = [nanmean(Xhiall), mean(Xhicontrol); ...
    nanmean(Xloall) mean(Xlocontrol)];
smns = [serrMn(Xhiall), serrMn(Xhicontrol);  ...
    serrMn(Xloall), serrMn(Xlocontrol)];

figure
bar_err(1:2,mns,smns);
set(gca,'XTickLabel',{'Hi speed','Lo speed'});
legend('Data','Shuffled');
set(gca,'XTickLabelRotation',45);
ylabel('Mean Pearson CC, hi vs lo speed, z-scored');
title('ROI Correlation, combined');
savePDF(gcf,sprintf('figures/%s/hispd-lospd_corr_combinedrois.pdf',date));

% [stats.hi_vs_lo.p, stats.hi_vs_lo.st] = signtest_explicit(Xhiall, Xloall);

[st.hilo.hicontrol.p, st.hilo.hicontrol.st] = signtest_explicit(Xhiall,Xhicontrol);
[st.hilo.hivslo.p, st.hilo.hivslo.st] = signtest_explicit(Xhiall, Xloall);
[st.hilo.locontrol.p, st.hilo.locontrol.st] = signtest_explicit(Xloall, Xlocontrol);



end