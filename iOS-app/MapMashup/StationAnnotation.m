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

-(id)initWithCoordinate:(CLLocationCoordinate2D) newCoordinate {
	self.coordinate = newCoordinate;
	return self;
}

@end
