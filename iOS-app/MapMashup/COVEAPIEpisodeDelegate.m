//
//  COVEAPIEpisodeDelegate.m
//  PBSiPad
//
//  Created by Robert Rosenburgh on 7/30/10.
//  Copyright 2010 BRE Technology LLC. All rights reserved.
//

#import "COVEAPIEpisodeDelegate.h"
#import "COVEEpisode.h"
#import "BaseCOVEAPIDelegate.h"
#import "COVEClientAPI.h"

@implementation COVEAPIEpisodeDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
	
    NSArray* resultsArray = [super getResultsArray:[request responseData]];
    
    if([self validateResponseForRequest:request andResult:resultsArray]) {
        
        NSMutableArray* results = [NSMutableArray array];
        
        for(NSDictionary* current in resultsArray) {
            COVEEpisode* ep = [COVEEpisode episodeWithDictionary:current];
            
            if(ep != nil)
                [results addObject:ep];
        }
        
        [self.delegate requestId:self.requestId didFindResults:results];
    }
}

@end
