//
//  ViewController.m
//  MapMashup
//
//  Created by Rares Zehan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "DTVClientAPI.h"
#import "FCCService.h"
#import "JSONKit.h"
#import "GraphicalStation.h"
#import "StationAnnotation.h"

//washington dc : 38.8613, -77.0567

@interface MapViewController ()

@property (strong, nonatomic) DTVClientAPI* dtvAPI;

- (void)addGrapicalStationOnMap:(GraphicalStation *)station;

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
    region.span.latitudeDelta = 1.5;
    region.span.longitudeDelta = 1.5;
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

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay{
    if([overlay isKindOfClass:[MKPolygon class]]){
        MKPolygonView *view = [[MKPolygonView alloc] initWithOverlay:overlay];
        view.lineWidth=1;
        view.strokeColor=[UIColor blueColor];
        view.fillColor=[[UIColor blueColor] colorWithAlphaComponent:0.5];
        return view;
    }
    return nil;
}

#pragma mark - DTV API Delegate
- (void) didFindResults:(NSArray*) results {
	NSLog(@"stationsFoundArray=%@", results);
    FCCService *fccService = [[FCCService alloc] init];
    
    for (NSString *stationName in results) {        
        [fccService downloadFCCData:stationName delegate:self];
    }
}

#pragma mark - ASIHTTPRequest Delegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *stationsFCCArray = [[request responseData] objectFromJSONData];
    [self addGrapicalStationOnMap:[GraphicalStation stationFromDictionary:stationsFCCArray]];
}

#pragma mark - private methods
- (void)addGrapicalStationOnMap:(GraphicalStation *)station {
    
    NSLog(@"graphical stations's callsign = %@", station.polygonCoordinatesArray);
    
    int numberOfPoints = station.polygonCoordinatesArray.count;
    CLLocationCoordinate2D polygonCoordinates[numberOfPoints];
    int i = 0;
    
    for (NSArray *coordinateArray in station.polygonCoordinatesArray) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[coordinateArray objectAtIndex:0] doubleValue], [[coordinateArray objectAtIndex:1] doubleValue]);
        polygonCoordinates[i++] = coordinate;
    }
    
    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:polygonCoordinates count:numberOfPoints];
    [self.mapView addOverlay:polygon];
    
    StationAnnotation *stationAnnotation = [[StationAnnotation alloc] init];
    [self.mapView addAnnotation:stationAnnotation];
}


@end
