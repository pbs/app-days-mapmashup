//
//  DTVAirdate.m
//  PBSiPad
//
//  Created by Matthew Norton on 8/6/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "DTVAirdate.h"
#import "DTVClientAPI.h"


@implementation DTVAirdate

@synthesize title;
@synthesize episodeTitle;
@synthesize short_description;
@synthesize description;
@synthesize channel;
@synthesize duration;
@synthesize nolaRoot;
@synthesize nolaEpisode;
@synthesize feedID;
@synthesize startTime;
@synthesize endTime;
@synthesize live;
@synthesize cc;
@synthesize tvRating;
@synthesize feedCommonName;
@synthesize vendorRefNumber;


+ (DTVAirdate*) airdateWithDictionary:(NSDictionary*)dictionary {
//	dictionary = [self validate:dictionary];
	if(dictionary == nil) return nil;
	
	DTVAirdate* airdate = [[DTVAirdate alloc] init];
	
	airdate.title = [DTVClientAPI sanitize:[dictionary objectForKey:@"tg_title"]];
	airdate.episodeTitle = [DTVClientAPI sanitize:[dictionary objectForKey:@"tg_episode_title"]];
	airdate.short_description = [DTVClientAPI sanitize:[dictionary objectForKey:@"tg_short_description"]];
	airdate.description = [DTVClientAPI sanitize:[dictionary objectForKey:@"tg_description"]];
	
	if([dictionary objectForKey:@"cable_channel"])
		airdate.channel = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"cable_channel"] intValue]];
	else
		airdate.channel = [dictionary objectForKey:@"channel_number"];
	
	NSString *rawDuration = [DTVClientAPI sanitize:[dictionary objectForKey:@"duration"]];
    if (![rawDuration isEqualToString:@""]) {
        airdate.duration = [NSNumber numberWithInt:(([[rawDuration substringToIndex:2] intValue]*60) + [[rawDuration substringFromIndex:2] intValue])*60];
    }
    else {
        airdate.duration = [NSNumber numberWithInt:0];
    }
	
	
	airdate.nolaRoot = [DTVClientAPI sanitize:[dictionary objectForKey:@"nola_code_1"]];
	airdate.nolaEpisode = [[DTVClientAPI sanitize:[dictionary objectForKey:@"nola_code_2"] withDefault:[NSNumber numberWithInt:0]] stringValue];
	
	airdate.feedID = [DTVClientAPI sanitize:[dictionary objectForKey:@"feed_id"] withDefault:[NSNumber numberWithInt:0]] ;
	airdate.feedCommonName = [DTVClientAPI sanitize:[dictionary objectForKey:@"feed_common_name"]];
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];		// This deals with the timezone difference
	
	airdate.startTime = [dateFormatter dateFromString:[DTVClientAPI sanitize:[dictionary objectForKey:@"pbs_start_time"]]];
	airdate.endTime = [dateFormatter dateFromString:[DTVClientAPI sanitize:[dictionary objectForKey:@"pbs_end_time"]]];
	
	airdate.live = [@"Y" isEqualToString:[DTVClientAPI sanitize:[dictionary objectForKey:@"live_yn"]]];
	
	airdate.cc = [@"Y" isEqualToString:[DTVClientAPI sanitize:[dictionary objectForKey:@"cc_yn"]]];
	airdate.tvRating = [DTVClientAPI sanitize:[dictionary objectForKey:@"tv_rating"]];
    
    airdate.vendorRefNumber = [DTVClientAPI sanitize:[dictionary objectForKey:@"vendor_ref_number"] withDefault:[NSNumber numberWithInt:0]];
	
	return [airdate autorelease];
}

// Validates airdate data, returning nil if the data is unusable
// Also sets default values for fields if not defined
+ (NSDictionary*) validate: (NSDictionary*) dictionary {
	NSMutableDictionary *mDictionary = [dictionary mutableCopy];
	
	// TODO: Fill in validation checks
	
	return [mDictionary autorelease];
}

- (void)dealloc
{
	[title release];
	[episodeTitle release];
	[short_description release];
	[description release];
	[channel release];
	[duration release];
	[nolaRoot release];
	[nolaEpisode release];
	[feedID release];
	[startTime release];
	[endTime release];
	[tvRating release];
	[feedCommonName release];
    [vendorRefNumber release];
	
	[super dealloc];
}

@end
