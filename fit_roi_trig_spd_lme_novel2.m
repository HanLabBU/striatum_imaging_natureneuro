function [st,mdl] = fit_roi_trig_spd_lme_novel2(tbl)
% fit model to table
mdl = fitlme(tbl, 'Y_all~T_all*CellTypeAll+(1|CellIds)+(1|Animal_all)');

% acquire salient features
st.omnibus = anova(mdl);
st.model = mdl;
st.val = st.omnibus.FStat';
st.df1 = st.omnibus.DF1;
st.df2 = st.omnibus.DF2;
st.pval = st.omnibus.pValue;
figure
% plot diagnostics for this model fit
plot_lme_diagnostics(mdl,tbl,'Animal_all');
end