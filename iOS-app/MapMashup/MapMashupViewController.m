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
#import "StationDetailsViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MapMashupViewController () {
    CLLocationCoordinate2D currentLocation;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) DTVClientAPI* dtvAPI;
@property (strong, nonatomic) NSMutableArray *polygonsArray;
@property (strong, nonatomic) NSMutableArray *polygonsOverlayArray;
@property (strong, nonatomic) NSMutableArray *stationAnnotationsArray;
@property (strong, nonatomic) GraphicalStation *selectedStationForDetails;
@property (readwrite, nonatomic) BOOL showPolygons;
@property (readwrite, nonatomic) BOOL showOverlays;

- (void)addGrapicalStationOnMap:(GraphicalStation *)station;
- (void)showPolygons:(id)sender;
- (void)showBroadcastOverlays:(id)sender;
- (void)zipCodeChanged:(id)sender;
- (void)updateLocation:(CLPlacemark *)placemark;
- (void)showsStationsForCurrentLocation:(id)sender;

@end

@implementation MapMashupViewController

@synthesize mapView;
@synthesize mainToolbar;
@synthesize popoverSegue;
@synthesize locationManager;
@synthesize dtvAPI;
@synthesize polygonsArray;
@synthesize polygonsOverlayArray;
@synthesize stationAnnotationsArray;
@synthesize selectedStationForDetails;
@synthesize showPolygons;
@synthesize showOverlays;


#pragma mark - View controller cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.dtvAPI = [[DTVClientAPI alloc] init];
    self.dtvAPI.delegate = self;
    
    self.polygonsArray = [NSMutableArray array];
    self.polygonsOverlayArray = [NSMutableArray array];
    self.stationAnnotationsArray = [NSMutableArray array];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *showPolygonsNumber = [defaults objectForKey:USER_DEFAULTS_SHOW_POLYGONS];
    
    if (showPolygonsNumber == nil) {
        self.showPolygons = NO;
    } else {
        self.showPolygons = [showPolygonsNumber boolValue];
    }
    
    NSNumber *showOverlaysNumber = [defaults objectForKey:USER_DEFAULTS_SHOW_OVERLAYS];
    
    if (showOverlaysNumber == nil) {
        self.showOverlays = NO;
    } else {
        self.showOverlays = [showOverlaysNumber boolValue];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPolygons:) name:NOTIFICATION_SHOW_POLYGONS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBroadcastOverlays:) name:NOTIFICATION_SHOW_BROADCAST_OVERLAYS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zipCodeChanged:) name:NOTIFICATION_ZIP_CODE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showsStationsForCurrentLocation:) name:NOTIFICATION_SHOW_STATIONS_FOR_CURRENT_LOCATION object:nil];
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setMainToolbar:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [[segue identifier] isEqualToString:@"settingsPopoverSegue"] ) {
        self.popoverSegue = (UIStoryboardPopoverSegue *)segue;
        [[segue destinationViewController] setDelegate:self];
    }
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"updating location...");
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            [self updateLocation:placemark];
            [self.locationManager stopUpdatingLocation];
        }
    }];
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
        for (CLPlacemark *placemark in placemarks) {
            [self updateLocation:placemark];
        }
    }];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if ([view.annotation isKindOfClass:[StationAnnotation class]]) {  // annotation for stations 
        StationAnnotation *stationAnnotation = view.annotation;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        StationDetailsViewController *statationDetailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"CalloutViewController"];
        statationDetailsViewController.stationWebsiteURLString = stationAnnotation.stationWebsiteURLString;
        [self presentModalViewController:statationDetailsViewController animated:YES];
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    
    static NSString* StationAnnotationIdentifier = @"StationAnnotationIdentifier";
    
    if ([annotation isKindOfClass:[StationAnnotation class]]) {  // annotation for stations 
        StationAnnotation *stationAnnotation = annotation;
        
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:StationAnnotationIdentifier];
        annotationView.opaque = NO;
        annotationView.canShowCallout = YES;
        
        // adding annotation image async
        __weak ASIHTTPRequest *annotationImageRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:stationAnnotation.stationAnnotationImageURLString]];
        [annotationImageRequest setCompletionBlock:^{
            NSData *imageData = [annotationImageRequest responseData];
            annotationView.image = [UIImage imageWithData:imageData];
        }];
        [annotationImageRequest setFailedBlock:^{
            NSLog(@"Error while making the request: %@", annotationImageRequest.error.localizedDescription);
        }];
        [annotationImageRequest startAsynchronous];
        
        // adding callout image async
        __weak ASIHTTPRequest *calloutImageRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:stationAnnotation.stationLogoImageURLString]];
        [calloutImageRequest setCompletionBlock:^{
            NSData *imageData = [calloutImageRequest responseData];
            UIImageView *leftCalloutImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
            leftCalloutImageView.frame = CGRectMake(0, 0, 48.0, 32.0);
            annotationView.leftCalloutAccessoryView = leftCalloutImageView;
        }];
        [calloutImageRequest setFailedBlock:^{
            NSLog(@"Error while making the request: %@", calloutImageRequest.error.localizedDescription);
        }];
        [calloutImageRequest startAsynchronous];
        
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
    }
    
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    return annView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]] && self.showPolygons) { // signal bounds polygon line 
        MKPolylineView *view = [[MKPolylineView alloc] initWithOverlay:overlay];
        view.lineWidth = 3;
        UIColor *color = ((MKPolyline *)overlay).broadcastColor;
        view.strokeColor = color;
        return view;
    } else if([overlay isKindOfClass:[MKPolygon class]] && self.showOverlays) { // broadcast overlay type
        MKPolygon *signalOverlay = overlay;
        
        if (signalOverlay.broadcastOverlayImage != nil) {
            StationSignalOverlayView *view = [[StationSignalOverlayView alloc] initWithOverlay:overlay];
            view.overlayBoundsCoordsStrArray = signalOverlay.coordinateBoundsArray;
            view.broadcastOverlayImage = signalOverlay.broadcastOverlayImage;
            return view;
        }
    }
    return nil;
}

