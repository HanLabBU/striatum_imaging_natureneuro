b_chi = cell(2000,1);
c_chi = cell(2000,1);
b_fsi = cell(2000,1);
c_fsi = cell(2000,1);

suffix = mouseSuffix('good');

parfor i=1:2000
    [b_chi{i}, c_chi{i}, X_all, y_all] = regression_model_train('good', 1, 'chi',{'intercept','msn'});

    for m=1:numel(suffix)
        if isempty(y_all{m})
            continue
        end
        figure
        plot(y_all{m},'r'); hold on;
        b = regress(y_all{m},X_all{m});
        plot(X_all{m}*b,'b');
        title(sprintf('Predicted fluorescence, %s',suffix{m}));
        savePDF(gcf,sprintf('figures/%s/examples/regressionexample_msn_%s_%d.pdf',date,suffix{m},i));
        close
    end



    [b_fsi{i}, c_fsi{i}, X_all, y_all] = regression_model_train('good', 1, 'fsi',{'intercept','msn'});
    fprintf('done with %d\n',i);
 
    for m=1:numel(suffix)
        if isempty(y_all{m})
            continue
        end
        figure
        plot(y_all{m},'r'); hold on;
        b = regress(y_all{m},X_all{m});
        plot(X_all{m}*b,'b');
        title(sprintf('Predicted fluorescence, %s',suffix{m}));
        savePDF(gcf,sprintf('figures/%s/examples/regressionexample_msn_%s_%d.pdf',date,suffix{m},i));
        close
    end
 end

save('processedData/regression_msn_sim_slow.mat','c_chi','b_chi','b_fsi','c_fsi','-v7.3');