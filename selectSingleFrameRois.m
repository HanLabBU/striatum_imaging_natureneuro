 % Pass this function a 3D uint8 data and an info struct. Allows you to
% manually select ROIs based on maximum values for each pixel in data.
function roi = selectSingleFrameRois(singleFrame, frameNum)
%     singleFrame = log(cast(singleFrame,'double'));
    sz = size(singleFrame);
    roiList = cell(0);
    Min = 0; Max = 100;
    currFig = figure;
    H = imshow(singleFrame, [Min Max]); title('Select rois for this video'); 
    while(true)
        answer = inputdlg({'Min','Max'}, 'Contrast',1,{num2str(Min),num2str(Max)});
        Min = str2double(answer{1});
        Max = str2double(answer{2});
        figure(currFig)
        H = imshow(singleFrame, [Min Max]); title('Select rois for this video'); 
        button = questdlg('Is this okay?',...
                'Keep ROI','Yes','No','Yes');
        if strcmp(button,'Yes')
            break
        else
            continue
        end
    end
    hold on
    
    
    while(true)
        mb = msgbox('Zoom to desired area');
        zoom
        pause
        [xList,yList] = getpts;
        for inputs=1:length(xList)
            % next few lines modified from MATLAB forums: https://www.mathworks.com/matlabcentral/newsreader/view_thread/146031
            cx=xList(inputs);cy=yList(inputs);ix=size(singleFrame,1);iy=size(singleFrame,2);r=6;
            [x,y]=meshgrid(-(cx-1):(ix-cx),-(cy-1):(iy-cy));
            c_mask=((x.^2+y.^2)<=r^2);
            b = bwboundaries(c_mask);
            circ = plot(b{1}(:,2),b{1}(:,1),'r');
            %%%%%%
%             button = questdlg('Would you like to keep this ROI?',...
%                 'Keep ROI','Yes','No','Yes');
%             
%             if strcmp(button,'Yes')
                delete(circ)
                plot(b{1}(:,2),b{1}(:,1),'g');
                roiMaskRP = regionprops(c_mask,...
                  'Centroid', 'BoundingBox','Area',...
                  'Eccentricity', 'PixelIdxList','Perimeter');
                currRoi = RegionOfInterest(roiMaskRP);
                set(currRoi,'FrameSize',sz,...   
                    'FrameIdx',frameNum);
                roiList{end+1} = currRoi;
%             else
%                 delete(circ)
%             end
            
        end
        button = questdlg('Would you  like to add more rois?','More rois?','Yes','No','Yes');
        if ~strcmp(button,'Yes')
            break
        end
    end
    roi = cat(1,roiList{:});
    
end
