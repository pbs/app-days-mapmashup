//
//  ViewController.h
//  MapMashup
//
//  Created by Rares Zehan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "ASIHTTPRequestDelegate.h"
#import "DTVClientAPI.h"
#import "MBProgressHUD.h"

@interface MapMashupViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate, DTVClientAPIDelegate, ASIHTTPRequestDelegate, MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIToolbar *mainToolbar;
@property (strong, nonatomic) UIStoryboardPopoverSegue *popoverSegue;

@end
