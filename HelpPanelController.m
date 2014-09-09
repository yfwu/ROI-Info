//
//  HelpPanelController.m
//  ROI_Info
//
//  Created by Tim Allman on 2014-09-09.
//
//

#import "HelpPanelController.h"

@interface HelpPanelController ()

@end

@implementation HelpPanelController
@synthesize textView;

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    if (self)
    {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* path = [bundle pathForResource:@"Readme" ofType:@"rtf"];

    [textView readRTFDFromFile:path];
}

@end
