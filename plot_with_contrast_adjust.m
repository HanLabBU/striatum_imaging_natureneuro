function [H, Max, Min] = plot_with_contrast_adjust(singleFrame, Min, Max)
    if nargin < 2
        sorted_mmm = sort(singleFrame(:),'ascend');
        Min = sorted_mmm(round(length(sorted_mmm)/2));
        Max = sorted_mmm(round(0.998*length(sorted_mmm)));
    end
    currFig = figure;
    while(true)
        answer = inputdlg({'Min','Max'}, 'Contrast',1,{num2str(Min),num2str(Max)});
        Min = str2double(answer{1});
        Max = str2double(answer{2});
        figure(currFig)
        H = imshow(singleFrame, [Min Max]); 
        button = questdlg('Is this okay?',...
                'Keep ROI','Yes','No','Yes');
        if strcmp(button,'Yes')
            break
        else
            continue
        end
    end
end
