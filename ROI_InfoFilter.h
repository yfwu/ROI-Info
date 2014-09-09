//
//  ROI_InfoFilter.h
//  ROI_Info
//
//  Copyright (c) 2014 Tim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>

@class PanelController;

@interface ROI_InfoFilter : PluginFilter
{
    PanelController* panelController;

}

- (long) filterImage:(NSString*) menuName;


@end
