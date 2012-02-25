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
#import "MKPolygon+ColorExtension.h"
#import "UIColor+RGBHexExtension.h"

@interface MapViewController ()

@property (strong, nonatomic) DTVClientAPI* dtvAPI;
@property (strong, nonatomic) NSMutableDictionary *polygonsDictionary;

- (void)addGrapicalStationOnMap:(GraphicalStation *)station;

@end

@implementation MapViewController

@synthesize mapView;
@synthesize currentLocation;
@synthesize dtvAPI;
@synthesize polygonsDictionary;

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
    
    if ([annotation isKindOfClass:[StationAnnotation class]])   // for stations
    {
        static NSString* StationAnnotationIdentifier = @"StationAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:StationAnnotationIdentifier];

        if (!pinView)
        {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:StationAnnotationIdentifier];
//            annotationView.canShowCallout = YES;
            UIImage *stationImage = [UIImage imageNamed:@"station_tower_0x00ff00.gif"];
            annotationView.image = stationImage;
            annotationView.opaque = NO;
            return annotationView;
        } 
    } else {
        MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
        return annView;
    }
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    NSLog(@"overlay class: %@", [overlay class]);
    
    if([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygon *signalOverlay = overlay;
        MKPolygonView *view = [[MKPolygonView alloc] initWithOverlay:overlay];
        view.lineWidth=2;
        view.strokeColor=signalOverlay.polygonColor;
        view.fillColor=[signalOverlay.polygonColor colorWithAlphaComponent:0.4];
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

- (void)didFail:(NSError *)error {
    NSLog(@"request failed, reason: %@", error.localizedDescription);
    FCCService *fccService = [[FCCService alloc] init];
    [fccService downloadFCCData:@"WMPB" delegate:self];
    [fccService downloadFCCData:@"WHUT" delegate:self];
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
    
    MKPolygon *stationSignalOverlay = [MKPolygon polygonWithCoordinates:polygonCoordinates count:numberOfPoints];
    stationSignalOverlay.polygonColor = [UIColor colorFromHexString:station.stationColorRGBValue];
    [self.mapView addOverlay:stationSignalOverlay];
    
    CLLocationDegrees stationLatitude = [[station.towerCoordinates objectAtIndex:0] doubleValue];
    CLLocationDegrees stationLongitude = [[station.towerCoordinates objectAtIndex:1] doubleValue];
    CLLocationCoordinate2D stationCoordinate = CLLocationCoordinate2DMake(stationLatitude, stationLongitude);
    
    StationAnnotation *stationAnnotation = [StationAnnotation initStationAnnotationWithCoordinate:stationCoordinate andTitle:station.callsign];
//    stationAnnotation.stationImage = UIImage imageNamed:@"";
    [self.mapView addAnnotation:stationAnnotation];
}
                                            
                                            
@end
