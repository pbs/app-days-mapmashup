//
//  StationAnnotation.m
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StationAnnotation.h"
#import "GraphicalStation.h"
#import "ASIHTTPRequest.h"

@implementation StationAnnotation

@synthesize title;
@synthesize coordinate;
@synthesize stationAnnotationImageURLString;
@synthesize stationLogoImageURLString;
@synthesize stationWebsiteURLString;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

- (void)setTitle:(NSString *)newTitle {
    title = newTitle;
}

+ (StationAnnotation *)stationAnnotationFromGraphicalStation:(GraphicalStation *)graphicalStation {
    CLLocationDegrees stationLatitude = [[graphicalStation.towerCoordinates objectAtIndex:0] doubleValue];
    CLLocationDegrees stationLongitude = [[graphicalStation.towerCoordinates objectAtIndex:1] doubleValue];
    CLLocationCoordinate2D stationCoordinate = CLLocationCoordinate2DMake(stationLatitude, stationLongitude);
    
    StationAnnotation *annotation = [[StationAnnotation alloc] init];
    annotation.coordinate = stationCoordinate;
    annotation.title = graphicalStation.callsign;
    annotation.stationAnnotationImageURLString = graphicalStation.towerImageURLString;
    annotation.stationLogoImageURLString = graphicalStation.stationLogoUrlString;
    annotation.stationWebsiteURLString = graphicalStation.stationWebsiteUrlString;
    return annotation;
}

+ (StationAnnotation *) annotationWithCoordinates:(CLLocationCoordinate2D)coordinates {
    StationAnnotation *annotation = [[StationAnnotation alloc] init];
    annotation.coordinate = coordinates;
    return annotation;
}

@end
