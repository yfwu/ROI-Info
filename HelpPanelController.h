//
//  HelpPanelController.h
//  ROI_Info
//
//  Created by Tim Allman on 2014-09-09.
//
//

#import <Cocoa/Cocoa.h>

@interface HelpPanelController : NSWindowController
{
    NSTextView *textView;
}

@property (assign) IBOutlet NSTextView *textView;

@end
