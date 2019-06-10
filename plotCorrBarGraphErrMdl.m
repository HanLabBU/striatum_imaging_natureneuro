function [st,mdl] = plotCorrBarGraphErrMdl(corrcoeff) %takes as argument output of consolidateCorrData

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% barGraph
% bins = 10:10:1200;
% bins = 50:50:1200;
bins = [0 100 750 1500];
% fnames = fieldnames(corrcoeff);
fnames = {'mm','mf','mc'};
for i=1:length(fnames)
    currfield = fnames{i};
    
    siginds.(currfield) = (corrcoeff.(currfield).p < (.05));
        
    sm_inds = corrcoeff.(currfield).d < (bins(2));
    mid_inds = (corrcoeff.(currfield).d >= (bins(2)) & corrcoeff.(currfield).d < bins(3));
    far_inds = (corrcoeff.(currfield).d >= bins(3) & corrcoeff.(currfield).d < bins(4));
    big_inds = (corrcoeff.(currfield).d >= bins(4));
    
    assert(sum(sm_inds)+sum(mid_inds)+sum(far_inds)+sum(big_inds) == length(siginds.(currfield)));
    
    binid.(currfield)(sm_inds) = (1);
    binid.(currfield)(mid_inds) = (2);
    binid.(currfield)(far_inds) = (3);
    binid.(currfield)(big_inds) = (4);
    
    assert(sum((binid.(currfield) == 0)) == 0 && length(binid.(currfield)) == length(siginds.(currfield)));
    
    mouse.(currfield) = cellfun(@(x) regexp(x,'^([0-9]*)','match'),cellstr(corrcoeff.(currfield).mouse));
    session.(currfield) = corrcoeff.(currfield).mouse;
    
    siginds.(currfield)(mid_inds | big_inds) = [];
    mouse.(currfield)(mid_inds | big_inds) = [];
    binid.(currfield)(mid_inds | big_inds) = [];
    session.(currfield)(mid_inds | big_inds) = [];
    st.diffs.(currfield) = mean(siginds.(currfield)(binid.(currfield) == (1)))-...
        mean(siginds.(currfield)(binid.(currfield) == (3)));

end


% concatenate everything
is_sig = cat(1,siginds.mm, siginds.mc,siginds.mf);
mouse = categorical(cat(1,mouse.mm, mouse.mc,mouse.mf));
binids = nominal(cat(1,binid.mm',binid.mc',binid.mf'));
genotype = cat(1,repmat(nominal('msn-msn'),length(binid.mm),1),...
    repmat(nominal('msn-chi'),length(binid.mc),1),...
    repmat(nominal('msn-fsi'),length(binid.mf),1));
session = cat(1,session.mm, session.mc,session.mf);


tbl = table(is_sig, mouse, binids, genotype, session);

% keep session? No?
% mdl = fitglme(tbl,'is_sig~genotype*binids+(1|mouse)+(1|session)','distribution','binomial');
mdl = fitglm(tbl,'is_sig~genotype*binids','distribution','binomial','link','identity');
tbl.genotype = reorderlevels(tbl.genotype,{'msn-chi','msn-msn','msn-fsi'});
% mdl2 = fitglme(tbl,'is_sig~genotype*binids+(1|mouse)+(1|session)','distribution','binomial');
mdl2 = fitglm(tbl,'is_sig~genotype*binids','distribution','binomial','link','identity');

st.mdl = mdl;
st.mdl2 = mdl2;
st.tbl = tbl;
st.labels = {['binids_3:genotype_msn-msn-vs-' st.mdl.CoefficientNames{5}],...
    ['binids_3:genotype_msn-msn-vs-' st.mdl.CoefficientNames{6}], ['binids_3:genotype_msn-chi-vs-' st.mdl2.CoefficientNames{6}]};
st.tvals = cat(1,st.mdl.Coefficients.tStat(5:6), st.mdl2.Coefficients.tStat(6));
st.df = st.mdl.DFE(1);
st.pvals = cat(1,st.mdl.Coefficients.pValue(5:6),st.mdl2.Coefficients.pValue(6));
st.pvals_corrected = posthoc_benjaminihochberg_raw(st.pvals);
end