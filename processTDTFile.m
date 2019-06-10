function [data, info] = processTDTFile(fname)
	
   % LOAD FILE
	[data, info] = loadTif(fname);
	
    % ------------------------------------------------------------------------------------------
	% FILTER & NORMALIZE VIDEO, AND SAVE AS UINT8
	% ------------------------------------------------------------------------------------------
	
	% PRE-FILTER TO CORRECT FOR UNEVEN ILLUMINATION (HOMOMORPHIC FILTER)
	[data] = homomorphicFilter(data);
	
	% CORRECT FOR MOTION (IMAGE STABILIZATION)
	[data] = correctMotion(data);
	
	% FILTER AGAIN -> this was removed in Hua-an's final version. Some
	% better, some worse by looking at the trace
	data = spatialFilter(data);

end