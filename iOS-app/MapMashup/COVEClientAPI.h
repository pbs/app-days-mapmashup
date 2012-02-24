//
//  COVEService.h
//  PBSiPad
//
//  Created by Robert Rosenburgh on 7/28/10.
//  Copyright 2010 BRE Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

#define DEVICE_IS_IPHONE4 ([COVEClientAPI isiPhone4])
#define DEVICE_IS_IPAD ([COVEClientAPI getUserInterfaceIdiom])

@class COVECategory, COVEEpisode, BaseCOVEAPIDelegate;

@protocol COVEClientAPIDelegate

-(void) requestId:(NSString*)requestId didFindResults:(NSArray*) results;
-(void) requestId:(NSString*)requestId didFail:(NSError*) error;

@end


@interface COVEClientAPI : NSObject {
	id delegate;
	NSMutableArray* requests;
    NSMutableArray* coveApiDelegates;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSMutableArray* requests;
@property (nonatomic, retain) NSMutableArray* coveApiDelegates;

- (void) getAvailableNolaCodesWithRequestId:(NSString*)requestId;
- (void) getAllProgramsWithRequestId:(NSString*)requestId;
- (void) getAllCategoriesWithRequestId:(NSString*)requestId;

- (void) getProgramsWithProducerNameIn:(NSArray *)producerNames
                     withRequestId:(NSString *)requestId;

- (void) getProgramsWithoutProducerNameInList:(NSArray *)producerNames
                         withRequestId:(NSString *)requestId;


- (void) getProgramsWithoutProducerName:(NSString *)producerName
                     withRequestId:(NSString *)requestId;

- (void) getProgramsByProducerName:(NSString *)producerName
                     withRequestId:(NSString *)requestId;

- (void) getProgramsWithProducerNameInList:(NSString *)producerNames
                         withRequestId:(NSString *)requestId;

- (void) getProgramsByCategory:(COVECategory *) categoryID
                 withRequestId:(NSString*)requestId;
- (void) getProgramByResourceURI:(NSString*) resourceURI
                   withRequestId:(NSString*)requestId;

- (void) getProgramByIdList:(NSString *)idList 
              withRequestId:(NSString *)requestId;

- (void) getProgramBySlug:(NSString *)slug 
                 withRequestId:(NSString *)requestId;

- (void) getEpisodesByGroup:(NSString*) group
              withRequestId:(NSString*)requestId;
- (void) getEpisodesByProgramId:(NSString *)programId 
				  withRequestId:(NSString*)requestId;
- (void) getEpisodesByNolaRoot:(NSString*) nolaRoot
                 withRequestId:(NSString*)requestId;
- (void) getEpisodesByNolaRoot:(NSString *)nolaRoot 
                andEpisodeNola:(NSString *)episodeNola 
                 withRequestId:(NSString *)requestId;
- (void) getEpisodesByTPMediaId:(NSString *)tpMediaId
                  withRequestId:(NSString *)requestId;
- (void) getEpisodeByResourceURI:(NSString*) resourceURI
                   withRequestId:(NSString*)requestId;
- (void) getEpisodesByMediaIdList:(NSString *)mediaIdList withRequestId:(NSString *)requestId;
- (void) getSegmentsForEpisode:(COVEEpisode *)episode withRequestId:(NSString *)requestId;
- (void) cancelRequests;

+ (id) sanitize:(id)value;
+ (id) sanitize:(id)value withDefault:(id)defaultValue;
- (ASIHTTPRequest *) requestSignedWithURL:(NSURL *) url consumerKey:(NSString *) consumerKey secretKey: (NSString *) secretKey;

+ (BOOL)isiPhone4;
+ (BOOL)getUserInterfaceIdiom;
+ (void)setUseQAKeys:(BOOL)setting;
+ (BOOL)useQAKeys;

@end
