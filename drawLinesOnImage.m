 % Pass this function a max frame and an info struct. Allows you to
% manually select ROIs based on maximum values for each pixel in data.
function Lines = drawLinesOnImage(singleFrame)
     [H, Max, Min] = plot_with_contrast_adjust(singleFrame);
     hold on
     lineList = {};
     title('Select line points for this video');     
    while(true)
        msgbox('Zoom to desired area');
        zoom
        pause
        [xList,yList] = getpts;
        for inputs=2:length(xList)
            lineList{end+1} = line([xList(inputs-1) xList(inputs)],[yList(inputs-1) yList(inputs)]);
        end
        cont = questdlg('Would you like to add more rois?','More rois?','Yes','No','Yes');
        if ~strcmp(cont,'Yes')
            break
        end
        cont = questdlg('Would you like to change the contrast?','Contrast change?','Yes','No','No');
        if strcmp(cont,'Yes')
            while(true)
                answer = inputdlg({'Min','Max'}, 'Contrast',1,{num2str(Min),num2str(Max)});
                H.Parent.CLim = [str2double(answer{1}), str2double(answer{2})];
                cont = questdlg('Is this okay?','Is this okay?','Yes','No','No');
                if strcmp(cont,'Yes')
                    break
                end
            end
        end
    end
    hold off
    Lines = cat(1,lineList{:});
    
end