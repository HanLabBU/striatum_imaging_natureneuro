function st = plot_laser_synchrony_all62(synchrony, meansync,mts,metadata)
isCHI = ([metadata.isCHI]);
for m=1:numel(mts)
    mts(m).peakinds = mts(m).peakinds / meansync(m);
    synchrony(m).active = synchrony(m).active(:) / meansync(m);
end

mts = mean(cat(1,mts.peakinds),2);
assert(all(~isnan(mts(:))));
synch.chi = cat(1,synchrony(~~isCHI).active);
synch.fsi = cat(1,synchrony(~isCHI).active);

figure
bar_err(1:3,100*([mean(synch.chi) mean(synch.fsi) nanmean(mts)]-1),...
    [serrMn(synch.chi) serrMn(synch.fsi) serrMn(mts)]*100);
set(gca,'XTickLabels',{'Laser on CHI', 'Laser on FSI','MSN on'});
ylabel('Pr(MSN active) (% over baseline)');
savePDF(gcf,sprintf('figures/%s/laser_triggered_synchrony_combined.pdf',date));

st = ztestpw([nanmean(synch.chi) nanmean(synch.fsi) nanmean(mts)],...
    [serrMn(synch.chi) serrMn(synch.fsi) serrMn(mts)]);
st(:,3) = st(:,3)*3;
st = cat(2,st,[length(synch.chi), length(synch.fsi), length(mts)]');

end