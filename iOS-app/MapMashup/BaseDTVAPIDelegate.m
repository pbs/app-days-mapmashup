//
//  BaseDTVAPIDelegate.m
//  PBSiPad
//
//  Created by Matthew Norton on 8/2/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "BaseDTVAPIDelegate.h"
#import "JSONKit.h"
#import "DTVClientAPI.h"
#import "ASIDownloadCache.h"
#import "CommonDefines.h"

@implementation BaseDTVAPIDelegate

@synthesize delegate;
@synthesize client;

- (NSArray*) getResultsArray:(NSData *) data {
	NSError* error = nil;	
	NSArray* results = [data objectFromJSONDataWithParseOptions:JKParseOptionLooseUnicode error:&error];
    if(!error) {
        return results;
    }
    return nil;
}

- (BOOL) validateResponseForRequest:(ASIHTTPRequest *)request andResult:(NSArray *)result {
    
    if([request responseStatusCode] < 400) {
        
        // this means JSON parsing has failed, trigger request Failed method
        if(!result) {
            [[ASIDownloadCache sharedCache] removeCachedDataForRequest:request];
            [self requestFailed:request];
            return NO;
        }
        
        // repsonse empty, remove response from cache, but consider it a valid response
        if([result count] == 0) {
            [[ASIDownloadCache sharedCache] removeCachedDataForRequest:request];
        }
        
    } else {
        
        // error http status code, trigger requestFailed method
        [[ASIDownloadCache sharedCache] removeCachedDataForRequest:request];
        [self requestFailed:request];
        return NO;
        
    }
    
    return YES;
}


- (void)requestFailed:(ASIHTTPRequest *)request {
	
    NSError *error = [request error];
    if(error.code != ASIRequestCancelledErrorType) {
        
        NSNumber *retryCount = (NSNumber *)[request.userInfo objectForKey:@"pbsRetryCount"];
        if (!retryCount) {
            retryCount = [NSNumber numberWithInt:0];
        }
        if ([retryCount intValue] < 3) {
            
			ASIHTTPRequest *newRequest = [request copy];
            retryCount = [NSNumber numberWithInt:[retryCount intValue] + 1];
			
			if(newRequest.userInfo == nil) newRequest.userInfo = [NSDictionary dictionaryWithObject:retryCount forKey:@"pbsRetryCount"];
			else {
				NSMutableDictionary *uI = [NSMutableDictionary dictionaryWithDictionary:newRequest.userInfo];
				[uI setValue:retryCount forKey:@"pbsRetryCount"];
				newRequest.userInfo = [NSDictionary dictionaryWithDictionary:uI]; 
			}
			[newRequest setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
            
            [newRequest startAsynchronous];
			
			[self.client.requests addObject:newRequest];
			
			[newRequest release];
            
            return;
            
        } else {

            [self.delegate didFail:error];
            
            NSMutableDictionary *notificationData = [NSMutableDictionary dictionary];
            [notificationData setValue:TVSCHEDULES_API forKey:@"api"];
            [notificationData setValue:[request.url absoluteString] forKey:@"url"];

            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FAILED_REQUEST object:notificationData];
        }
    }
//    DebugLog(@"Connection failed! Error - %@",[error localizedDescription]);
}

- (void) dealloc {
	[super dealloc];
}

@end