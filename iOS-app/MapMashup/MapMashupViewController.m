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
#import "StationSignalOverlayView.h"
#import "MKPolygon+BroadcastInfo.h"
#import "MKPolyline+BroadcastInfo.h"
#import "UIColor+HexRGBAddition.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MapMashupViewController ()
@property (strong, nonatomic) DTVClientAPI* dtvAPI;

@property (strong, nonatomic) NSMutableArray *polygonsArray;
@property (strong, nonatomic) NSMutableArray *polygonsOverlayArray;

- (void)addGrapicalStationOnMap:(GraphicalStation *)station;
- (void)showPolygons:(id)sender;
- (void)showBroadcastOverlays:(id)sender;
@end

@implementation MapMashupViewController

@synthesize mapView;
@synthesize currentLocation;
@synthesize mainToolbar;
@synthesize dtvAPI;
@synthesize polygonsArray;
@synthesize polygonsOverlayArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dtvAPI = [[DTVClientAPI alloc] init];
    self.dtvAPI.delegate = self;
    
    self.polygonsArray = [NSMutableArray array];
    self.polygonsOverlayArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPolygons:) name:NOTIFICATION_SHOW_POLYGONS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBroadcastOverlays:) name:NOTIFICATION_SHOW_BROADCAST_OVERLAYS object:nil];
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setMainToolbar:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)showPolygons:(id)sender {
    NSNotification *notification = sender;
    BOOL show = [((NSNumber *) notification.object) boolValue];
    
    if (!show) {
        [self.mapView removeOverlays:self.polygonsArray];
    } else {
        [self.mapView addOverlays:self.polygonsArray];
    }
}

- (void)showBroadcastOverlays:(id)sender {
    NSNotification *notification = sender;
    BOOL show = [((NSNumber *) notification.object) boolValue];
    
    if (!show) {
        [self.mapView removeOverlays:polygonsOverlayArray];
    } else {
        [self.mapView addOverlays:polygonsOverlayArray];
    }
}

#pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)currentMapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
	region.center = userLocation.location.coordinate;
    region.span.latitudeDelta = 3.5;
    region.span.longitudeDelta = 3.5;
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
    
    if ([annotation isKindOfClass:[StationAnnotation class]]) {  // annotation for stations 
        StationAnnotation *stationAnnotation = annotation;
        
        if (stationAnnotation.logoImage != nil) {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:StationAnnotationIdentifier];
            annotationView.image = stationAnnotation.logoImage;
            //annotationView.image = stationAnnotation.stationImage;
            annotationView.opaque = NO;
            return annotationView;
        }
    }
    
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    return annView;
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) { // signal bounds polygon line 
        MKPolylineView *view = [[MKPolylineView alloc] initWithOverlay:overlay];
        view.lineWidth = 3;
        UIColor *color = ((MKPolyline *)overlay).broadcastColor;
        view.strokeColor = color;
        return view;
    } else if([overlay isKindOfClass:[MKPolygon class]]) { // broadcast overlay type
        MKPolygon *signalOverlay = overlay;
        StationSignalOverlayView *view = [[StationSignalOverlayView alloc] initWithOverlay:overlay];
        view.overlayBoundsCoordsStrArray = signalOverlay.coordinateBoundsArray;
        view.broadcastOverlayImage = signalOverlay.broadcastOverlayImage;
        return view;
    }
    return nil;
}

#pragma mark - DTV API Delegate
- (void) didFindResults:(NSArray*) results {
    FCCService *fccService = [[FCCService alloc] init];
    
        for (NSString *stationName in results) {        
            [fccService downloadFCCData:stationName delegate:self];
        }
    
//    [fccService downloadFCCData:@"WMPB" delegate:self];
}

- (void)didFail:(NSError *)error {
    NSLog(@"request failed, reason: %@", error.localizedDescription);
    //    FCCService *fccService = [[FCCService alloc] init];
    //    [fccService downloadFCCData:@"WMPB" delegate:self];
    //    [fccService downloadFCCData:@"WHUT" delegate:self];
}

#pragma mark - ASIHTTPRequest Delegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *stationsFCCArray = [[request responseData] objectFromJSONData];
    [self addGrapicalStationOnMap:[GraphicalStation stationFromDictionary:stationsFCCArray]];
}

#pragma mark - private methods
- (void)addGrapicalStationOnMap:(GraphicalStation *)station {
    
    NSLog(@"adding graphical station: %@", station.callsign);
    
    int numberOfPoints = station.polygonCoordinatesArray.count;
    CLLocationCoordinate2D polygonCoordinates[numberOfPoints];
    int i = 0;
    
    for (NSArray *coordinateArray in station.polygonCoordinatesArray) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[coordinateArray objectAtIndex:0] doubleValue], [[coordinateArray objectAtIndex:1] doubleValue]);
        polygonCoordinates[i++] = coordinate;
    }
    
    MKPolyline *stationPolylineOverlay = [MKPolyline polylineWithCoordinates:polygonCoordinates count:numberOfPoints];
    stationPolylineOverlay.broadcastColor = [UIColor colorWithHexValue:[station.stationColorRGBValue substringFromIndex:2]];
    [self.mapView addOverlay:stationPolylineOverlay];
    [self.polygonsArray addObject:stationPolylineOverlay];
    
    MKPolygon *broadcastPolygonOverlay = [MKPolygon polygonWithCoordinates:polygonCoordinates count:numberOfPoints];
    broadcastPolygonOverlay.broadcastOverlayImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:station.broadcastOverlayUrlString]]];
    broadcastPolygonOverlay.coordinateBoundsArray = station.polygonBounds;
    [self.mapView addOverlay:broadcastPolygonOverlay];
    [self.polygonsOverlayArray addObject:broadcastPolygonOverlay];
    
    [self.mapView addAnnotation:[StationAnnotation stationAnnotationFromGraphicalStation:station]];
}


@end
