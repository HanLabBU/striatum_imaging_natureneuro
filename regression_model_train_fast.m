function [c, X_all, y_all] = regression_model_train_fast(mouseno, nreps, interneuron_type)
    %first, fit model to data
    suffix = mouseSuffix(mouseno); % get mouse suffixes
    num_folds = 10;
    b = nan(length(suffix),2,num_folds); % initialize output b (coefficients for each fold)
    c = nan(length(suffix),num_folds,nreps); % initialize c output
    X_all = cell(numel(suffix),1); % initialize training data 
    y_all = cell(numel(suffix),1); % initialize predicted value
    for m=1:numel(suffix)
        mousedata = loadMouse({suffix{m}});
        fluorAll = allFluor(mousedata); % get all fluorescence traces
        fluor = sum(fluorAll.msn,2); % summed MSN activity
        if isempty(fluorAll.(interneuron_type))
            continue
        end

        taxis = mousedata.taxis;
        taxis = taxis-taxis(1);
       
        % bin stuff
        field.y = bin(fluor,.1, taxis);
        field.msn = bin(fluorAll.msn,.1,taxis);
        field.int = bin(fluorAll.(interneuron_type), .1, taxis);
        
        X_all{m} = nan(length(field.y),2,10);
        y_all{m} = nan(length(field.y),10);
        for r=1:nreps
            rng(10)
            inds = randperm(size(field.msn,2),size(field.int,2));
            currmsn = sum(field.msn(:,inds),2);
            y = field.y - currmsn;
            X = cat(2,currmsn,ones(size(currmsn)));
            [c(m,:,r)] = kfoldvalidate(X,y,num_folds);
            fprintf('%d\n',r);
            if r <= 10
                X_all{m}(:,:,r) = X;
                y_all{m}(:,r) = y;
            end
        end

    end
end