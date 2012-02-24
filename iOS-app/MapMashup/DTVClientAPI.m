//
//  DTVClientAPI.m
//  PBSiPad
//
//  Created by Matthew Norton on 8/2/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "DTVClientAPI.h"
#import "DTVHeadend.h"
#import "DTVStation.h"
#import "DTVFeed.h"
#import "DTVAPIHeadendDelegate.h"
#import "DTVAPIStationDelegate.h"
#import "DTVAPIFeedDelegate.h"
#import "DTVAPIAirdateDelegate.h"
#import "DTVAPIProgramDelegate.h"
#import "COVEClientAPI.h"
#import "CommonDefines.h"

@implementation DTVClientAPI

@synthesize delegate;
@synthesize requests;
@synthesize dtvApiDelegates;

static NSString* iPadDtvApiURL = @"http://www.pbs.org/tvschedules/api/rest/";
static NSString* iPadDtvApiKey = @"ea2f2d5f21bc0b8e1f0e3378fb2dbbdc0e269c4e55a3d841b7ac66ed";

static NSString* iPhoneDtvApiURL = @"http://www.pbs.org/tvschedules/api/rest/";
static NSString* iPhoneDtvApiKey = @"c5d5f08f4affe4fc8f8dae8bcb4ac5bda654394f7ea01c60de76d117";

static NSString* dtvApiURL;
static NSString* dtvApiKey;


- (id)init {
    self = [super init];
    
    if (self) {
        self.requests = [NSMutableArray arrayWithCapacity:0];
        self.dtvApiDelegates = [NSMutableArray arrayWithCapacity:0];
        
        if (DEVICE_IS_IPAD) {
            dtvApiURL = iPadDtvApiURL;
            dtvApiKey = iPadDtvApiKey;
        }
        else {
            dtvApiURL = iPhoneDtvApiURL;
            dtvApiKey = iPhoneDtvApiKey;
        }
    }
	
	return self;
}

- (void) getHeadendsForZip:(NSString*) zip {
	NSString* urlString = [NSString stringWithFormat:@"%@stationFinder/getHeadendsByZipTagged?zipcode=%@&apikey=%@", dtvApiURL, zip, dtvApiKey];
	//NSLog(@"url: %@", urlString);
	NSURL* url = [NSURL URLWithString:urlString];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	[request setSecondsToCache:CACHE_TIME_JSON];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.requests addObject:request];
	BaseDTVAPIDelegate* apiDelegate = [[DTVAPIHeadendDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	request.delegate = apiDelegate;
    [dtvApiDelegates addObject:apiDelegate];
    [apiDelegate release];
	[request startAsynchronous];	
}

- (void) getStationsForHeadend:(DTVHeadend*) headend {
	NSString* urlString = [NSString stringWithFormat:@"%@stationFinder/getStationsByHeadend?headendID=%d&apikey=%@", dtvApiURL, [[headend headendID] intValue], dtvApiKey];
	//NSLog(@"url: %@", urlString);
	NSURL* url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	[request setSecondsToCache:CACHE_TIME_JSON];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.requests addObject:request];
	BaseDTVAPIDelegate* apiDelegate = [[DTVAPIStationDelegate alloc] init];
	apiDelegate.delegate = delegate;
	apiDelegate.client = self;
	request.delegate = apiDelegate;
    [dtvApiDelegates addObject:apiDelegate];
    [apiDelegate release];
	[request startAsynchronous];		
}

- (void) getStationsForZip:(NSString*) zip {
	NSString* urlString = [NSString stringWithFormat:@"%@stationFinder/getStationsByZip?zipcode=%@&apikey=%@", dtvApiURL, zip, dtvApiKey];
	//NSLog(@"url: %@", urlString);
	NSURL* url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	[request setSecondsToCache:CACHE_TIME_JSON];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.requests addObject:request];
	BaseDTVAPIDelegate* apiDelegate = [[DTVAPIStationDelegate alloc] init];
	apiDelegate.delegate = delegate;
	apiDelegate.client = self;
	request.delegate = apiDelegate;
    [dtvApiDelegates addObject:apiDelegate];
    [apiDelegate release];
	[request startAsynchronous];	
}

- (void) getFeedsForStation:(DTVStation*) station {
	NSString* urlString = [NSString stringWithFormat:@"%@stationFinder/getAllFeedsByStation?tvDataName=%@&apikey=%@", dtvApiURL, [station tvdataName], dtvApiKey];
	//NSLog(@"url: %@", urlString);
	NSURL* url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	[request setSecondsToCache:CACHE_TIME_JSON];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.requests addObject:request];
	BaseDTVAPIDelegate* apiDelegate = [[DTVAPIFeedDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	request.delegate = apiDelegate;
    [dtvApiDelegates addObject:apiDelegate];
    [apiDelegate release];
	[request startAsynchronous];
}

- (void) getFeedsForHeadend:(DTVHeadend*)headend station:(DTVStation*)station {
	NSString* urlString = [NSString stringWithFormat:@"%@tvSchedules/getFeedsWithMetadata?tvDataNames=%@&headendID=%@&apikey=%@", dtvApiURL, station.tvdataName, headend.headendID, dtvApiKey];
	//NSLog(@"url: %@", urlString);
	NSURL* url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	[request setSecondsToCache:CACHE_TIME_JSON];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.requests addObject:request];
	BaseDTVAPIDelegate* apiDelegate = [[DTVAPIFeedDelegate alloc] init];
	apiDelegate.delegate = delegate;
	apiDelegate.client = self;
	request.delegate = apiDelegate;
    [dtvApiDelegates addObject:apiDelegate];
    [apiDelegate release];
	[request startAsynchronous];
}

