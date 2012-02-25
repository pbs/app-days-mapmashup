//
//  StationAnnotation.m
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StationAnnotation.h"

@implementation StationAnnotation

@synthesize coordinate;
@synthesize stationImage;
@synthesize stationTitle;

+ (StationAnnotation *) initStationAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *) title {
    StationAnnotation *annotation = [[StationAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.stationTitle = title;
    return annotation;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

+ (StationAnnotation *)stationAnnotationFromGraphicalStation:(GraphicalStation *)graphicalStation {
//    StationAnnotation *annotation = [[StationAnnotation alloc] init];
//    annotation.coordinate = coordinate;
//    annotation.stationTitle = title;
//    return annotation;
}

@end
