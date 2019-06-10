function [R, currFig, preFig] = selectTDTsFromROI(R,maxTDT, maxPre,shift,isCHI)

    
    allTDT = cast(maxTDT(:),'double'); % find distribution of pixels in TDT image
    
    maxTDT = imtranslate(maxTDT, [shift(1), shift(2)]); % translate the image the appropriate amounts
    preFig = plotOverlayContrastAdjust(R, maxPre); % overlay ROIs on map
    title('Pre-infusion overlay');
    movegui('west')
   
    figure; hist(allTDT,1000); title('Pixel values for TDT map'); %histogram of pixel values
    ylabel('count');
    xlabel('pixel value');
    movegui('east');

    fprintf('Max val should be %d\n',max(allTDT))
    [currFig, Min, Max] = plotOverlayContrastAdjust(R, maxTDT); % overlay ROIs on TDT map
    title('Select TDT pos.');
    movegui('west')
    
    pctileLo = length(find(allTDT <= Min))/length(allTDT)*100; % get percentiles of histograms
    pctileHi = length(find(allTDT <= Max))/length(allTDT)*100;
    fprintf('Plotted %.2d pctile to %.2d pctile\n',pctileLo, pctileHi);
    
    %initialize new field for everything
    for roi=1:length(R)
       R(roi).isCHI = 0;
       R(roi).isFSI = 0;
    end
    

    while(true)
        figure(currFig) % set current figure
        hold on
        msgbox('Move or zoom to desired area to select TDT+''s and press enter');
        zoom
        pause
        figure(currFig)
        [xList,yList] = getpts; % click on points
        for i=1:length(xList) % for each set of points clicked
            % from MATLAB forums
            cx=xList(i);cy=yList(i); % get x and y points
            centroid = sub2ind([1024 1024],round(cy),round(cx)); % get linear index of point clicked
            for roi=1:length(R)
                if ~isempty(intersect(R(roi).PixelIdxList,centroid)) % if point clicked overlaps, set this ROIs value to 1 for genotype
                    R(roi).isCHI = isCHI;
                    R(roi).isFSI = ~isCHI;
                    plot(R(roi).BoundaryTrace.x, R(roi).BoundaryTrace.y,'g');
                end
            end
            
        end
        button = questdlg('Would you like to add more rois?','More rois?','Yes','No','Yes');
        if ~strcmp(button,'Yes')
            break
        end
    end    
end
