//
//  DTVAPIStationDelegate.m
//  PBSiPad
//
//  Created by Matthew Norton on 8/2/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "DTVAPIStationDelegate.h"
#import "BaseDTVAPIDelegate.h"
#import "DTVStation.h"
#import "DTVClientAPI.h"

@implementation DTVAPIStationDelegate : BaseDTVAPIDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
	
    NSArray* resultsArray = [super getResultsArray:[request responseData]];
    
    if([self validateResponseForRequest:request andResult:resultsArray]) {
        
        NSMutableArray* results = [NSMutableArray array];
        DTVStation *station;
        
        for(NSDictionary* current in resultsArray) {
            station = [DTVStation stationWithDictionary:current];
            if(station != nil)
                [results addObject:station];
        }
        
        [self.delegate didFindResults:results];
    }
}

@end
