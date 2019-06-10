function [roi] = get_trig_spd_all_mouse_siginds2(mouseno,celltype,mousetype,modtype)
suffix = mouseSuffix(mouseno); % get labels for each session
mice = cellfun(@(x) regexp(x,'^([0-9]*)','match'),suffix); % extract animal number
radius = 50; % set radius

roi.vals = [];
roi.labels = cell(0);


for m=1:numel(suffix)
    % load mouse
    currsession = loadMouse(suffix(m));
    
    if (currsession.isCHI && strcmp(mousetype,'fsi')) ||...
            (~currsession.isCHI && strcmp(mousetype,'chi'))
        continue
    end
        
    
    % get roi triggered speed
    roifluor = roiTriggeredROISigInds({suffix{m}},radius,0,0,celltype,modtype);
    % set current values
    roifluor.speed = squeeze(roifluor.speed);
    % get number of events so we can create mouse labels
    nsamples = size(roifluor.speed,2);

    % concatenate msns
    roi.vals = cat(2,roi.vals, roifluor.speed);
    roi.labels = cat(1,roi.labels,repmat(mice(m),nsamples,1));

end



end