//
//  StationAnnotation.h
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class GraphicalStation;

@interface StationAnnotation : NSObject<MKAnnotation>

+ (StationAnnotation *) stationAnnotationFromGraphicalStation:(GraphicalStation *)graphicalStation;

+ (StationAnnotation *) annotationWithCoordinates:(CLLocationCoordinate2D)coordinates;

@property (strong, nonatomic) UIImage *stationImage;
@property (strong, nonatomic) UIImage *logoImage;
@property (strong, nonatomic) NSString *stationTitle;

@end
