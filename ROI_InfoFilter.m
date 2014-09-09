//
//  ROI_InfoFilter.m
//  ROI_Info
//
//  Copyright (c) 2014 Tim. All rights reserved.
//

#import "ROI_InfoFilter.h"
#import "PanelController.h"

#import <OsiriXAPI/Notifications.h>

@implementation ROI_InfoFilter

- (void) initPlugin
{
    NSLog(@"ROI_Info loaded.");
}

- (long) filterImage:(NSString*) menuName
{
    panelController = [[PanelController alloc]
                       initWithViewerController: viewerController andFilter:self];

    //Make sure to catch the viewer closing and changing events.
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(viewerWillClose:)
                                                  name:OsirixCloseViewerNotification
                                                object:viewerController];

    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(viewerWillChange:)
                                                  name:OsirixViewerWillChangeNotification
                                                object:viewerController];

    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(viewerDidChange:)
                                                  name:OsirixViewerDidChangeNotification
                                                object:viewerController];


    return 0;
}

// Our viewer is about to close.
- (void)viewerWillClose:(NSNotification*)notification
{
    NSLog(@"viewerWillClose: %@", [notification name]);

    [panelController close];
    [panelController release];
    panelController = nil;
}

// Our viewer is about to change
- (void)viewerWillChange:(NSNotification*)notification
{
    NSLog(@"viewerWillChange: %@", [notification name]);

    [panelController close];
    [panelController release];
    panelController = nil;
}

// There is a new viewer to attach to.
- (void)viewerDidChange:(NSNotification*)notification
{
    NSLog(@"viewerDidChange: %@", [notification name]);

    panelController = [[PanelController alloc]
                       initWithViewerController: viewerController andFilter:self];
    [panelController showWindow:self];
}

@end
