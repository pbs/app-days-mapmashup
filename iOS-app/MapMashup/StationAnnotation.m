//
//  StationAnnotation.m
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StationAnnotation.h"
#import "GraphicalStation.h"

@implementation StationAnnotation

@synthesize coordinate;
@synthesize stationImage;
@synthesize logoImage;
@synthesize stationTitle;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

+ (StationAnnotation *)stationAnnotationFromGraphicalStation:(GraphicalStation *)graphicalStation {
    
    CLLocationDegrees stationLatitude = [[graphicalStation.towerCoordinates objectAtIndex:0] doubleValue];
    CLLocationDegrees stationLongitude = [[graphicalStation.towerCoordinates objectAtIndex:1] doubleValue];
    CLLocationCoordinate2D stationCoordinate = CLLocationCoordinate2DMake(stationLatitude, stationLongitude);
    StationAnnotation *annotation = [[StationAnnotation alloc] init];
    annotation.coordinate = stationCoordinate;
    annotation.stationTitle = graphicalStation.callsign;
    annotation.stationImage = [UIImage imageNamed:@"station_tower_0x0000ff.gif"];
    NSURL *logoURL = [NSURL URLWithString:graphicalStation.stationLogoUrlString];
    NSData *logoData = [NSData dataWithContentsOfURL:logoURL];
    annotation.logoImage = [UIImage imageWithData:logoData];
    return annotation;
}

+ (StationAnnotation *) annotationWithCoordinates:(CLLocationCoordinate2D)coordinates {
    StationAnnotation *annotation = [[StationAnnotation alloc] init];
    annotation.coordinate = coordinates;
    return annotation;
}

@end
