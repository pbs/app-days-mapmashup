//
//  CalloutViewController.h
//  MapMashup
//
//  Created by Rares Zehan on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationDetailsViewController : UIViewController

@property (strong, nonatomic) NSString *stationWebsiteURLString;

@property (weak, nonatomic) IBOutlet UIWebView *stationDetailsWebView;
- (IBAction)doneViewingDetails:(id)sender;

@end
