function [currFig, Min, Max] = plotOverlayLinesContrastAdjust(Lines, maxPre)
    currFig = figure; 
    sorted_mmm = sort(maxPre(:),'ascend');
    Min = sorted_mmm(round(length(sorted_mmm)/2));
    Max = sorted_mmm(round(0.998*length(sorted_mmm)));
    imshow(maxPre, [Min Max]);hold on
    overlayLines(gca, Lines);
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
        overlayLines(gca, Lines)
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