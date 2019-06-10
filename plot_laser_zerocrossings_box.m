function st = plot_laser_zerocrossings_box(rot,genotype)
% trial-based
active = cat(1,rot.active);
inactive = cat(1,rot.inactive);
dt = 0.0469;

figure
[~,y,grp] = make_dummy_mat(active(:)/dt, inactive(:)/dt);
boxplot(y,grp);
set(gca,'XTickLabels',{'Laser on','Laser off'})
ylabel('Zero crossings per second');
savePDF(gcf,sprintf('figures/%s/zerocrossings_%s_box_ranksum.pdf',date,genotype));

% now compute statistic comparing them
figure
[st.p,st.st] = ranksum_explicit(active(:),inactive(:));
close
end