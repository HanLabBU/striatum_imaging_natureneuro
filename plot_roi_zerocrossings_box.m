function st = plot_roi_zerocrossings(rot,genotype)
% trial-based
active = cat(1,rot.active);
inactive = cat(1,rot.inactive);
dt = 0.0469;
figure
[~,y,grp] = make_dummy_mat(active(:)/dt, inactive(:)/dt);
boxplot(y,grp);
set(gca,'XTickLabels',{'ROI on','ROI off'})
ylabel('Zero crossings per second');
savePDF(gcf,sprintf('figures/%s/zerocrossings_%s_box.pdf',date,genotype));

% now compute statistic comparing them
figure
[st.p,st.st] = ranksum_explicit(active(:)/dt,inactive(:)/dt);
[st2.p,st2.st] = ranksum_explicit(active(:),inactive(:));
assert(isequaln(st,st2));
close
end