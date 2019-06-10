function st = plotROITriggeredEventFluor(peakmvmt, roitype, stats)
%first, plot bar graphs

post.(roitype) = cat(1,peakmvmt.(roitype).post);
post.msn = cat(1,peakmvmt.msn.post);

pre.(roitype) = cat(1,peakmvmt.(roitype).pre);
pre.msn = cat(1,peakmvmt.msn.pre);

figure
bar_err(1:2,[nanmean(pre.(roitype)),nanmean(pre.msn);  nanmean(post.(roitype)) nanmean(post.msn)],...
    [serrMn(pre.(roitype)), serrMn(pre.msn);  serrMn(post.(roitype)) serrMn(post.msn)]);
ylabel('\DeltaF/F')
set(gca,'XTickLabel',{'pre-event', 'post-event'});
ax = gca;
legend({upper(roitype),'MSN'}','Location','Northwest');
savePDF(gcf,sprintf('figures/%s/%s_triggered_fluorescence_bar.pdf',date,roitype));

% now plot shaded error bars
intevents = cat(2,peakmvmt.(roitype).nevents);
msnevents = cat(2,peakmvmt.msn.nevents);

inttrace = nansum(cat(2,peakmvmt.(roitype).msn),2)/nansum(cat(2,intevents.msn),2);
msntrace = nansum(cat(2,peakmvmt.msn.msn),2)/nansum(cat(2,msnevents.msn),2);

interr = sqrt(stats.(roitype).msn.m2/(stats.(roitype).msn.n-1))/sqrt(stats.(roitype).msn.n);
msnerr = sqrt(stats.msn.msn.m2/(stats.msn.msn.n-1))/sqrt(stats.msn.msn.n);
taxis = (-50:50)*.0469;

figure
shadedErrorBar(taxis,inttrace, interr,'b');
hold on;
shadedErrorBar(taxis,msntrace, msnerr,'r');
ax = gca;
xlabel('Time [s]');
ylabel('Mean \DeltaF/F');
legend([ax.Children(2), ax.Children(6)], {'MSN',upper(roitype)});
savePDF(gcf,sprintf('figures/%s/%s_triggered_fluorescence_line.pdf',date,roitype));

[st.rs.p.post, st.rs.w.post] = ranksum_explicit(post.(roitype),post.msn);
[st.rs.p.pre, st.rs.w.pre] = ranksum_explicit(pre.(roitype),pre.msn);
end