function [totalXShift, totalYShift, currFig,R]= findPrePostShift(R,premap, postmap)
    
    plotOverlayContrastAdjust(R,premap);
    currFig1 = gcf;
    movegui('west')
    
    [currFig2,Min, Max] = plotOverlayContrastAdjust(R, postmap);
    title('Translation overlay');
    movegui('east')
    
    %TODO: allow zoom after adjusting contrast
    msgbox('Zoom to desired area for translation adjust');
    
    figure(currFig2)
    zoom out
    zoom
    pause
    figure(currFig2)
    xl = xlim;
    yl = ylim;
    totalXShift = 0;
    totalYShift = 0;
    while(true)
        figure(currFig2)
        answer = inputdlg({'X shift','Y shift'}, 'Enter coordinates to translate',1,{'0','0'});
        xshift = str2double(answer{1});
        yshift = str2double(answer{2});
        postmap = imtranslate(postmap,[xshift, yshift]);
        totalXShift = totalXShift+xshift;
        totalYShift = totalYShift+yshift;
        imshow(postmap, [Min Max]); xlim(xl); ylim(yl); title('Select ChIs for this video');
        hold on
        overlayROIs(gca,R);
        hold off
        button = questdlg('Is this okay?',...
                'Keep ROI','Yes','No','Yes');
        if strcmp(button,'Yes')
            break
        else
            continue
        end
    end
    currFig(1).fig = currFig1;
    currFig(2).fig = currFig2;
end