#pragma mark - DTV API Delegate
- (void) didFindResults:(NSArray*) results {
    FCCService *fccService = [[FCCService alloc] init];
    
    for (NSString *stationName in results) {        
        [fccService downloadFCCData:stationName delegate:self];
    }
}

- (void)didFail:(NSError *)error {
    NSLog(@"request failed, reason: %@", error.localizedDescription);
}

#pragma mark - ASIHTTPRequest Delegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *stationsFCCArray = [[request responseData] objectFromJSONData];
    
    if (stationsFCCArray != nil) {
        [self addGrapicalStationOnMap:[GraphicalStation stationFromDictionary:stationsFCCArray]];
    }
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
    
    MKPolyline *stationPolylineOverlay = [MKPolyline polylineWithCoordinates:polygonCoordinates count:numberOfPoints];
    stationPolylineOverlay.broadcastColor = [UIColor colorWithHexValue:[station.stationColorRGBValue substringFromIndex:2]];
    [self.mapView addOverlay:stationPolylineOverlay];
    [self.polygonsArray addObject:stationPolylineOverlay];
    
    MKPolygon *broadcastPolygonOverlay = [MKPolygon polygonWithCoordinates:polygonCoordinates count:numberOfPoints];
    broadcastPolygonOverlay.coordinateBoundsArray = station.polygonBounds;
    broadcastPolygonOverlay.broadcastOverlayImageURLString = station.broadcastOverlayUrlString;
    [self.polygonsOverlayArray addObject:broadcastPolygonOverlay];
    
    if (showOverlays) {
        
        // adding callout image async
        __weak ASIHTTPRequest *overlayImageRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:station.broadcastOverlayUrlString]];
        [overlayImageRequest setCompletionBlock:^{
            NSData *imageData = [overlayImageRequest responseData];
            broadcastPolygonOverlay.broadcastOverlayImage = [UIImage imageWithData:imageData];
            [self.mapView addOverlay:broadcastPolygonOverlay];
        }];
        [overlayImageRequest setFailedBlock:^{
            NSLog(@"Error while making the request: %@", overlayImageRequest.error.localizedDescription);
        }];
        [overlayImageRequest startAsynchronous];
    } 
    
    StationAnnotation *stationAnnotation = [StationAnnotation stationAnnotationFromGraphicalStation:station];
    [self.mapView addAnnotation:stationAnnotation];
    [self.stationAnnotationsArray addObject:stationAnnotation];
    
    [self.mapView setCenterCoordinate:currentLocation];
}

- (void)showPolygons:(id)sender {
    NSNotification *notification = sender;
    BOOL show = [((NSNumber *) notification.object) boolValue];
    self.showPolygons = show;
    
    if (!show) {
        [self.mapView removeOverlays:self.polygonsArray];
    } else {
        [self.mapView addOverlays:self.polygonsArray];
    }
}

- (void)showBroadcastOverlays:(id)sender {
    NSNotification *notification = sender;
    BOOL show = [((NSNumber *) notification.object) boolValue];
    self.showOverlays = show;
    
    if (!show) {
        [self.mapView removeOverlays:self.polygonsOverlayArray];
    } else {
        for (MKPolygon *overlayPol in self.polygonsOverlayArray) {
            
            if (overlayPol.broadcastOverlayImage != nil) {
                [self.mapView addOverlay:overlayPol];
            } else {
                
                // adding callout image async
                __weak ASIHTTPRequest *overlayImageRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:overlayPol.broadcastOverlayImageURLString]];
                [overlayImageRequest setCompletionBlock:^{
                    NSData *imageData = [overlayImageRequest responseData];
                    overlayPol.broadcastOverlayImage = [UIImage imageWithData:imageData];
                    [self.mapView addOverlay:overlayPol];
                }];
                [overlayImageRequest setFailedBlock:^{
                    NSLog(@"Error while making the request: %@", overlayImageRequest.error.localizedDescription);
                }];
                [overlayImageRequest startAsynchronous];
            }
        }
    }
}

- (void)zipCodeChanged:(id)sender {
    NSNotification *notification = sender;
    int newZipCode = [((NSNumber *) notification.object) intValue];
    NSDictionary *addressDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", newZipCode], @"ZIP",  @"United States", @"Country", nil];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressDictionary:addressDictionary completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            [self updateLocation:placemark];
        }
    }];
    if ([self.popoverSegue.popoverController isPopoverVisible]) {
        [self.popoverSegue.popoverController dismissPopoverAnimated:YES];        
    }
}

- (void)showsStationsForCurrentLocation:(id)sender {
    if ([self.popoverSegue.popoverController isPopoverVisible]) {
        [self.popoverSegue.popoverController dismissPopoverAnimated:YES];        
    }
    [self.locationManager startUpdatingLocation];
}

- (void)updateLocation:(CLPlacemark *)placemark {
    [self.mapView removeOverlays:polygonsArray];
    [self.polygonsArray removeAllObjects];
    [self.mapView removeOverlays:polygonsOverlayArray];
    [self.polygonsOverlayArray removeAllObjects];
    [self.mapView removeAnnotations:stationAnnotationsArray];
    [self.stationAnnotationsArray removeAllObjects];
    
    [self.dtvAPI getStationsForZip:placemark.postalCode];
    currentLocation = placemark.location.coordinate;
}

@end
