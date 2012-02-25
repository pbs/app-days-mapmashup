//
//  GraphicalStation.h
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphicalStation : NSObject

+ (GraphicalStation *) stationFromDictionary:(NSDictionary *)dictionary;

@property (strong, nonatomic) NSString *callsign;
@property (strong, nonatomic) NSArray *polygonBounds;
@property (strong, nonatomic) NSArray *polygonCoordinatesArray;
@property (strong, nonatomic) NSString *stationColorRGBValue;
@property (strong, nonatomic) NSArray *towerCoordinates;
@property (strong, nonatomic) NSString *towerImageURLString;

@end
