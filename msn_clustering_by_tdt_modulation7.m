function st = msn_clustering_by_tdt_modulation7(suffix, corrdata,nreps)

tdtmsns = msns_by_tdt_corr_mouse(corrdata,'chi');
% now go mouse by mouse
suffix = mouseSuffix(suffix);
currind = 1;
try
    parpool('local',20);
catch
end
for m=1:numel(suffix)
    mousedata = loadMouse(suffix(m));
    if ~mousedata.isCHI
        continue
    end
    [~,siginds] = triggeredActivityAll(@dyTriggeredFluorescence,suffix{m},50,0);

    % significant cholinergic inds
    % significant cholinergic inds
    sig_pos_chol_inds = siginds.pos.chi;
    sig_neg_chol_inds = siginds.neg.chi;
    
    if any(sig_pos_chol_inds) && any(sig_neg_chol_inds)

        %% find msns correlated with significantly positively modulated inds
        sig_pos_chol_inds_msn = unique(cat(1,tdtmsns(currind).sig{sig_pos_chol_inds}));
        sig_neg_chol_inds_msn = unique(cat(1,tdtmsns(currind).sig{sig_neg_chol_inds}));

        %% find msns that are correlated ONLY with CHIs that are positively modulated, or ONLY with CHIs athat are negatively modulated

       % find msns correlated with both positively and negatively
       % modulated CHIs
        both = intersect(sig_pos_chol_inds_msn,sig_neg_chol_inds_msn);

        % find significantly correlated indices not positive and not
        % negative modulated
        st(currind).true = length(both)/length(union(sig_pos_chol_inds_msn,sig_neg_chol_inds_msn)); % proportion of all indices that overlap
        st(currind).bs = bootstrap_orig_data(tdtmsns(currind).sig,sig_pos_chol_inds,sig_neg_chol_inds,nreps);
        st(currind).p = mean(st(currind).bs <= st(currind).true);
        full_data = union(sig_pos_chol_inds_msn,sig_neg_chol_inds_msn);
        
%         st(currind).p = mean(len_overlap <= st(currind).true);
        st(currind).suffix = suffix{m};
    end
    currind = currind + 1;

end
delete(gcp('nocreate'));
end

function st = bootstrap_orig_data(msns_by_chi,pos,neg,nreps)
n_chis = numel(msns_by_chi);
n_msns_per_chi = cellfun(@numel,msns_by_chi);
msn_inds = unique(cat(1,msns_by_chi{:}));

st = zeros(nreps,1);
parfor b=1:nreps
    sample = cell(n_chis,1);
    for c=1:n_chis
         sample{c} = randsample(msn_inds,n_msns_per_chi(c),0);
    end
    samples_pos = unique(cat(1,sample{~~pos}));
    samples_neg = unique(cat(1,sample{~~neg}));
    st(b) = length(intersect(samples_pos,samples_neg))/length(union(samples_pos,samples_neg));
    fprintf('Iter %d\n',b);
end


end

