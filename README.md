ROI-Info
========

Extract pixel information from OsiriX ROIs

This plugin lists the pixel coordinates and intensities for Regions of Interest (ROIs)
in OsiriX images as CSV (comma separated variables) files that can then be read into a spreadsheet.

	▪	If All in Series is selected all ROIs in the series (3D or 4D) will be listed to the file.

	▪	If All in Image is selected the listing will be generated from the currently viewed image that
	  has the focus.

	▪	The behaviour of ROI Info depends upon the nature of the series. If it is a single volume 
	  consisting of 2D slices, all of the slices will be processed. If it is one image (2D or 3D)
	  in a 4D series, all of the slices in that image will be processed.

	▪	An attempt has been made to make ROI Info behave sanely if the image viewer is closed or 
	  if the focus changes. In the first case ROI Info will close. In the second, it follows the focus.

I hope this is useful either for its current functionality or as a framework to expand and do other things.

Tim Allman
https://github.com/TimAllman

