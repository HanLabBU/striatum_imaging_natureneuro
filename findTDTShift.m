function R = findTDTShift(suffix)

    load(['max_frames_' suffix '.mat'])
    load(['rois_preinfusion_' suffix '.mat']);


    if exist('maxOnlyPre','var')
        plotOverlayContrastAdjust(R, maxOnlyPre);
    else
        plotOverlayContrastAdjust(R, maxPre);
    end
    title('Pre-infusion overlay');
        movegui('west')
    try
        plotOverlayContrastAdjust(R, maxPost);
        title('Post-infusion overlay');
        movegui('east')
    catch
        fprintf('Skipping post-infusion\n')
    end
    [currFig, Min, Max] = plotOverlayContrastAdjust(R, maxTDT);
    title('Select ChI');
    movegui('west')
        %TODO: allow zoom after adjusting contrast
    mb = msgbox('Zoom to desired area for translation adjust');
    figure(currFig)
    zoom out
    zoom
    pause
    figure(currFig)
    xl = xlim;
    yl = ylim;
    totalXShift = 0;
    totalYShift = 0;
    while(true)
        figure(currFig)
        answer = inputdlg({'X shift','Y shift'}, 'Enter coordinates to translate',1,{'0','0'});
        xshift = str2double(answer{1});
        yshift = str2double(answer{2});
        maxTDT = imtranslate(maxTDT,[xshift, yshift]);
        totalXShift = totalXShift+xshift;
        totalYShift = totalYShift+yshift;
        H = imshow(maxTDT, [Min Max]); xlim(xl); ylim(yl); title('Select ChIs for this video');
        sz = size(maxTDT);
        hold on

        for rId = 1:length(R)
            if R(rId).isChI
                plot(R(rId).boundaryTrace.x, R(rId).boundaryTrace.y,'r');
            else
                plot(R(rId).boundaryTrace.x, R(rId).boundaryTrace.y,'g');
            end
        end
        hold off
        button = questdlg('Is this okay?',...
                'Keep ROI','Yes','No','Yes');
        if strcmp(button,'Yes')
            break
        else
            continue
        end
    end
save(['tdt_shift_' suffix '.mat'], 'totalXShift','totalYShift')
end

function [currFig, Min, Max] = plotOverlayContrastAdjust(R, maxPre)
    currFig = figure;
    Min = 0; Max = 255;
    imshow(maxPre, [Min Max]);hold on
    for rId = 1:length(R)
        if R(rId).isChI
            plot(R(rId).boundaryTrace.x, R(rId).boundaryTrace.y,'r');
        else
            plot(R(rId).boundaryTrace.x, R(rId).boundaryTrace.y,'g');
        end
%     disp(size(postInfusionRois(rId).boundaryTrace.y));
    end
    hold off
    %TODO: adjust brightness/contrast so can see vasculature on
    %post-infusion image
    while(true)
        answer = inputdlg({'Min','Max'}, 'Contrast',1,{num2str(Min),num2str(Max)});
        Min = str2double(answer{1});
        Max = str2double(answer{2});
        figure(currFig)
        imshow(maxPre, [Min Max]); 
        hold on
        for rId = 1:length(R)

            if R(rId).isChI
                plot(R(rId).boundaryTrace.x, R(rId).boundaryTrace.y,'r');
            else
                plot(R(rId).boundaryTrace.x, R(rId).boundaryTrace.y,'g');
            end
        end
        hold off
        button = questdlg('Is this okay?',...
                'Keep ROI','Yes','No','Yes');
        if strcmp(button,'Yes')
            break
        else
            continue
        end
    end
end