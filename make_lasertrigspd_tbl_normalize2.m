function [mdl, st, tbl] = make_lasertrigspd_tbl_normalize2(spd, mouse, trial,normalize,formula)
if nargin < 5
    normalize = 1;
end

width = size(spd,1);
radius = (width-1)/2;

dt = 0.0469;
tvals = (-radius:radius)*dt;
tval_bins = [-0.001 0 .5 1 1.5 2];
bin = discretize(tvals,tval_bins,'IncludedEdge','right');

nbins = numel(unique(bin(~isnan(bin))));
X = zeros(nbins,size(spd,2));
for i=1:nbins
    X(i,:) = nanmean(spd(bin == i,:),1);
end

X = X';
% make first column mean 0
if normalize
    X = X/abs(nanmean(X(:,1),1))-1;
end

[~,~,TimeBin] = make_dummy_mat(X(:,1),X(:,2),X(:,3),X(:,4),X(:,5));
TimeBin = nominal(TimeBin);
EventID = nominal(repmat((1:size(X,1))',size(X,2),1));
% make first time point reference

Mouse = nominal(mouse);
Mouse = repmat(Mouse,size(X,2),1);
% make first mouse reference
% now encode trial
Trial = nominal(trial);
Trial = repmat(Trial,size(X,2),1);

% make response matrix
Velocity = X;
Velocity = Velocity(:);


tbl = table(Velocity, TimeBin, Mouse, Trial,EventID);

mdl = fitlme(tbl,formula); % adding time bin or not doesn't make a big difference? i.e. (TimeBin|EventID)

st.t.true = mdl.Coefficients.tStat(2:end)';
st.t.p = mdl.Coefficients.pValue(2:end);
st.t.df = mdl.DFE;

st.anova = anova(mdl);
st.f.true = st.anova.FStat(end)';
st.f.p = st.anova.pValue(end);
st.f.df = [st.anova.DF1(end) st.anova.DF2(end)];
figure
plot_lme_diagnostics(mdl,tbl,'Mouse');
end