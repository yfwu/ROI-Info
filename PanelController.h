//
//  PanelController.h
//  ROI_Info
//
//  Created by Tim Allman on 2014-09-08.
//
//

#import <Cocoa/Cocoa.h>

@class ViewerController;
@class ROI_InfoFilter;
@class HelpPanelController;

@interface PanelController : NSWindowController <NSWindowDelegate>
{
    enum RoiSelectionType
    {
        AllInImage,
        AllInSeries
    };

    enum RoiSelectionType RoiSelection;
    
    ViewerController* viewerController;
    ROI_InfoFilter* pluginFilter;
    HelpPanelController* helpPanelController;

    int curImageIdx;
    int curTimeIdx;
    int numTimeImages;
    NSURL* saveFile;

    IBOutlet NSButton *extractInfoButton;
    IBOutlet NSButton *helpButton;
    IBOutlet NSButton *closeButton;

}

- (id)initWithViewerController:(ViewerController *)vc
                     andFilter:(ROI_InfoFilter*)filter;

- (IBAction)extractButtonPressed:(id)sender;
- (IBAction)helpButtonPressed:(id)sender;
- (IBAction)closeButtonPressed:(id)sender;

@end
