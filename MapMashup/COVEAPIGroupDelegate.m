//
//  COVEAPIGroupDelegate.m
//  PBSiPad
//
//  Created by Matthew Norton on 8/24/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "COVEAPIGroupDelegate.h"
#import "COVEEpisode.h"
#import "BaseCOVEAPIDelegate.h"
#import "COVEClientAPI.h"

@implementation COVEAPIGroupDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
	
    NSArray* resultsArray = [super getResultsArray:[request responseData]];
    
    if([self validateResponseForRequest:request andResult:resultsArray]) {
        if ([resultsArray count] == 0) {
            [self.delegate requestId:self.requestId didFail:[NSError errorWithDomain:@"COVE results empty" code:0 userInfo:nil]];
        } else {
            NSDictionary* group = [resultsArray objectAtIndex:0];
            
            NSArray* resultsArray = [group objectForKey:@"videos"] ;
            
            NSMutableArray* results = [NSMutableArray array];
            
            for(NSDictionary* current in resultsArray) {
                COVEEpisode* ep = [COVEEpisode episodeWithDictionary:current];
                
                if(ep != nil)
                    [results addObject:ep];
            }
            
            [self.delegate requestId:self.requestId didFindResults:results];
        }
    }
   
}

@end
