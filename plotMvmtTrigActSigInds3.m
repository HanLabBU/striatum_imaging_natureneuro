function plotMvmtTrigActSigInds3(peakMovement, field, sigInds,tit_le)
    figure
    % find radius we used for peak extractions
    radius = (size(peakMovement.(field), 1)-1)/2;
    if radius ~= 50
        warning('Radius is not 50! is instead %d\n',radius)
    end
    % establish taxis
    taxis = [(-radius:radius)*.0469];
    
    % get positive and negative indices
    posinds = sigInds.pos.(field);
    neginds = sigInds.neg.(field);
    
    % create shaded error bar
    bar0 = shadedErrorBar(taxis, nanmean(peakMovement.(field)(:,neginds),2), serrMn(peakMovement.(field)(:,neginds),2)','r',0);
    mainLines = bar0.mainLine;
    lab = {'Neg'};
    hold on;
    %shaded error bar for positively modulated
    bar1 = shadedErrorBar(taxis, nanmean(peakMovement.(field)(:,posinds),2), serrMn(peakMovement.(field)(:,posinds),2)','b',0);
    lab = cat(1,lab,{'Pos'});
    mainLines = cat(1,mainLines,bar1.mainLine);
    %shaded error bar for non-modulated
    bar2 = shadedErrorBar(taxis, nanmean(peakMovement.(field)(:,~posinds & ~neginds),2), serrMn(peakMovement.(field)(:,~posinds & ~neginds),2)','k',0);
    lab = cat(1,lab,{'Non'});
    mainLines = cat(1,mainLines, bar2.mainLine);
    legend(mainLines, lab);
    xlabel(tit_le)
    ylabel('\DeltaF/F')
    title(field);
    xlim([taxis(1) taxis(end)]);
    % make sure that we have correct number of modulated inds
    assert(sum(neginds) + sum(posinds) + sum(~posinds & ~neginds) == length(posinds));
end