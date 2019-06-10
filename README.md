# striatum_imaging_natureneuro
This is the repository that goes along with Gritton et al. (2019), "Unique contributions of parvalbumin and cholinergic interneurons in organizing striatal networks during movement"

# Processing
Please use processFastManual in order to process videos as per our final processing routine. For tdTomato images, we used a simpler processing scheme "processTDT". We then tagged ROIs using one of the selectSingleFrameROIs*.m, and identified using the tdTomato images which of the ROIs corresponded to tdTomato-positive cells. To extract traces, use processROIs for the non-opto data or processROIsLaser for the opto data.

# Post-processing
At this point, we went through our extracted traces, identified which were dynamic and broad (described in the paper), and went forward with the analysis. loadAndFormatPreInfusion* (2 for non-opto data, 3 for opto data) were used to condense and interpolate the traces.

# Data analysis
For the final data analysis, refer to the script main_110718 for the generation of each figure.
