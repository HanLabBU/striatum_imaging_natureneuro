function appendTable(fi,T,labels) % from https://stackoverflow.com/questions/28043376/writetable-matlab-appendtable

% get labels for each thing
labels1 = labels.col(unique(T.Grp1));
labels2 = labels.col(unique(T.Grp2));

% make grouping variables cells
T.Grp1 = num2cell(T.Grp1);
T.Grp2 = num2cell(T.Grp2);


T.Grp1 = cellstr(nominal(renamecats(categorical([T.Grp1{:}]'),labels1)));
T.Grp2 = cellstr(nominal(renamecats(categorical([T.Grp2{:}]'),labels2)));
if length(T.Properties.VariableNames) > 3 && strcmp(T.Properties.VariableNames{4},'Direction');
T = [T(:,1) T(:,4) T(:,2) T(:,3)];
end
fmt = varfun(@(x) class(x),T,'OutputFormat','cell');
fmt(strcmp(fmt,'double'))={'%g'};
fmt(strcmp(fmt,'cell'))={'%s'};
fmt=[strjoin(fmt,'\t') '\n'];
for r=1:size(T,1)
  x=table2cell(T(r,:));
  fprintf(fi,fmt,x{:});
end
end