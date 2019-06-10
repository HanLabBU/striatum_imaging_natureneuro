function [chi, fsi] = get_trig_spd_all_mouse(mouseno)
suffix = mouseSuffix(mouseno);
mice = cellfun(@(x) regexp(x,'^([0-9]*)','match'),suffix);
radius = 50;

chi.chi = [];
chi.msnchi = [];
chi.labelchi = cell(0);
chi.labelmsn = cell(0);

fsi.msnfsi = [];
fsi.fsi = [];
fsi.labelfsi = cell(0);
fsi.labelmsn = cell(0);


for m=1:numel(suffix)
    currmouse = loadMouse(suffix(m));
    msnfluor = roiTriggeredROI({suffix{m}},radius,0,0,'msn');
    msnfluor.speed = squeeze(msnfluor.speed);
    nsamples.msn = size(msnfluor.speed,2);
    
    if currmouse.isCHI
        chifluor = roiTriggeredROI({suffix{m}},radius,0,0,'chi');
        chifluor.speed = squeeze(chifluor.speed);
        nsamples.chi = size(chifluor.speed,2);
        
        chi.chi = cat(2,chi.chi,chifluor.speed);
        chi.labelchi = cat(1,chi.labelchi,repmat(mice(m),nsamples.chi,1));
        
        chi.msnchi = cat(2,chi.msnchi, msnfluor.speed);
        chi.labelmsn = cat(1,chi.labelmsn,repmat(mice(m),nsamples.msn,1));
    else
        fsifluor = roiTriggeredROI({suffix{m}},radius,0,0,'fsi');
        fsifluor.speed = squeeze(fsifluor.speed);
        nsamples.fsi = size(fsifluor.speed,2);
        
        fsi.fsi = cat(2, fsi.fsi, fsifluor.speed);
        fsi.labelfsi = cat(1,fsi.labelfsi,repmat(mice(m),nsamples.fsi,1));
        
        fsi.msnfsi = cat(2,fsi.msnfsi, msnfluor.speed);
        fsi.labelmsn = cat(1,fsi.labelmsn, repmat(mice(m),nsamples.msn,1));
    end
end



end