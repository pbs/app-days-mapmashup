//
//  GraphicalStation.m
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphicalStation.h"

@implementation GraphicalStation

@synthesize callsign;
@synthesize polygonBounds;
@synthesize polygonCoordinatesArray;
@synthesize stationColorRGBValue;
@synthesize towerCoordinates;
@synthesize towerImageURLString;
@synthesize stationLogoUrlString;
@synthesize broadcastOverlayUrlString;
@synthesize stationWebsiteUrlString;

+ (GraphicalStation *) stationFromDictionary:(NSDictionary *)dictionary {
    GraphicalStation *station = [[GraphicalStation alloc] init];
    
    station.callsign = [dictionary objectForKey:@"callsign"];
    station.towerCoordinates = [dictionary objectForKey:@"towerCoordinates"];
    station.polygonBounds = [dictionary objectForKey:@"polygonBounds"];
    station.stationColorRGBValue = [dictionary objectForKey:@"stationColor"];
    station.polygonCoordinatesArray = [dictionary objectForKey:@"polygonCoordinatesArray"];
    station.towerImageURLString = [dictionary objectForKey:@"towerimage"];
    station.stationLogoUrlString = [dictionary objectForKey:@"stationlogo"];
    station.broadcastOverlayUrlString = [dictionary objectForKey:@"broadcastOverlay"];
    station.stationWebsiteUrlString = [dictionary objectForKey:@"station_website"];
    
    return station;
}

@end
