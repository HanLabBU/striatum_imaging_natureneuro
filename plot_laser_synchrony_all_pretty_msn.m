function st = plot_laser_synchrony_all_pretty_msn(meansync,mts)
for m=1:numel(mts)
    n(m) = size(mts(m).peakinds,1);
    p(m).peakinds = mean(mts(m).peakinds,1);
    se(m).peakinds = serrMn(p(m).peakinds.*(1-p(m).peakinds));
end


mn = sum(bsxfun(@times, cat(1,p.peakinds), n(:)./meansync(:)),1);

err_inside = bsxfun(@times,cat(1,se.peakinds),n(:)./meansync(:)).^2;

err = sqrt(sum(err_inside,1));

mn = mn/sum(n);
err = err/sum(n);

clear mts
radius = (length(mn)-1)/2;
taxis = 0.0469*(-radius:radius);

figure
shadedErrorBar(taxis,mn*100, err*100,'b',0);

st.msn.mn = mn;
st.msn.err = err;
xlabel('Time since event onset [s]');
ylabel('Pr(MSN active) (% over baseline)');
savePDF(gcf,sprintf('figures/%s/laser_triggered_synchrony_shadederrorbar_msn.pdf',date));

end