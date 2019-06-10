function st = msn_clustering_by_tdt_modulation_laser_plot3(metadata, corrdata)

nsig = 0;
n_total = 0;
corrdata_sig = corrdata.m.p < 0.05;
% now go mouse by mouse
allinds = [];
currind = 1;
for m=1:numel(metadata)
    mousedata = loadMouseLaser(metadata(m));
    if mousedata.isCHI
        continue
    end
    currinds = (corrdata.m.mouse == nominal(metadata(m).suffix));
    centroids = allCentroidsLaser(mousedata);
    assert(size(centroids.msn,1) == sum(currinds));
    siginds = corrdata_sig(currinds);
    notsiginds = ~corrdata_sig(currinds);
    figure;
    centroids.msn = centroids.msn*1.3;
    centroids.fsi = centroids.fsi*1.3;
    plot(centroids.msn(siginds,1),centroids.msn(siginds,2),'.b','MarkerSize',10)
    hold on;
    plot(centroids.msn(notsiginds,1),centroids.msn(notsiginds,2),'.r','MarkerSize',10)
    plot(centroids.fsi(:,1),centroids.fsi(:,2),'.k','MarkerSize',10);
    xlabel('Distance [\mum]');
    ylabel('Distance [\mum]');
    title(sprintf('%s, %d msns',metadata(m).suffix,size(centroids.msn,1)));
    savePDF(gcf,sprintf('figures/%s/networkgraph_%s_sigmodulatedmsns.pdf',date,metadata(m).suffix));
    currind = currind + 1;
    nsig = nsig+sum(siginds);
    n_total = n_total+length(siginds);
    allinds = cat(1,allinds,siginds);
end

st.nsig = nsig;
st.n_total = n_total;
n = n_total;
p = nsig/n;
%% now run a z-test
% st.z_1 = (p-1)/sqrt(p*(1-p)/n);
% st.z_0 = (p-0)/sqrt(p*(1-p)/n);
% st.p_1 = normcdf(st.z_1,0,1);
% st.p_0 = 1-normcdf(st.z_0,0,1);
%% now run a permutation test

st.pval = perm_test(allinds,10000);
st.n = n;
st.p = p;
end

function p = perm_test(inds, nreps)
is_zero = nan(nreps,1);
is_one = nan(nreps,1);
for i=1:nreps
   samp = randsample(inds,length(inds),1);
   is_zero(i) = (sum(samp) == 0);
   is_one(i) = (all(samp == 1));
end

p.zero = mean(is_zero);
p.ones = mean(is_one);
end