- (void) getFeedsForHeadend:(DTVHeadend*)headend stations:(NSArray*)stations {
	NSString* urlString = [NSString stringWithFormat:@"%@tvSchedules/getFeedsWithMetadata?tvDataNames=%@&headendID=%@&apikey=%@", dtvApiURL, [stations componentsJoinedByString:@"','"], [headend headendID], dtvApiKey];
	//NSLog(@"url: %@", urlString);
	NSURL* url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	[request setSecondsToCache:CACHE_TIME_JSON];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.requests addObject:request];
	BaseDTVAPIDelegate* apiDelegate = [[DTVAPIFeedDelegate alloc] init];
	apiDelegate.delegate = delegate;
	apiDelegate.client = self;
	request.delegate = apiDelegate;
    [dtvApiDelegates addObject:apiDelegate];
    [apiDelegate release];
	[request startAsynchronous];
}


/*
 note: we can't use this until DTV API is fixed
 */

- (void) getFeedsForHeadend:(DTVHeadend*)headend zip:(NSString*)zip {
	NSString* urlString = [NSString stringWithFormat:@"%@stationFinder/getFeedsByProvider?msoID=%@&zipcode=%@&apikey=%@", dtvApiURL, [headend msoID], zip, dtvApiKey];
	//NSLog(@"url: %@", urlString);
	NSURL* url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	[request setSecondsToCache:CACHE_TIME_JSON];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.requests addObject:request];
	BaseDTVAPIDelegate* apiDelegate = [[DTVAPIFeedDelegate alloc] init];
	apiDelegate.delegate = delegate;
	apiDelegate.client = self;
	request.delegate = apiDelegate;
    [dtvApiDelegates addObject:apiDelegate];
    [apiDelegate release];
	[request startAsynchronous];
}

- (void) getAirdatesForFeed:(NSNumber*) feed headend:(DTVHeadend*) headend {
	[self getAirdatesForFeed:feed headend:headend date:nil];
}

- (void) getAirdatesForFeed:(NSNumber*) feed headend:(DTVHeadend*) headend date:(NSDate *) date {
	if(date == nil) date = [NSDate date];
	
	// Create calendar for current TZ	
	NSCalendar *calendar = [NSCalendar currentCalendar];

	// Create a date representing midnight in the current timezone
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	
	NSDate *startDate = [calendar dateFromComponents:components];
	NSDate *endDate = [[NSDate alloc] initWithTimeInterval:86400 sinceDate:startDate];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	[timeFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	[dateFormat setDateFormat:@"YYYY-MM-dd"];
	[timeFormat setDateFormat:@"HH:mm:ss"];
	
	NSString *startDateStr = [NSString stringWithFormat:@"%@T%@",[dateFormat stringFromDate:startDate],[timeFormat stringFromDate:startDate]];
	NSString *endDateStr = [NSString stringWithFormat:@"%@T%@",[dateFormat stringFromDate:endDate],[timeFormat stringFromDate:endDate]];
	
	NSString* urlString;
	urlString = [NSString stringWithFormat:@"%@whatsOn/getAirdatesByFeeds?feedIDs=%d&startTime=%@&endTime=%@&apikey=%@", dtvApiURL, [feed intValue], startDateStr, endDateStr, dtvApiKey];
	
	NSURL* url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	[request setSecondsToCache:CACHE_TIME_JSON];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.requests addObject:request];
	BaseDTVAPIDelegate* apiDelegate = [[DTVAPIAirdateDelegate alloc] init];
	apiDelegate.delegate = delegate;
	apiDelegate.client = self;
	request.delegate = apiDelegate;
    [dtvApiDelegates addObject:apiDelegate];
    [apiDelegate release];
	[request startAsynchronous];
	[dateFormat release];
	[timeFormat release];
	[endDate release];
}

