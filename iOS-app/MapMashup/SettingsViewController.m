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
@synthesize showOverlaysSwitch;

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *showPolygonsNumber = [defaults objectForKey:USER_DEFAULTS_SHOW_POLYGONS];
    
    if (showPolygonsNumber == nil) {
        self.showPolygonsSwitch.on = NO;
    } else {
        self.showPolygonsSwitch.on = [showPolygonsNumber boolValue];
    }
    
    NSNumber *showOverlaysNumber = [defaults objectForKey:USER_DEFAULTS_SHOW_OVERLAYS];
    
    if (showOverlaysNumber == nil) {
        self.showOverlaysSwitch.on = NO;
    } else {
        self.showOverlaysSwitch.on = [showOverlaysNumber boolValue];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidUnload {
    [self setShowPolygonsSwitch:nil];
    [self setShowOverlaysSwitch:nil];
    [super viewDidUnload];
}
- (IBAction)toggleShowPolygons:(id)sender {
    UISwitch *showPolygonsSwtch = sender;
    NSNumber *showBoolNumber = [NSNumber numberWithBool:showPolygonsSwtch.on];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:showBoolNumber forKey:USER_DEFAULTS_SHOW_POLYGONS];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_POLYGONS object:showBoolNumber];
}

- (IBAction)toggleShowBroadcastOverlays:(id)sender {
    UISwitch *showPolygonsSwtch = sender;
    NSNumber *showBoolNumber = [NSNumber numberWithBool:showPolygonsSwtch.on];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:showBoolNumber forKey:USER_DEFAULTS_SHOW_OVERLAYS];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_BROADCAST_OVERLAYS object:showBoolNumber];
    
}

- (IBAction)showStationsForCurrentLocation:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_STATIONS_FOR_CURRENT_LOCATION object:nil];
}
@end
