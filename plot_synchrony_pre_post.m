function plot_synchrony_pre_post(metadata, activity,mn)
for m=1:numel(metadata)
    activity(m).post = activity(m).post(:)/mn(m);
    activity(m).pre = activity(m).pre(:)/mn(m);
end

activity_chi.pre = cat(1,activity(~~[metadata.isCHI]).pre);
activity_chi.post = cat(1,activity(~~[metadata.isCHI]).post);

activity_fsi.pre = cat(1,activity(~[metadata.isCHI]).pre);
activity_fsi.post = cat(1,activity(~[metadata.isCHI]).post);


bar_err(1:2,[mean([activity_chi.pre]) mean(activity_fsi.pre);...
    mean(activity_chi.post) mean(activity_fsi.post)], ...
    [serrMn(activity_chi.pre) serrMn(activity_fsi.pre); ...
    serrMn(activity_chi.post) serrMn(activity_fsi.post)]);

set(gca,'XTickLabel',{'Pre-Laser','Post-Laser'});
ylabel('Synchrony relative to session averages');
legend('CHI','PV','location','nw');
savePDF(gcf,sprintf('figures/%s/synchrony_laser_pre_vs_post.pdf',date));

end