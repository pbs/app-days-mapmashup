//
//  DTVAPIHeadendDelegate.m
//  PBSiPad
//
//  Created by Matthew Norton on 8/2/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "DTVAPIHeadendDelegate.h"
#import "BaseDTVAPIDelegate.h"
#import "DTVHeadend.h"
#import "DTVClientAPI.h"

@implementation DTVAPIHeadendDelegate : BaseDTVAPIDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    
	NSArray* resultsArray = [super getResultsArray:[request responseData]];
    
    if([self validateResponseForRequest:request andResult:resultsArray]) {
        
        NSMutableArray* results = [NSMutableArray array];
        DTVHeadend *headend;
        
        for(NSDictionary* current in resultsArray) {
            headend = [DTVHeadend headendWithDictionary:current];
            if(headend != nil)
                [results addObject:headend];
        }
        
        [self.delegate didFindResults:results];
    }
}

@end
