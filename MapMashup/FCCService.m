//
//  FCCService.m
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FCCService.h"
#import "ASIHTTPRequest.h"

#define FCC_DATA_URL @""

@implementation FCCService

@synthesize delegate;


- (void)downloadFCCData:(NSString *)stationName {
    NSString* urlString = [NSString stringWithFormat:@"%@%@", FCC_DATA_URL, stationName];
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

@end
