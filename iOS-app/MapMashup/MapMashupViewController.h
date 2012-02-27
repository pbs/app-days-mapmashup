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

@interface MapMashupViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate, DTVClientAPIDelegate, ASIHTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UIToolbar *mainToolbar;

@end
