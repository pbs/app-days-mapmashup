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
@synthesize showPolygonsSwitch;
@synthesize showBroadcastOverlaysSwitch;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidUnload {
    [self setShowPolygonsSwitch:nil];
    [self setShowBroadcastOverlaysSwitch:nil];
    [super viewDidUnload];
}
- (IBAction)toggleShowPolygons:(id)sender {
    UISwitch *showPolygonsSwtch = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_POLYGONS" object:[NSNumber numberWithBool:showPolygonsSwtch.on]];
    NSLog(@"polygons=%@", showPolygonsSwtch.on ? @"ON" : @"OFF");
}

- (IBAction)toggleShowBroadcastOverlays:(id)sender {
    UISwitch *showPolygonsSwtch = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_BROADCAST_OVERLAYS" object:[NSNumber numberWithBool:showPolygonsSwtch.on]];
    NSLog(@"broadcastoverlay=%@", showPolygonsSwtch.on ? @"ON" : @"OFF");
}
@end
