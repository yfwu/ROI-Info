//
//  PanelController.m
//  ROI_Info
//
//  Created by Tim Allman on 2014-09-08.
//
//

#import <OsiriXAPI/ViewerController.h>
#import <OsiriXAPI/ROI.h>
#import <OsiriXAPI/DCMView.h>
#import <OsiriXAPI/DCMPix.h>

#import "PanelController.h"
#import "HelpPanelController.h"

@interface PanelController ()

@end

@implementation PanelController

- (id)initWithViewerController:(ViewerController *)vc
                     andFilter:(ROI_InfoFilter *)filter
{
    self = [super initWithWindowNibName:@"ControlPanel"];
    if (self)
    {
        viewerController = vc;
        pluginFilter = filter;

        // Some information about which slice in which image is being viewed.
        curImageIdx = (int)viewerController.imageIndex;
        curTimeIdx = (int)viewerController.curMovieIndex;
        numTimeImages = (int)viewerController.maxMovieIndex;

        [self showWindow:self];
    }
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"AwakeFromNib");

}

- (void)windowDidLoad
{
    NSLog(@"windowDidLoad");
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)extractButtonPressed:(id)sender
{
    // Grab this so that we always have the viewer with the focus.
    viewerController = [ViewerController frontMostDisplayed2DViewer];

    // Some information about which slice in which image is being viewed.
    curImageIdx = (int)viewerController.imageIndex;
    curTimeIdx = (int)viewerController.curMovieIndex;
    numTimeImages = (int)viewerController.maxMovieIndex;

    //    NSLog(@"RoiSelection index = %d", RoiSelection);
    //    NSLog(@"Current image index = %d", curImageIdx);
    //    NSLog(@"Current time index = %d", curTimeIdx);
    //    NSLog(@"Number of time indices = %d", numTimeImages);

    NSSavePanel* panel = [NSSavePanel savePanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"csv", nil]];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton)
        {
            [self doExtraction:[panel URL]];
        }
    }];

}

- (void)doExtraction:(NSURL*)url
{
    NSMutableString* roiInfo = [NSMutableString
                                stringWithString:@"Info,X coord,Y coord,Intensity,\n"];

    switch (RoiSelection)
    {
        case AllInImage:
            NSLog(@"AllInImage selected");

            // The ROIs for this image.
            NSArray* roiListList = [viewerController roiList:curTimeIdx];
            [roiInfo appendString:[self extractRoiInfoInImage:roiListList]];
            NSLog(@"%@", roiInfo);
            break;

        case AllInSeries:
            NSLog(@"AllInSeries selected");
            [roiInfo appendString:[self extractRoiInfoInSeries]];
            NSLog(@"%@", roiInfo);
            break;

        default:
            break;
    }

    NSError* error = [self saveData:roiInfo to:url];
    if (error != nil)
    {
        NSLog(@"%@", [error localizedDescription]);
        NSLog(@"%@", [error localizedFailureReason]);
        NSLog(@"%@", [error localizedRecoverySuggestion]);
    }
}

- (IBAction)helpButtonPressed:(id)sender
{
    NSLog(@"helpButtonPressed");
    if (helpPanelController == nil)
    {
        helpPanelController = [[HelpPanelController alloc] initWithWindowNibName:@"HelpPanel"];
    }

    [helpPanelController showWindow:self];
}

- (IBAction)closeButtonPressed:(id)sender
{
    NSLog(@"closeButtonPressed");

    [helpPanelController close];
    [self close];
}

// Return a string containing values and coordinates in one ROI
- (NSString*)extractRoiValuesAndCoordinates:(ROI*)roi
{
    // return value
    NSMutableString* retVal = [NSMutableString stringWithCapacity:100];
    NSString* name = [roi name];

    // These ROI types do not define regions
    if ((roi.type == tText) || (roi.type == tMesure) ||
        (roi.type == tArrow) || (roi.type == t2DPoint))
    {
        [retVal appendFormat:@"ROI named %@ does not define a region.", name];
        return retVal;
    }

    [retVal appendFormat:@"ROI %@,,\n", name];

    /*
     * getROIValue is declared in DCMPix.h.
     * 'data' is an array of float with 'size' elements allocated with malloc.
     * 'coords' is an array of float with 'size*2' elements allocated with
     * malloc. The fractional part is always .00000
     * The arrays should be freed by the user.
     */
	float* coords;
	long size;
	float* data = [[[roi curView] curDCM] getROIValue:&size :roi :&coords];

    for (int i = 0, j = 0; i < (int)size; i++, j+=2)
    {
        [retVal appendFormat:@",%d,%d,%.6f,\n", (int)coords[j], (int)coords[j+1],
         data[i]];
    }

    return retVal;
}

// Extract the values and coordinates for the ROIs in one slice
- (NSString*)extractRoiInfoInSlice:(NSArray*)roiList
{
    NSMutableString* retVal = [NSMutableString stringWithCapacity:1000];

    for (ROI* roi in roiList)
    {
        [retVal appendString:[self extractRoiValuesAndCoordinates:roi]];
    }

    return retVal;
}

// Extract the values and coordinates for the ROIs in one image, potentially
// with more than one slice.
- (NSString*)extractRoiInfoInImage:(NSArray*)roiListList
{
    NSMutableString* retVal = [NSMutableString stringWithCapacity:1000];

    int sliceIdx = 0;
    for (NSArray* roiList in roiListList)
    {
        if (roiList.count != 0)
        {
            [retVal appendFormat:@"Slice: %d,,,,\n", sliceIdx];
            [retVal appendString:[self extractRoiInfoInSlice:roiList]];
        }
        ++sliceIdx;
    }

    return retVal;
}

// Extract the values and coordinates for the ROIs in the whole series.
- (NSString*)extractRoiInfoInSeries
{
    NSMutableString* retVal = [NSMutableString stringWithCapacity:1000];

    for (int timeIdx = 0; timeIdx < numTimeImages; ++timeIdx)
    {
        // The ROIs for this image.
        NSArray* roiListList = [viewerController roiList:timeIdx];

        // See if there are any ROIs in this image.
        BOOL roiFound = NO;
        for (NSArray* array in roiListList)
        {
            if (array.count != 0)
                roiFound = YES;
        }

        // Process image only if there is one or more ROIs.
        if (roiFound)
        {
            [retVal appendFormat:@"Image: %d,,,,\n", timeIdx];
            [retVal appendString:[self extractRoiInfoInImage:roiListList]];
        }
    }

    return retVal;
}

- (NSError*)saveData:(NSString*)data to:(NSURL*)url
{
    NSInteger i;

    NSOutputStream* stream = [NSOutputStream outputStreamWithURL:url append:NO];
    [stream open];
    i = [stream write:(const uint8_t *)[data UTF8String] maxLength:data.length];

    NSLog(@"%d bytes written of %d max.", (int)i, (int)data.length);

    NSError* error = [stream streamError];
    return error;
}

@end
