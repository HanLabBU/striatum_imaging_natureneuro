function stats = plot_synch_trig_velocity_box(cout)
len = size(cout,1);
radius = (len-1)/2;
taxis = 0.0469*((-radius):radius);
figure
shadedErrorBar(taxis',nanmean(cout,2),serrMn(cout,2)');
xlabel('Time [s]');
ylabel('Speed [cm/s]');
title('Synchrony-triggered speed');
savePDF(gcf,sprintf('figures/%s/synch_triggered_speed.pdf',date));

% bin_width = 0.05*10;
% %now, bar graph
% bins = -bin_width/2:bin_width:max(taxis);
bin_width = 0.05*10;
bins = 0:bin_width:max(taxis);
X = {};
xlabs = {};
for i=1:length(bins)-1
    inds = find(taxis >= bins(i) & taxis < bins(i+1));
    curr = cout(inds,:);
    X = cat(2,X,nanmean(curr,1));
    xlabs{i} = sprintf('%i-%i ms',round(1000*bins(i)),round(1000*(bins(i+1))));
end

figure;
[ax,l] = box_err(cellfun(@(x) x/nanmean(X{1})-1,X,'uniformoutput',false)');
set(ax,'XTickLabel',xlabs);
set(ax,'XTickLabelRotation',45);
ylabel('Normalized speed');
savePDF(gcf,sprintf('figures/%s/synch_triggered_speed_bar.pdf',date));

%stats
Xf = cat(1,X{:});
[p,tbl,st] = friedman(Xf(:,~isnan(Xf(1,:)))');
stats.kw.p = p;
stats.kw.st.df = tbl{2,3};
stats.kw.st.chi2 = tbl{2,5};
stats.kw.st.meanranks = st.meanranks;
c = multcompare(st);
c = table(c(:,1),c(:,2),c(:,6),st.meanranks(c(:,1))',st.meanranks(c(:,2))',...
    'VariableNames',{'Grp1','Grp2','pval','MnRnk1','MnRnk2'});
stats.pw.p = c;
stats.pw.labels = xlabs;

end