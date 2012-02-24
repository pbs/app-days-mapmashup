//
//  DTVFeed.m
//  PBSiPad
//
//  Created by Matthew Norton on 8/1/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "DTVFeed.h"


@implementation DTVFeed

@synthesize feedCommonName;
@synthesize feedID;
@synthesize feedName;
@synthesize otaVisible;
@synthesize parentTvdataName;
@synthesize cableChannel;
@synthesize stationID;
@synthesize callLetters;


+ (DTVFeed*) feedWithStationDictionary: (NSDictionary*) dictionary {
	
	DTVFeed* feed = [[DTVFeed alloc] init];
	
	dictionary = [self validate:dictionary];
	if(dictionary == nil) {
    [feed release];
    return nil;
  }
	
	feed.feedCommonName = [dictionary objectForKey:@"feed_common_name"];	
	feed.feedID = [dictionary objectForKey:@"feed_id"];
	feed.feedName = [dictionary objectForKey:@"feed_name"];
	feed.otaVisible = [@"Y" isEqualToString:[dictionary objectForKey:@"ota_visible"]];
	feed.parentTvdataName = [dictionary objectForKey:@"parent_tvdata"];
	
	return [feed autorelease];
}
		 
+ (DTVFeed*) feedWithHeadendDictionary: (NSDictionary*) dictionary {
	
	dictionary = [self validate:dictionary];
	if(dictionary == nil) return nil;
	
	DTVFeed* feed = [[DTVFeed alloc] init];
	
	feed.feedCommonName = [dictionary objectForKey:@"feed_common_name"];	
	feed.feedID = [dictionary objectForKey:@"feed_id"];
	feed.feedName = [dictionary objectForKey:@"feed_name"];
	feed.cableChannel = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"cable_channel"] intValue]];
	feed.stationID = [dictionary objectForKey:@"station_id"];
		 
	return [feed autorelease];
}

+ (DTVFeed*) feedWithMetadataDictionary: (NSDictionary*) dictionary {
	
	dictionary = [self validate:dictionary];
	if(dictionary == nil) return nil;
	
	DTVFeed* feed = [[DTVFeed alloc] init];
	
	feed.feedCommonName = [dictionary objectForKey:@"feed_common_name"];	
	feed.feedID = [dictionary objectForKey:@"feed_id"];
	
	if([[dictionary objectForKey:@"channel_number"] intValue] == ceil([[dictionary objectForKey:@"channel_number"] floatValue]))
	   feed.cableChannel = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"channel_number"] intValue]];
	else
	   feed.cableChannel = [dictionary objectForKey:@"channel_number"];
	
	return [feed autorelease];
}

- (NSString*) description {
	return [self.feedID stringValue];
}

// Validates feed data, returning nil if the data is unusable
// Also sets default values for fields if not defined
+ (NSDictionary*) validate: (NSDictionary*) dictionary {
	NSMutableDictionary *mDictionary = [dictionary mutableCopy];
	
	if( (NSNull *)[mDictionary objectForKey:@"feed_id"] == [NSNull null] || [mDictionary objectForKey:@"feed_id"] == nil ) {
//		DebugLog(@"feed_id is null");
		// We cannot work with a feed that has no feedID
		[mDictionary release];
		return nil;
	}
	
	if( (NSNull *)[mDictionary objectForKey:@"feed_common_name"] == [NSNull null] ) {
		// We can't allow the common name to be null, if the common name is null use the feed name in its place
		[mDictionary setValue:[mDictionary objectForKey:@"feed_name"] forKey:@"feed_common_name"];
	}
	
	return [mDictionary autorelease];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.feedCommonName forKey:@"FeedCommonName"];
	[aCoder encodeObject:self.feedID forKey:@"FeedID"];
	[aCoder encodeObject:self.feedName forKey:@"FeedName"];
	[aCoder encodeObject:self.cableChannel forKey:@"CableChannel"];
	[aCoder encodeObject:self.stationID forKey:@"StationID"];
	[aCoder encodeObject:self.parentTvdataName forKey:@"ParentTvdataName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self.feedCommonName = [aDecoder decodeObjectForKey:@"FeedCommonName"];
	self.feedID = [aDecoder decodeObjectForKey:@"FeedID"];
	self.feedName = [aDecoder decodeObjectForKey:@"FeedName"];
	self.cableChannel = [aDecoder decodeObjectForKey:@"CableChannel"];
	self.stationID = [aDecoder decodeObjectForKey:@"StationID"];
	self.parentTvdataName = [aDecoder decodeObjectForKey:@"ParentTvdataName"];
	return self;
}

- (void)dealloc
{
	[feedCommonName release];
	[feedID release];
	[feedName release];
	[cableChannel release];
	[stationID release];
	self.parentTvdataName = nil;
	
	[super dealloc];
}



@end
