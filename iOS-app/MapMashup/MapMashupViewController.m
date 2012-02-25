//
//  ViewController.m
//  MapMashup
//
//  Created by Rares Zehan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapMashupViewController.h"
#import "DTVClientAPI.h"
#import "FCCService.h"
#import "JSONKit.h"
#import "GraphicalStation.h"
#import "StationAnnotation.h"
#import "MKPolygon+ColorExtension.h"
#import "UIColor+RGBHexExtension.h"

@interface MapMashupViewController ()
@property (strong, nonatomic) DTVClientAPI* dtvAPI;
- (void)addGrapicalStationOnMap:(GraphicalStation *)station;
@end

@implementation MapMashupViewController

@synthesize mapView;
@synthesize currentLocation;
@synthesize dtvAPI;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dtvAPI = [[DTVClientAPI alloc] init];
    self.dtvAPI.delegate = self;
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
    region.span.latitudeDelta = 2.5;
    region.span.longitudeDelta = 2.5;
    [self.mapView setRegion:region];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSLog(@"zip= %@", placemark.postalCode);
            [self.dtvAPI getStationsForZip:placemark.postalCode];
        }
    }];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    
    static NSString* StationAnnotationIdentifier = @"StationAnnotationIdentifier";
    
    if ([annotation isKindOfClass:[StationAnnotation class]]) {  // for stations 
        StationAnnotation *stationAnnotation = annotation;
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:StationAnnotationIdentifier];
        //annotationView.canShowCallout = YES;
        annotationView.image = stationAnnotation.stationImage;
        annotationView.opaque = NO;
        return annotationView;
        
    } else {
        MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
        return annView;
    }
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
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
    [self.mapView addAnnotation:[StationAnnotation stationAnnotationFromGraphicalStation:station]];
}


@end
