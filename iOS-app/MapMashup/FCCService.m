//
//  FCCService.m
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FCCService.h"
#import "ASIHTTPRequest.h"

#define FCC_DATA_URL @"http://192.168.1.148/~rareszehan/map-mashup/stations-json/"

@implementation FCCService

- (void)downloadFCCData:(NSString *)stationName delegate:(id)delegate {
    NSString* urlString = [NSString stringWithFormat:@"%@%@.json", FCC_DATA_URL, stationName];
	NSLog(@"url: %@", urlString);
	NSURL* url = [NSURL URLWithString:urlString];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	[request setSecondsToCache:120];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
	request.delegate = delegate;
    [request startAsynchronous];
}

@end
