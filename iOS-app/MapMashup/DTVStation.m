//
//  DTVStation.m
//  PBSiPad
//
//  Created by Matthew Norton on 8/1/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "DTVStation.h"


@implementation DTVStation


@synthesize commonName;
@synthesize city;
@synthesize state;
@synthesize rank;
@synthesize tvdataName;
@synthesize stationID;
@synthesize feeds;


+ (DTVStation*) stationWithDictionary: (NSDictionary*) dictionary {
	
    dictionary = [self validate:dictionary];
	if(dictionary == nil) return nil;
	
	DTVStation* station = [[DTVStation alloc] init];
	
	station.commonName = [dictionary objectForKey:@"common_name"];	
	station.city = [dictionary objectForKey:@"mailing_city"];
	station.state = [dictionary objectForKey:@"mailing_state"];
	station.rank = [dictionary objectForKey:@"rank"];
	station.tvdataName = [dictionary objectForKey:@"tvdata_name"];
	
	return [station autorelease];
}

// Validates station data, returning nil if the data is unusable
// Also sets default values for fields if not defined
+ (NSDictionary*) validate: (NSDictionary*) dictionary {
	NSMutableDictionary *mDictionary = [dictionary mutableCopy];
	
	// We cannot work with a station that has no tv data name
	if( (NSNull *)[mDictionary objectForKey:@"tvdata_name"] == [NSNull null] ) {
		[mDictionary release];
		return nil;
	}
	
	// We can't allow the common name to be null, if the common name is null use the tv data name in its place
	if( (NSNull *)[mDictionary objectForKey:@"common_name"] == [NSNull null] )
		[mDictionary setValue:[mDictionary objectForKey:@"tvdata_name"] forKey:@"common_name"];
	
	// For display purposes city and state must be non-null (blank is ok)
	if( (NSNull *)[mDictionary objectForKey:@"mailing_city"] == [NSNull null] )
		[mDictionary setValue:@"" forKey:@"mailing_city"];
	if( (NSNull *)[mDictionary objectForKey:@"mailing_state"] == [NSNull null] )
		[mDictionary setValue:@"" forKey:@"mailing_state"];
	
	return [mDictionary autorelease];
}

- (NSString*) description {
	return self.tvdataName;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.commonName forKey:@"commonName"];
	[aCoder encodeObject:self.city forKey:@"city"];
	[aCoder encodeObject:self.state forKey:@"state"];
	[aCoder encodeObject:self.rank forKey:@"rank"];
	[aCoder encodeObject:self.tvdataName forKey:@"tvdataName"];
	[aCoder encodeObject:self.stationID forKey:@"stationID"];
    [aCoder encodeObject:self.feeds forKey:@"feeds"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.commonName = [aDecoder decodeObjectForKey:@"commonName"];
    self.city = [aDecoder decodeObjectForKey:@"city"];
    self.state = [aDecoder decodeObjectForKey:@"state"];
    self.rank = [aDecoder decodeObjectForKey:@"rank"];
    self.tvdataName = [aDecoder decodeObjectForKey:@"tvdataName"];
    self.stationID = [aDecoder decodeObjectForKey:@"stationID"];
    self.feeds = [aDecoder decodeObjectForKey:@"feeds"];
	return self;
}

- (void)dealloc
{
	[commonName release];
	[city release];
	[state release];
	[rank release];
	[tvdataName release];
	self.feeds = nil;
	self.stationID = nil;
	[super dealloc];
}


@end

