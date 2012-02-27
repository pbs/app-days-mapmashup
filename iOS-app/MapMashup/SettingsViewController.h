//
//  SettingsViewController.h
//  MapMashup
//
//  Created by Rares Zehan on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UISwitch *showPolygonsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showOverlaysSwitch;
- (IBAction)toggleShowPolygons:(id)sender;
- (IBAction)toggleShowBroadcastOverlays:(id)sender;
- (IBAction)showStationsForCurrentLocation:(id)sender;

@end
