//
//  COVEAPICategoryDelegate.m
//  PBSiPad
//
//  Created by Jason Jenkins on 9/11/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "COVEAPICategoryDelegate.h"
#import "BaseCOVEAPIDelegate.h"
#import "COVECategory.h"
#import "COVEClientAPI.h"

@implementation COVEAPICategoryDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSArray* resultsArray = [super getResultsArray:[request responseData]];
    
    if([self validateResponseForRequest:request andResult:resultsArray]) {
        
        NSMutableArray* results = [NSMutableArray array];
        NSMutableDictionary * categories = [NSMutableDictionary dictionary];
        for(NSDictionary* current in resultsArray) {
            COVECategory * category = [COVECategory categoryWithDictionary:current];
            [categories setObject:category forKey:category.categoryId];
            NSString * parentId = [[current objectForKey:@"parent"] objectForKey:@"id"];
            COVECategory * parent = [categories objectForKey:parentId];
            if (parent == NULL) {
                // category is a root category, add to the result
                [results addObject:category];
            } else {
                //You're a child, meet your dad.
                [parent addChild:category];
            }
        }
        
        [self.delegate requestId:self.requestId didFindResults:results];
    }    
}
@end
