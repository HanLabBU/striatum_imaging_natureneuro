function stats = overallCorrBarErr(corrcoeff, dist)

if nargin < 2
    dist = inf;
end

% fnames = fieldnames(corrcoeff);
fnames = {'mm','cc','ff'};
for f=1:numel(fnames)
    curr_sig_dist = corrcoeff.(fnames{f}).d < dist; % find indices with desired distance
    sigdist.(fnames{f}).p = corrcoeff.(fnames{f}).p(curr_sig_dist); % get p values for these neuron pairs
    sigdist.(fnames{f}).r = corrcoeff.(fnames{f}).r(curr_sig_dist); % get coefficients for these neuron pairs
    curr_sig_p = sigdist.(fnames{f}).r(sigdist.(fnames{f}).p < (.05)); % get only significant p values
    n.(fnames{f}) = length(curr_sig_p); %get number significant
    ntot.(fnames{f}) = length(sigdist.(fnames{f}).p); % get number in this distance range
    props.(fnames{f}) = length(curr_sig_p)/length(sigdist.(fnames{f}).p); % get proportion here
end

figure
err = @(p,n) sqrt(p*(1-p)/n);

Xerr = [err(props.mm,ntot.mm) err(props.ff, ntot.ff) err(props.cc, ntot.cc)];

bar_err(1:3,[props.mm,props.ff,props.cc], Xerr);%,mf,mc]);
ylabel('Proportion of ROI pairs significant')
xlabel('Pair type')
ax = gca;
ax.XTickLabels= {'M-M','F-F','C-C'};

n_vec = [n.ff n.mm n.cc];
ntot_vec = [ntot.ff ntot.mm ntot.cc];

tbl = make_contingency_tbl(n_vec./ntot_vec,ntot_vec);
[stats.chi2, stats.p, stats.st, stats.yates] = chi2tbl(tbl,1);
stats.pw = chi2statspw(tbl,1,1,1);
stats.labels = {'FSI-FSI','MSN-MSN','CHI-CHI'};
stats.pw.p = stats.pw.p;
stats.n = n_vec;
stats.ntot = ntot_vec;
end