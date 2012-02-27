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

@property (strong, nonatomic) NSString *stationAnnotationImageURLString;
@property (strong, nonatomic) NSString *stationLogoImageURLString;
@property (strong, nonatomic) NSString *stationWebsiteURLString;

@end
