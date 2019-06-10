function write_linear_model(fi,mdl)
% from https://www.mathworks.com/matlabcentral/answers/112514-how-to-export-summary-results-of-the-linearmodel-as-text-to-an-excel-file
a = evalc('disp(mdl)');
a = strrep(a,'<strong>','');
a = strrep(a,'</strong>','');
fprintf(fi,'%s',a);
end