//
//  BaseCOVEAPIDelegate.h
//  PBSiPad
//
//  Created by Robert Rosenburgh on 7/30/10.
//  Copyright 2010 BRE Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@class COVEClientAPI;

@protocol COVEClientAPIDelegate;

@interface BaseCOVEAPIDelegate : NSObject <ASIHTTPRequestDelegate> {
	id <COVEClientAPIDelegate> delegate;
	NSString* requestId;
}

- (NSArray*) getResultsArray:(NSData *) data;
- (BOOL) validateResponseForRequest:(ASIHTTPRequest *)request andResult:(NSArray *)result;

@property (nonatomic, assign) id <COVEClientAPIDelegate> delegate;
@property (nonatomic, assign) COVEClientAPI *client;
@property (nonatomic, retain) NSString* requestId;


@end
