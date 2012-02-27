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
@synthesize stationImage;
@synthesize logoImage;
@synthesize stationTitle;

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
    __block StationAnnotation *annotation = [[StationAnnotation alloc] init];
    annotation.coordinate = stationCoordinate;
    annotation.stationTitle = graphicalStation.callsign;
    annotation.title = graphicalStation.callsign;
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:graphicalStation.towerImageURLString]];
    [request setCompletionBlock:^{
        NSData *imageData = [request responseData];
        annotation.stationImage = [UIImage imageWithData:imageData];
    }];
    [request setFailedBlock:^{
        NSLog(@"Error while making the request: %@", request.error.localizedDescription);
    }];
    [request startAsynchronous];

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