- (void) getAirdatesForProgramId:(NSNumber*)programID feeds:(NSArray*) feeds headend:(DTVHeadend*) headend {
	// Create calendar for current TZ	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	// Create a date representing midnight in the current timezone
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	
	NSDate *startDate = [calendar dateFromComponents:components];
	NSDate *endDate = [[NSDate alloc] initWithTimeInterval:86400 * 21 sinceDate:startDate];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	[timeFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	[dateFormat setDateFormat:@"YYYY-MM-dd"];
	[timeFormat setDateFormat:@"HH:mm:ss"];
	
	NSString *startDateStr = [NSString stringWithFormat:@"%@T%@",[dateFormat stringFromDate:startDate],[timeFormat stringFromDate:startDate]];
	NSString *endDateStr = [NSString stringWithFormat:@"%@T%@",[dateFormat stringFromDate:endDate],[timeFormat stringFromDate:endDate]];
	
	NSMutableArray* feedIDs = [NSMutableArray array];
	for (int i = 0; i < [feeds count]; i++) {
		DTVFeed* theFeed = [feeds objectAtIndex:i];
		[feedIDs addObject:theFeed.feedID];
	}
	
	NSString* urlString = [NSString stringWithFormat:@"%@whatsOn/getAirdatesByProgramFeed?programID=%d&feedIDs=%@&startTime=%@&endTime=%@&apikey=%@", dtvApiURL, [programID intValue], [feedIDs componentsJoinedByString:@","], startDateStr, endDateStr, dtvApiKey];
	//NSLog(@"url: %@", urlString);
	NSURL* url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	[request setSecondsToCache:CACHE_TIME_JSON];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.requests addObject:request];
	BaseDTVAPIDelegate* apiDelegate = [[DTVAPIAirdateDelegate alloc] init];
	apiDelegate.delegate = delegate;
	apiDelegate.client = self;
	request.delegate = apiDelegate;
    [dtvApiDelegates addObject:apiDelegate];
    [apiDelegate release];
	[request startAsynchronous];
	
	[dateFormat release];
	[timeFormat release];
	[endDate release];
}

- (void) getAirdatesForEpisodeId:(NSNumber*)programID feeds:(NSArray*) feeds headend:(DTVHeadend*) headend {
	// Create calendar for current TZ	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	// Create a date representing midnight in the current timezone
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	
	NSDate *startDate = [calendar dateFromComponents:components];
	NSDate *endDate = [[NSDate alloc] initWithTimeInterval:86400 * 21 sinceDate:startDate];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	[timeFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	[dateFormat setDateFormat:@"YYYY-MM-dd"];
	[timeFormat setDateFormat:@"HH:mm:ss"];
	
	NSString *startDateStr = [NSString stringWithFormat:@"%@T%@",[dateFormat stringFromDate:startDate],[timeFormat stringFromDate:startDate]];
	NSString *endDateStr = [NSString stringWithFormat:@"%@T%@",[dateFormat stringFromDate:endDate],[timeFormat stringFromDate:endDate]];
	
	NSMutableArray* feedIDs = [NSMutableArray array];
	for (int i = 0; i < [feeds count]; i++) {
		DTVFeed* theFeed = [feeds objectAtIndex:i];
		[feedIDs addObject:theFeed.feedID];
	}
	
	NSString* urlString = [NSString stringWithFormat:@"%@whatsOn/getAirdatesByEpisode?programID=%d&feedIDs=%@&startTime=%@&endTime=%@&apikey=%@", dtvApiURL, [programID intValue], [feedIDs componentsJoinedByString:@","], startDateStr, endDateStr, dtvApiKey];
	//NSLog(@"url: %@", urlString);
	NSURL* url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	[request setSecondsToCache:CACHE_TIME_JSON];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.requests addObject:request];
	BaseDTVAPIDelegate* apiDelegate = [[DTVAPIAirdateDelegate alloc] init];
	apiDelegate.delegate = delegate;
	apiDelegate.client = self;
	request.delegate = apiDelegate;
    [dtvApiDelegates addObject:apiDelegate];
    [apiDelegate release];
	[request startAsynchronous];
	
	[dateFormat release];
	[timeFormat release];
	[endDate release];
}

- (void) getProgramIDForNolaRoot:(NSString*)nolaRoot {
	NSString* urlString = [NSString stringWithFormat:@"%@programInfo/getProgramsByNolaRoot?nolaRoot=%@&apikey=%@", dtvApiURL, nolaRoot, dtvApiKey];
	//NSLog(@"url: %@", urlString);
	NSURL* url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	[request setSecondsToCache:CACHE_TIME_JSON];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self.requests addObject:request];
	BaseDTVAPIDelegate* apiDelegate = [[DTVAPIProgramDelegate alloc] init];
	apiDelegate.delegate = delegate;
	apiDelegate.client = self;
	request.delegate = apiDelegate;
    [dtvApiDelegates addObject:apiDelegate];
    [apiDelegate release];
	[request startAsynchronous];
}

+ (id) sanitize:(id) value {
	return [DTVClientAPI sanitize:value withDefault:@""];
}

+ (id) sanitize:(id)value withDefault:(id)defaultValue {
	if ((NSNull *)value == [NSNull null] || value == nil) {
		return defaultValue;
	} else {
		return value;
	}
}

- (void) cancelRequests {
	self.delegate = nil;
	for (ASIHTTPRequest* request in requests) {
		request.delegate = nil;
		[request cancel];
	}
}

- (void) dealloc {
	[self cancelRequests];
	[requests release];
	[dtvApiDelegates release];
	[super dealloc];
}

@end