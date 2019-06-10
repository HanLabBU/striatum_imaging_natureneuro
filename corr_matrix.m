function [stat, n_clusters_all, cluster_sizes_all] = corr_matrix(mouseno,plt)
    scale = 1.3;
    cutoff_dist = (100/scale);
    suffix = mouseSuffix(mouseno);
    n_clusters_all = nan(size(suffix));
    cluster_sizes_all = cell(size(suffix));
    for m=1:numel(suffix)
        currMouse = loadMouse(suffix(m));        
        %curr msn traces
        act = allRising(currMouse);
        centroids = allCentroids(currMouse);
        act.msn = cat(2,act.msn,act.chi,act.fsi);
        centroids.msn = cat(1,centroids.msn,centroids.chi,centroids.fsi);
        %get correlation coefficient
        rho = assymCorr5(act.msn);

        %perform linkage clustering
        Z = linkage(centroids.msn,'complete');
        cl = cluster(Z,'cutoff',cutoff_dist,'criterion','distance');
        
        q = unique(cl);
        for i=1:numel(q)
            c = (cl == q(i));
            if sum(c) > 1
                assert(max(pdist(centroids.msn(c,:))) < cutoff_dist,'max is not less than cutoff distance');
            end
        end
        
        
        num_clusters = length(unique(cl));
        n_clusters_all(m) = num_clusters;
        cluster_sizes_all{m} = histc(cl,unique(cl));
        [sortind,i] = sort(cl);
        
        if nargin > 1 && plt
            %make figure sorted by cluster
            figure;
            imagesc(rho(i,i));
            title(sprintf('Coefficients %s',suffix{m}));
            %add boxes around clusters
            hold on;
            for n=1:num_clusters
               indlocs = find(sortind == n);
               strt = indlocs(1)-.5;
               fin = indlocs(end)+.5;
               line([strt fin], [strt strt],'Color','w','LineWidth',1);
               line([strt strt], [strt fin],'Color','w','LineWidth',1);
               line([fin fin], [strt fin],'Color','w','LineWidth',1);
               line([strt fin], [fin fin],'Color','w','LineWidth',1);
            end
            hold off; colorbar
            savePDF(gcf,sprintf('figures/%s/correlogram_sorted_%s.pdf',date,currMouse.suffix))
        end
       
       
       
        %get within-cluster coefficient values
        clust_vals = cell(num_clusters,1);
        all_in_clust_vals = [];
        all_out_clust_vals = [];
        for n=1:num_clusters
            mat = rho(cl == n,cl == n);
            mat = mat + diag(nan(size(mat,1),1));
            nomat = rho(cl > n, cl == n);
            nomat2 = rho(cl == n, cl > n);
            all_out_clust_vals = cat(1,all_out_clust_vals,nomat(:),nomat2(:));
            all_in_clust_vals = cat(1,all_in_clust_vals,mat(:));
            clust_vals{n} = mat;
        end
        stat(m).in = all_in_clust_vals;
        stat(m).out = all_out_clust_vals;
        
        
        if nargin > 1 && plt
            %bar plots
            figure
            bar_err(1:2,[nanmean(all_in_clust_vals) nanmean(all_out_clust_vals)],...
                [serrMn(all_in_clust_vals) serrMn(all_out_clust_vals)],...
                [serrMn(all_in_clust_vals) serrMn(all_out_clust_vals)]);
            ylabel('Mean correlation coefficient');
            title('')
            ax = gca;
            ax.XTickLabel = {'Within cluster','Out of cluster'};
            ax = gca;
            ax.XTickLabelRotation = 45;
            xlim([0, 3])
            ylim([0 max(nanmean(all_in_clust_vals))*1.1]);
            savePDF(gcf,sprintf('figures/%s/clustercorr_bargraph_%s.pdf',date,currMouse.suffix));
        end
        
        [stat(m).pv, stat(m).st] = ranksum_explicit(all_in_clust_vals, all_out_clust_vals);

    end
        
        
        
        

end