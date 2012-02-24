//
//  ViewController.m
//  MapMashup
//
//  Created by Rares Zehan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "DTVClientAPI.h"
//#import "SettingsViewController.h"

//washington dc : 38.8613, -77.0567

@interface MapViewController ()
@property (strong, nonatomic) DTVClientAPI* dtvAPI;
@end

@implementation MapViewController

@synthesize mapView;
@synthesize currentLocation;
@synthesize dtvAPI;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dtvAPI = [[DTVClientAPI alloc] init];
    self.dtvAPI.delegate = self;
    
    
//    MKOverlayView *overlay = [[MKOverlayView alloc] init];
//    overlay.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mapOverlay.png"]];
//    [self.mapView addOverlay:overlay.overlay];
}
    
- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (IBAction)settingsPushedAction:(id)sender {
    //    SettingsViewController *content = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    //    
    //	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:content];
    //	[navigationController setToolbarHidden:YES];
    //	[navigationController setNavigationBarHidden:NO];
    //    
    //    [content restoreLastUsedSettings];
	
    //	self.settingsPopoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    //	self.settingsPopoverController.delegate = self;
    //    self.settingsPopoverController.passthroughViews = [NSArray arrayWithObject:self.navigationView];
}

#pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)currentMapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
	region.center = userLocation.location.coordinate;
    region.span.latitudeDelta = 0.2;
    region.span.longitudeDelta = 0.2;
    [self.mapView setRegion:region];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSLog(@"zip= %@", placemark.postalCode);
            [self.dtvAPI getStationsForZip:placemark.postalCode];
        }
    }];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
	return annView;
}

#pragma mark - DTV API Delegate
- (void) didFindResults:(NSArray*) results {
	NSLog(@"stationsFoundArray=%@", results);
    
    for (NSString *stationName in results) {
        
        NSLog(@"%@", stationName);
        
        if ([@"WETA" isEqualToString:stationName]) {
            NSLog(@"found weta");
        }
    }
}

- (void) didFail:(NSError*) error {
}


@end
