function corrcoeff = consolidateACorrData(mouseno, type)
insidestruct = struct('r',[],'p',[],'d',[],'d2',[],'mu',[],'std',[]);
corrcoeff = struct('mm',insidestruct,'cc',insidestruct,'ff',insidestruct,...
    'mf',insidestruct,'mc',insidestruct);
suffix = mouseSuffix(mouseno);
scaling = 1.3; %microns per pixel
for m=1:numel(suffix)
    load([suffix{m} '_pairwiseasymmcorr' type '.mat']);
    corrdata = squeezeACorr(corrdata);
    corrcoeff.mm.r = cat(1,corrcoeff.mm.r,corrdata.msnmsn.rho);
    corrcoeff.mm.p = cat(1,corrcoeff.mm.p,1-sum(bsxfun(@lt, corrdata.msnmsn.zval,corrdata.msnmsn.rho),2)./size(corrdata.msnmsn.zval,2));
    corrcoeff.mm.d = cat(1,corrcoeff.mm.d,corrdata.msnmsn.d*scaling);
    corrcoeff.mm.d2 = cat(1,corrcoeff.mm.d2,cat(1,corrdata.msnmsn.d2{:})*scaling);
    corrcoeff.mm.mu = cat(1,corrcoeff.mm.mu, nanmean(corrdata.msnmsn.zval,2));
    corrcoeff.mm.std = cat(1,corrcoeff.mm.std, nanstd(corrdata.msnmsn.zval,[],2));
    if ~isempty(corrdata.msnchi)
        corrcoeff.mc.r = cat(1,corrcoeff.mc.r,corrdata.msnchi.rho);
        corrcoeff.mc.p = cat(1,corrcoeff.mc.p,1-sum(bsxfun(@lt, corrdata.msnchi.zval,corrdata.msnchi.rho),2)./size(corrdata.msnchi.zval,2));
        corrcoeff.mc.d = cat(1,corrcoeff.mc.d, corrdata.msnchi.d*scaling);
        corrcoeff.mc.d2 = cat(1,corrcoeff.mc.d2,cat(1,corrdata.msnchi.d2{:})*scaling);
        corrcoeff.mc.mu = cat(1,corrcoeff.mc.mu, nanmean(corrdata.msnchi.zval,2));
        corrcoeff.mc.std = cat(1,corrcoeff.mc.std, nanstd(corrdata.msnchi.zval,[],2));
    end
    
    if ~isempty(corrdata.chichi)
        corrcoeff.cc.r = cat(1, corrcoeff.cc.r,corrdata.chichi.rho);
        corrcoeff.cc.p = cat(1,corrcoeff.cc.p,1-sum(bsxfun(@lt, corrdata.chichi.zval,corrdata.chichi.rho),2)./size(corrdata.chichi.zval,2));
        corrcoeff.cc.d = cat(1,corrcoeff.cc.d,corrdata.chichi.d*scaling);
        corrcoeff.cc.d2 = cat(1,corrcoeff.cc.d2,cat(1,corrdata.chichi.d2{:})*scaling);
        corrcoeff.cc.mu = cat(1,corrcoeff.cc.mu, nanmean(corrdata.chichi.zval,2));
        corrcoeff.cc.std = cat(1,corrcoeff.cc.std, nanstd(corrdata.chichi.zval,[],2));
    end
    
    if ~isempty(corrdata.fsifsi)
        corrcoeff.ff.r = cat(1, corrcoeff.ff.r, corrdata.fsifsi.rho);
        corrcoeff.ff.p = cat(1, corrcoeff.ff.p,1-sum(bsxfun(@lt, corrdata.fsifsi.zval,corrdata.fsifsi.rho),2)./size(corrdata.fsifsi.zval,2));
        corrcoeff.ff.d = cat(1, corrcoeff.ff.d, corrdata.fsifsi.d*scaling);
        corrcoeff.ff.d2 = cat(1,corrcoeff.ff.d2,cat(1,corrdata.fsifsi.d2{:})*scaling);
        corrcoeff.ff.mu = cat(1,corrcoeff.ff.mu, nanmean(corrdata.fsifsi.zval,2));
        corrcoeff.ff.std = cat(1,corrcoeff.ff.std, nanstd(corrdata.fsifsi.zval,[],2));
    end
    
    if ~isempty(corrdata.msnfsi)
        corrcoeff.mf.r = cat(1, corrcoeff.mf.r, corrdata.msnfsi.rho);
        corrcoeff.mf.p = cat(1, corrcoeff.mf.p,1-sum(bsxfun(@lt, corrdata.msnfsi.zval,corrdata.msnfsi.rho),2)./size(corrdata.msnfsi.zval,2));
        corrcoeff.mf.d = cat(1, corrcoeff.mf.d, corrdata.msnfsi.d*scaling);
        corrcoeff.mf.d2 = cat(1,corrcoeff.mf.d2,cat(1,corrdata.msnfsi.d2{:})*scaling);
        corrcoeff.mf.mu = cat(1,corrcoeff.mf.mu, nanmean(corrdata.msnfsi.zval,2));
        corrcoeff.mf.std = cat(1,corrcoeff.mf.std, nanstd(corrdata.msnfsi.zval,[],2));
    end
    fprintf('done with mouse %s\n',suffix{m});
end
save(['acorrdata_consolidated' type '.mat'],'corrcoeff','-v7.3');
end