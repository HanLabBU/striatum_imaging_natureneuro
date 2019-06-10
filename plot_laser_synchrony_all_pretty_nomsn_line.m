function st = plot_laser_synchrony_all_pretty_nomsn_line(synchrony, msn,meansync,metadata,start_offset)
isCHI = ([metadata.isCHI]);
for m=1:numel(synchrony)
    msn(m).peakinds = msn(m).peakinds/meansync(m);
    synchrony(m).active = synchrony(m).active/meansync(m);
    synchrony(m).active = reshape(permute(synchrony(m).active,[2 1 3]),size(synchrony(m).active,2),[]);
end
msnmn = mean(mean(cat(1,msn.peakinds)));
synch.chi = cat(2,synchrony(~~isCHI).active)';
synch.fsi = cat(2,synchrony(~isCHI).active)';
clear synchrony

taxis = 0.0469*(0:1:(size(synch.chi,2)-1));
start_time = taxis(start_offset+1);
taxis = taxis-start_time;

figure
shadedErrorBar(taxis,nanmean(synch.chi)*100,serrMn(synch.chi)*100,'g',0);
hold on;
shadedErrorBar(taxis,nanmean(synch.fsi)*100,serrMn(synch.fsi)*100,'r',0);
hold on;
line([taxis(1) taxis(end)],[msnmn msnmn]*100,'Color','k','LineWidth',1);

st.chi.mn = mean(synch.chi);
st.chi.err = serrMn(synch.chi);
st.fsi.mn = mean(synch.fsi);
st.fsi.err = serrMn(synch.fsi);
xlabel('Time since event onset [s]');
ylabel('Pr(MSN active) (% over baseline)');
savePDF(gcf,sprintf('figures/%s/laser_triggered_synchrony_shadederrorbar_nomsn.pdf',date));

end