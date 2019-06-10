function [c_all] = compare_regression(mouseno, plt)
% train fsi examples
    [~, c.fsi,X.fsi,y.fsi] = regression_model_train(mouseno, 'fsi',{'intercept','int'});
    [~, c.speed,X.speed,y.speed] = regression_model_train(mouseno, 'fsi',{'intercept','speed'});
    [~, c.rot,X.rot,y.rot] = regression_model_train(mouseno, 'fsi',{'intercept','rot'});
    [~,c.msn,X.msn,y.msn] = regression_model_train(mouseno, 'fsi',{'intercept','msn'});
    c_all.fsi = c;
    
    if nargin > 2 && plt
        plot_example_regressions(X,y);
    end
    clear test_data, clear b, clear c
    
    
    
% test chi examples
    [~, c.chi,X.chi,y.chi] = regression_model_train(mouseno, 'chi',{'intercept','int'});
    [~, c.speed,X.speed,y.speed] = regression_model_train(mouseno, 'chi',{'intercept','speed'});
    [~, c.rot,X.rot,y.rot] = regression_model_train(mouseno, 'chi',{'intercept','rot'});
    [~,c.msn,X.msn,y.msn] = regression_model_train(mouseno, 'chi',{'intercept','msn'});
    c_all.chi = c;
    
    if nargin > 2 && plt
        plot_example_regressions(X,y);
    end
end

function plot_example_regressions(X, y)
fnames = fieldnames(X);
suffix = mouseSuffix('good');
for f=1:numel(fnames)
    for m=1:numel(suffix)
        if isempty(y.(fnames{f}){m})
            continue
        end
        figure
        plot(y.(fnames{f}){m},'r'); hold on;
        b = regress(y.(fnames{f}){m},X.(fnames{f}){m});
        plot(X.(fnames{f}){m}*b,'b');
        title(sprintf('Predicted fluorescence, %s, %s',suffix{m},fnames{f}));
        savePDF(gcf,sprintf('figures/%s/examples/regressionexample_%s_%s.pdf',date,suffix{m},fnames{f}));
    end
    close all
end

end