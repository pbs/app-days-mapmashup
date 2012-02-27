//
//  SettingsViewController.m
//  MapMashup
//
//  Created by Rares Zehan on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (IBAction)toggleShowPolygons:(id)sender {
    UISwitch *showPolygonsSwtch = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_POLYGONS object:[NSNumber numberWithBool:showPolygonsSwtch.on]];
}

- (IBAction)toggleShowBroadcastOverlays:(id)sender {
    UISwitch *showPolygonsSwtch = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_BROADCAST_OVERLAYS object:[NSNumber numberWithBool:showPolygonsSwtch.on]];
}
@end
