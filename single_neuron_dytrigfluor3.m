function [stats] = single_neuron_dytrigfluor3(mouseno,plt)

suffix = mouseSuffix(mouseno);
numMice = numel(suffix);

clusterinfo = struct('pos',[],'neg',[]);

cumdata.msn = struct('pos',[],'neg',[]);
cumdata.fsi = struct('pos',[],'neg',[]);
cumdata.chi = struct('pos',[],'neg',[]);
for m=1:numMice
    [peaksDY, sigIndsDY, tstatsDY] = dyTriggeredFluorescence(suffix{m},50,0); % get significant indices
    
    cumdata.msn = neurcat(cumdata.msn, sigIndsDY.msn); % concatenate them all
    cumdata.fsi = neurcat(cumdata.fsi, sigIndsDY.fsi);
    cumdata.chi = neurcat(cumdata.chi, sigIndsDY.chi);
    
    if nargin > 1 && plt
        plot_sigposorneg_single2(peaksDY, sigIndsDY, tstatsDY, suffix{m}); % plot examples
    end
   
    currMouse = loadMouse({suffix{m}});
    centroids = cat(1,currMouse.centroidsMSN, currMouse.centroidsBroadMSN); % get centroids
    
    
    clusterinfo.pos = cat(1, clusterinfo.pos, find_prop_close(sigIndsDY.msn.pos, centroids)); % get cluster data
    clusterinfo.neg = cat(1, clusterinfo.neg, find_prop_close(sigIndsDY.msn.neg, centroids));
    
    close all
    
end

stats = get_cluster_stats(clusterinfo);
stats.compare = get_binostats(cumdata);
stats.cdata = cumdata;
stats.n = get_counts(cumdata);

end

function tbl = get_counts(cumdata)
celltypes = fieldnames(cumdata);
tbl = cell2table(cell(0,3),'VariableNames',{'celltype','modulationtype','n'});
for f = 1:numel(celltypes)
    tbl = [tbl;{celltypes{f},'pos',sum(cumdata.(celltypes{f}).pos)}];
    tbl = [tbl;{celltypes{f},'neg',sum(cumdata.(celltypes{f}).neg)}];
    tbl = [tbl;{celltypes{f},'other',length(cumdata.(celltypes{f}).pos)-(sum(cumdata.(celltypes{f}).pos)+sum(cumdata.(celltypes{f}).neg))}];
end

end

function stats = get_cluster_stats(clusterinfo)

[stats.pos.rs.p, stats.pos.rs.st] = ranksum_explicit(cat(1,clusterinfo.pos.in),cat(1,clusterinfo.pos.out));
[stats.neg.rs.p, stats.neg.rs.st] = ranksum_explicit(cat(1,clusterinfo.neg.in),cat(1,clusterinfo.neg.out));

end


function stats = get_binostats(data)


%now compare within sample. 
stats.msn = pw_binotest([sum(data.msn.pos), sum(data.msn.neg) length(data.msn.pos)-(sum(data.msn.pos)+sum(data.msn.neg))], {'pos','neg','none'},1);
stats.chi = pw_binotest([sum(data.chi.pos), sum(data.chi.neg) length(data.chi.pos)-(sum(data.chi.pos)+sum(data.chi.neg))], {'pos','neg','none'},1);
stats.fsi = pw_binotest([sum(data.fsi.pos), sum(data.fsi.neg) length(data.fsi.pos)-(sum(data.fsi.pos)+sum(data.fsi.neg))], {'pos','neg','none'},1);


end