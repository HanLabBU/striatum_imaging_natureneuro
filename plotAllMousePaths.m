function plotAllMousePaths
suffix = mouseSuffix('good');
for m=1:numel(suffix)
    currMouse = loadMouse(suffix(m));
    figure
    plotMousePath(currMouse.speed, currMouse.phi, currMouse.rot,currMouse.taxis);
    savePDF(gcf,sprintf('figures/%s/mouse_path_in_maze_%s.pdf',date,currMouse.suffix));
end
end