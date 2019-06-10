function [currFig, Min, Max] = plotOverlayContrastAdjust(R, maxPre)
    currFig = figure;
    Min = 0; Max = 255;
    imshow(maxPre, [Min Max]);hold on
    overlayROIs(gca, R);
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
        overlayROIs(gca, R)
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