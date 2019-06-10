function t = time_since_last_peak(x,len)
peaklocs = repmat(x,1,len);
peaklocs = cat(1,peaklocs,zeros(1,len));
t = 1:len;
t_minus = num2cell(bsxfun(@minus,-peaklocs,-t),1);
t_gtz = cellfun(@(x) x(x >= 0), t_minus,'UniformOutput',false);
t = cell2mat(cellfun(@min, t_gtz,'UniformOutput',false));
end