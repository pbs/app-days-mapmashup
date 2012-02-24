//
//  DTVAPIAirdateDelegate.m
//  PBSiPad
//
//  Created by Matthew Norton on 8/7/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "DTVAPIAirdateDelegate.h"
#import "BaseDTVAPIDelegate.h"
#import "DTVAirdate.h"
#import "DTVClientAPI.h"


@implementation DTVAPIAirdateDelegate : BaseDTVAPIDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {

    NSArray* resultsArray = [super getResultsArray:[request responseData]];
    
    if([self validateResponseForRequest:request andResult:resultsArray]) {
        
        NSMutableArray* results = [NSMutableArray array];
        
        for(NSDictionary* current in resultsArray) {
            [results addObject:[DTVAirdate airdateWithDictionary:current]];
        }
        
        [self.delegate didFindResults:results];
    }
}

@end
