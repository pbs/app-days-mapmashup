//
//  DTVClientAPI.h
//  PBSiPad
//
//  Created by Matthew Norton on 8/2/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDTVAPIDelegate.h"
#import "DTVStation.h"
#import "DTVFeed.h"
#import "DTVHeadend.h"
#import "ASIHTTPRequest.h"
	
@protocol DTVClientAPIDelegate
	
-(void) didFindResults:(NSArray*) results;
-(void) didFail:(NSError*) error;

@end
	

@interface DTVClientAPI : NSObject {
	id delegate;
	NSMutableArray* requests;
    NSMutableArray* dtvApiDelegates;
}
	
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSMutableArray* requests;
@property (nonatomic, retain) NSMutableArray* dtvApiDelegates;
	
- (void) getHeadendsForZip:(NSString*)zip;
- (void) getStationsForZip:(NSString*)zip;
- (void) getStationsForHeadend:(DTVHeadend*) headend;
- (void) getFeedsForStation:(DTVStation*)station;
- (void) getFeedsForHeadend:(DTVHeadend*)headend station:(DTVStation*)station;
- (void) getFeedsForHeadend:(DTVHeadend*)headend stations:(NSArray*)stations;
- (void) getFeedsForHeadend:(DTVHeadend*)headend zip:(NSString*)zip;
- (void) getAirdatesForFeed:(NSNumber*) feed headend:(DTVHeadend*) headend;
- (void) getAirdatesForFeed:(NSNumber*) feed headend:(DTVHeadend*) headend date:(NSDate *) date;
- (void) getProgramIDForNolaRoot:(NSString*)nolaRoot;
- (void) getAirdatesForProgramId:(NSNumber*)programID feeds:(NSArray*) feeds headend:(DTVHeadend*) headend;
- (void) getAirdatesForEpisodeId:(NSNumber*)programID feeds:(NSArray*) feeds headend:(DTVHeadend*) headend;
	
- (void) cancelRequests;
+ (id) sanitize:(id) value;
+ (id) sanitize:(id)value withDefault:(id)defaultValue;

@end
