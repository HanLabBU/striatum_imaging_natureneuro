function corrcoeff = consolidateACorrData_small_cellids_laser_epochs(metadata, type)
insidestruct = struct('r',[],'p',[],'mouse',[]);
corrcoeff = struct('m',insidestruct);
abbrev = {'m'};
fullnm = {'msnlaser'};

for m=1:numel(metadata)
    load([metadata(m).suffix '_pairwiseasymmcorr' type '.mat']);
    corrdata = squeezeACorrCellIDLaser(corrdata);
    for f=1:numel(fullnm)
        short = abbrev{f};
        full = fullnm{f};

        corrcoeff.(short).r = cat(1,corrcoeff.(short).r,corrdata.(full).rho(:));

        corrcoeff.(short).p = cat(1,corrcoeff.(short).p,squeeze(1-sum(bsxfun(@lt, corrdata.(full).zval,corrdata.(full).rho),2)./size(corrdata.(full).zval,2)));
        corrcoeff.(short).mouse = cat(1,corrcoeff.(short).mouse, nominal(repmat(metadata(m).suffix,length(corrdata.(full).rho),1)));
        
        assert(length(corrcoeff.(short).r) == length(corrcoeff.(short).p));
        assert(length(corrcoeff.(short).mouse) == length(corrcoeff.(short).p));
    end
    
    fprintf('done with mouse %s\n',metadata(m).suffix);
end
save(['acorrdata_consolidated' type '_cellids.mat'],'corrcoeff','-v7.3');
end