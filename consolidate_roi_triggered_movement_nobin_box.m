function [st] = consolidate_roi_triggered_movement_nobin_box(chi,fsi,maxtime)

radius = 50;

%now construct bar graph
taxis = (-radius:radius)*0.0469;
inds = find(taxis >= 0 & taxis <= maxtime);

chimvmt = chi.chi;
fsimvmt = fsi.fsi;
msnfsimvmt = fsi.msnfsi;
msnchimvmt = chi.msnchi;

% concatenate labels for msns, as we will concatenate rois
labels.msn = cat(1,chi.labelmsn, fsi.labelmsn);
labels.chi = chi.labelchi;
labels.fsi = fsi.labelfsi;

b.chi = chimvmt(inds,:);
b.msn = cat(2,msnchimvmt(inds,:),msnfsimvmt(inds,:));
b.fsi = fsimvmt(inds,:);

%% construct table
% for each cell time
fnames = fieldnames(b);
for f=1:numel(fnames)
    % for each cell, divide all values by the mean value in frame 1, and
    % subtract 1
    b.(fnames{f})=  b.(fnames{f})/abs(nanmean(b.(fnames{f})(1,:),2))-1;
    assert(size(b.(fnames{f}),1) == length(inds));
end

assert(all(taxis(inds) >= 0));
assert(all(inds > radius));
st.coeffs = regress_coefficients(b,taxis(inds));
    

[ax,l] = box_err([{st.coeffs.chi}, {st.coeffs.msn}, {st.coeffs.fsi}]');
ylabel('Slope (change over over baseline/second)');
set(ax,'XTickLabel',{'CHI','MSN','FSI'});
title(sprintf('From baseline through %d seconds\n',maxtime));
savePDF(gcf,sprintf('figures/%s/slope_baseline_thru_%dseconds.pdf',date,maxtime));

% construct mixed effects model
coeffs = cat(1,st.coeffs.chi, st.coeffs.msn,st.coeffs.fsi);
celltype = cat(1,repmat(nominal('chi'),length(labels.chi),1),...
    repmat(nominal('msn'),length(labels.msn),1),...
    repmat(nominal('fsi'),length(labels.fsi),1));
mouse = cat(1,labels.chi, labels.msn, labels.fsi);
clear st;
st.tbl = table(coeffs, mouse, celltype);
st.mdl = fitlme(st.tbl,'coeffs~celltype+(1|mouse)');
tbl2 = st.tbl;
tbl2.celltype = reorderlevels(tbl2.celltype,{'fsi','msn','chi'});
st.mdl2 = fitlme(tbl2,'coeffs~celltype+(1|mouse)');
end

function coeffs = regress_coefficients(b,taxis)
fnames = fieldnames(b);
coeffs = struct('msn',[],'chi',[],'fsi',[]);
for i=1:numel(fnames)
    intercept = ones(size(b.(fnames{i})(:,1)));
    for j=1:size(b.(fnames{i}),2)
        if ~any(isnan(b.(fnames{i})(:,j)))
           c = regress(b.(fnames{i})(:,j),[taxis(:) intercept(:)]);
           coeffs.(fnames{i}) = cat(1,coeffs.(fnames{i}),c(1)); 
        else
           coeffs.(fnames{i}) = cat(1,coeffs.(fnames{i}),nan); 
        end
    end
end

end
