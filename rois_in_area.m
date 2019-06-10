function Rout = rois_in_area(R, xl, yl)
    Rout = [];
    for r=1:numel(R)
        curr_centroid = R(r).Centroid;
        if curr_centroid(1) > xl(1) && curr_centroid(1) < xl(2)
            if curr_centroid(2) > yl(1) && curr_centroid(2) < yl(2)
                Rout = cat(1,Rout, R(r));
            end
        end
    end

end