//
//  BaseDTVAPIDelegate.h
//  PBSiPad
//
//  Created by Matthew Norton on 8/2/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"

@class DTVClientAPI;

@protocol DTVClientAPIDelegate;


@interface BaseDTVAPIDelegate : NSObject <ASIHTTPRequestDelegate> {
	id <DTVClientAPIDelegate> delegate;
}

@property (nonatomic, assign) id <DTVClientAPIDelegate> delegate;
@property (nonatomic, assign) DTVClientAPI *client;

- (BOOL) validateResponseForRequest:(ASIHTTPRequest *)request andResult:(NSArray *)result;
- (NSArray*) getResultsArray:(NSData *) data;

@end
