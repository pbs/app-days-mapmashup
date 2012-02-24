//
//  DTVAPIFeedDelegate.m
//  PBSiPad
//
//  Created by Matthew Norton on 8/2/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "DTVAPIFeedDelegate.h"
#import "BaseDTVAPIDelegate.h"
#import "DTVFeed.h"
#import "DTVClientAPI.h"

@implementation DTVAPIFeedDelegate : BaseDTVAPIDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    
	NSArray* resultsArray = [super getResultsArray:[request responseData]];
    
    if([self validateResponseForRequest:request andResult:resultsArray]) {
        
        NSMutableArray* results = [NSMutableArray array];
        DTVFeed *feed;
        
        for(NSDictionary* current in resultsArray) {
            feed = [DTVFeed feedWithMetadataDictionary:current];
            if(feed != nil)							// If the feed doesn't contain necessary data, it will be nil
                [results addObject:feed];
        }
        
        [self.delegate didFindResults:results];
    }
}

@end
