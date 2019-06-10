% current pipeline: run findIntersections, then run combineCorrespondingRoi
classdef RoiPairs < hgsetget
    properties 
        roiPre
        roiPost
        pairID
        isChI = false;
        isPVI = false;
    end
    
    methods
        % CONSTRUCTOR
        function obj = RoiPairs(roiPre, roiPost)
            if nargin > 0
                if (numel(roiPre) == 1) && (numel(roiPost) == 1)
                    obj.roiPre = roiPre;
                    obj.roiPost = roiPost;
                else
                    for roiNo=1:numel(roiPre)
                        obj(roiNo).roiPre = roiPre(roiNo);
                        obj(roiNo).roiPost = roiPost(roiNo);
                    end
                    obj = resetIDs(obj);
                end
            end
        end
        
        function obj = resetIDs(obj)
            for kid = 1:numel(obj)
                obj(kid).pairID = kid;
            end
        end
        
        function obj = updatePostRois(obj, roiPost)
            try
                for roiNo = 1:numel(obj)
                    obj(roiNo).roiPost = roiPost(roiNo);
                end
            catch err
                fprintf('Could not assign rois!\n');
            end
        end
        
         function obj = updatePreRois(obj, roiPre)
            try
                for roiNo = 1:numel(obj)
                    obj(roiNo).roiPost = roiPre(roiNo);
                end
            catch err
                fprintf('Could not assign rois!\n');
            end
         end
         function obj = updateChIs(obj, isChI)
             try
                for roiNo = 1:numel(obj)
                    obj(roiNo).isChI = isChI(roiNo);
                end
            catch err
                fprintf('Could not assign ChIs!\n');
            end
         end
         function obj = updatePVIs(obj, isPVI)
             try
                for roiNo = 1:numel(obj)
                    obj(roiNo).isPVI = isPVI(roiNo);
                end
            catch err
                fprintf('Could not assign ChIs!\n');
            end
         end
         function plotRoiPair(obj, kid, background)
            preRoi = obj(kid).roiPre;
            postRoi = obj(kid).roiPost;
            showAsOverlayOutline(cat(2,preRoi, postRoi), background);
         end
         function obj = removeDoubleClicks(obj)
            roiPre = [obj.roiPre];
            [~, indices] = removeDoubleClicks(roiPre);
            obj(indices) = [];
         end
    end
    
    methods(Access = private)
       
    end
end