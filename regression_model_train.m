    function [b,c, X_all, y_all] = regression_model_train(mouseno, interneuron_type, fields)
    %first, fit model to data
    suffix = mouseSuffix(mouseno);
    num_folds = 10;
    b = nan(length(suffix),numel(fields),num_folds);
    c = nan(length(suffix),num_folds);
    X_all = cell(numel(suffix),1);
    y_all = cell(numel(suffix),1);
    for m=1:numel(suffix)
        % load all traces
        mousedata = loadMouse({suffix{m}});
        fluorAll = allFluor(mousedata);
        % create response vector
        fluor = sum(fluorAll.msn,2); % use fsis and chis too?
        if isempty(fluorAll.(interneuron_type))
            continue
        end
        % get summed interneuron fluorescence
        fluor_int = sum(fluorAll.(interneuron_type),2);
        X = [];
        
        % create predictor matrix
        for f=1:numel(fields)
            if strcmp(fields{f},'int')
                currcoeffs = fluor_int;
            elseif strcmp(fields{f},'msn')
                tr = fluorAll.msn(:,randperm(size(fluorAll.msn,2),size(fluorAll.(interneuron_type),2)));
                fluor = fluor-sum(tr,2);
                currcoeffs = sum(tr,2);
            elseif strcmp(fields{f},'rot')
                currcoeffs = abs(mousedata.rot);
            elseif strcmp(fields{f},'speed')
                currcoeffs = mousedata.speed;
            elseif strcmp(fields{f},'intercept')
                currcoeffs = ones(size(fluor));
            end
            X = cat(2,X,currcoeffs);
        end
        
        
        y = fluor;
        taxis = mousedata.taxis;
        taxis = taxis-taxis(1);
        
        X = bin(X,.1,taxis);
        y = bin(y,.1,taxis);
        
        [c(m,:),b(m,:,:)] = kfoldvalidate(X,y,num_folds);
        X_all{m} = X;
        y_all{m} = y;
    end
end