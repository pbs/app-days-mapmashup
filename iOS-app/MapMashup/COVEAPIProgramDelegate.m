//
//  ProgramDelegate.m
//  PBSiPad
//
//  Created by Robert Rosenburgh on 7/30/10.
//  Copyright 2010 BRE Technology LLC. All rights reserved.
//

#import "COVEAPIProgramDelegate.h"
#import "BaseCOVEAPIDelegate.h"
#import "COVEProgram.h"
#import "COVEClientAPI.h"

@implementation COVEAPIProgramDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSArray* resultsArray = [super getResultsArray:[request responseData]];
    
	if([self validateResponseForRequest:request andResult:resultsArray]) {
        
        NSMutableArray* results = [NSMutableArray array];
        
        for(NSDictionary* current in resultsArray) {
            [results addObject:[COVEProgram programWithDictionary:current]];
        }
        
        [self.delegate requestId:self.requestId didFindResults:results];    
    }        
}

@end
