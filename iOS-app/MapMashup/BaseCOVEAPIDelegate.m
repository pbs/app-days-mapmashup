//
//  BaseCOVEAPIDelegate.m
//  PBSiPad
//
//  Created by Robert Rosenburgh on 7/30/10.
//  Copyright 2010 BRE Technology LLC. All rights reserved.
//

#import "BaseCOVEAPIDelegate.h"
#import "JSONKit.h"
#import "COVEProgram.h"
#import "COVEClientAPI.h"
#import "ASIDownloadCache.h"
#import "CommonDefines.h"

@implementation BaseCOVEAPIDelegate

@synthesize delegate;
@synthesize requestId;
@synthesize client;

- (NSArray*) getResultsArray:(NSData *) data {
	
    NSError* error = nil;
	NSDictionary* dictionary = [data objectFromJSONDataWithParseOptions:JKParseOptionLooseUnicode error:&error];
    if(!error) {
        return [dictionary objectForKey:@"results"];
    }
    // this will signal that there are errors on JSON parsing
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
	
	if(error.code != ASIRequestCancelledErrorType) {	// If we cancelled the request, its probably because the delegate is going away
    
        NSNumber *retryCount = (NSNumber *)[request.userInfo objectForKey:@"pbsRetryCount"];
        if (!retryCount) {
            retryCount = [NSNumber numberWithInt:0];
        }
        if ([retryCount intValue] < 3) {
//            DebugLog(@"retry : %d", [retryCount intValue]);
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
            
//            DebugLog(@"Connection failed! calling retry with retryCount - %@ Error - %@", retryCount, [error localizedDescription]);
            
            [self.delegate requestId:self.requestId didFail:error];
            
            NSMutableDictionary *notificationData = [NSMutableDictionary dictionary];
            [notificationData setValue:COVE_API forKey:@"api"];
            [notificationData setValue:[request.url absoluteString] forKey:@"url"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FAILED_REQUEST object:notificationData]; 
        
        }
        
    }
 	
	// inform the user
//    DebugLog(@"Connection failed! calling loadFailed Error - %@", [error localizedDescription]);
}

- (void) dealloc {
	self.requestId = nil;
	[super dealloc];
}

@end
