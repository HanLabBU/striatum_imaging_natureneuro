function stats = plotCoefByDistanceBox(corrcoeff, normalize)
    dist_bin = [0 100 1500];
    xlabs = {'<100','100-1500'};
    X = struct('mm',{},'mc',{},'mf',{},'ff',{},'cc',{}); % initialize bar plot matrices
    fields = fieldnames(corrcoeff);
    for q = 1:(length(dist_bin)-1)
        for f=1:length(fields)
            currfield = fields{f};
            d.(currfield) = (corrcoeff.(currfield).d >= dist_bin(q) & corrcoeff.(currfield).d < dist_bin(q+1));
            r.(currfield) = corrcoeff.(currfield).r;
            if normalize
                r.(currfield) = (r.(currfield)-corrcoeff.(currfield).mu)./corrcoeff.(currfield).std;
                r.(currfield)(isinf(r.(currfield))) = nan;
            end
            fprintf('n for %s: %d\n',currfield,sum(~isnan(r.(currfield)(d.(currfield)))));
            X(q).(currfield) = {r.(currfield)(d.(currfield))};
        end
    end

    for f=1:length(fields)
        field = fields{f};
        figure;
        curr = [X.(field)];
        [ax,l] = box_err(curr');
        xlabel('Distance [\mum]');
        ylabel('Asymmetric CC');
        title(field)
        ax.XTickLabel = xlabs;
        set(gca,'XTickLabelRotation',45) % from https://www.mathworks.com/matlabcentral/answers/231538-how-to-rotate-x-tick-label
        savePDF(gcf,sprintf('figures/%s/correlation_coefficient_distance_%s.pdf',date,field));
        if length(dist_bin) == 3
            [st.p,s] = ranksum_explicit(curr{1},curr{2});
            st.rs = s;
             stats.(field).rs = st;
             stats.(field).rs.medians = [nanmedian(curr{1}),nanmedian(curr{2})];
        else
            stats.(field) = kruskalwallispw(curr);
        end
    end
end
function stats = kruskalwallispw(X)
[~,y,lbl] = make_dummy_mat(X{:});
[p, tbl, st] = kruskalwallis(y,lbl,'off');
stats.kw.p = p;
stats.kw.chi2 = tbl{2,5};
stats.kw.df = tbl{2,3};

stats.pw.p = multcompare(st);
end