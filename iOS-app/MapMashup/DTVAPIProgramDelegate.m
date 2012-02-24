//
//  DTVAPIProgramDelegate.m
//  PBSiPad
//
//  Created by Matthew Norton on 9/13/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "DTVAPIProgramDelegate.h"
#import "BaseDTVAPIDelegate.h"
#import "DTVClientAPI.h"

@implementation DTVAPIProgramDelegate : BaseDTVAPIDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    
	NSArray* resultsArray = [super getResultsArray:[request responseData]];
    
    if([self validateResponseForRequest:request andResult:resultsArray]) {
        
        NSMutableArray* results = [NSMutableArray array];
        
        for(NSDictionary* current in resultsArray) {
            NSNumber* programID = [current objectForKey:@"program_id"];
            if(programID != nil)
                [results addObject:programID];
        }
        
        [self.delegate didFindResults:results];
    }
}

@end
