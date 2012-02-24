//
//  COVEService.m
//  PBSiPad
//
//  Created by Robert Rosenburgh on 7/28/10.
//  Copyright 2010 BRE Technology LLC. All rights reserved.
//

#import "BaseCOVEAPIDelegate.h"
#import "COVEClientAPI.h"
#import "COVECategory.h"
#import "COVEProgram.h"
#import "COVEEpisode.h"
#import "COVEAPIProgramDelegate.h"
#import "COVEAPICategoryDelegate.h"
#import "COVEAPIEpisodeDelegate.h"
#import "COVEAPIGroupDelegate.h"
#import "CommonDefines.h"
#import <string.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation COVEClientAPI

@synthesize delegate;
@synthesize requests;
@synthesize coveApiDelegates;


static NSString* iPhoneConsumerKey = @"IPHONETTI-fff84c37-662c-4a98-9ff3-dcb90fa305ed";
static NSString* iPhoneSecretKey = @"bfc5bfe5-7452-489d-bf29-9b0315e16521";
static NSString* iPhoneCoveUrl = @"http://api.pbs.org/cove/v1/";

static NSString* iPadConsumerKey = @"IPADAPP-1c307d8d-ad54-431c-baa5-37f42cd565ba";
static NSString* iPadSecretKey = @"08e8142d-7151-4e37-92bf-af45ed719a77";
static NSString* iPadCoveUrl = @"http://api.pbs.org/cove/v1/";


static NSString* QAConsumerKey = @"iPadApp-QA-080f467e-c8d6-42f6-b3b8-bf2bc07308b9";
static NSString* QASecretKey = @"30b7d17e-2d40-4346-ae61-3f4174589afb";

static NSString* consumerKey;
static NSString* secretKey;
static NSString* coveUrl;

#ifdef DEBUG
static BOOL useQAKeys = YES;
#else
static BOOL useQAKeys = NO;
#endif

static int sIsiPhone4 = -1;
static int sIsiPad = -1;

- (id) init {    
    self = [super init];
    
    if (self) {
        self.requests = [NSMutableArray arrayWithCapacity:0];
        self.coveApiDelegates = [NSMutableArray arrayWithCapacity:0];
        
        if (DEVICE_IS_IPAD) {
            consumerKey = iPadConsumerKey;
            secretKey = iPadSecretKey;
            coveUrl = iPadCoveUrl;
        }
        else {
            consumerKey = iPhoneConsumerKey;
            secretKey = iPhoneSecretKey;
            coveUrl = iPhoneCoveUrl;
        }
        if (useQAKeys) {
            consumerKey = QAConsumerKey;
            secretKey = QASecretKey;
        }
    }
	
	return self;
}

- (void) getAvailableNolaCodesWithRequestId:(NSString*)requestId {
	NSURL* url = [NSURL URLWithString:
				  [NSString stringWithFormat:
				   @"%@videos/?fields=nola_root,nola_episode"
				   "&filter_mediafile_set__video_encoding__mime_type="
				   "application/x-mpegURL",
				   coveUrl]];
	//NSLog(@"Original COVE url: %@", url); 
	//NSLog(@"  Signed COVE url: %@", signedURL);
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIEpisodeDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
	request.numberOfTimesToRetryOnTimeout = 3;
    [request startAsynchronous];
	
}



- (void) getAllProgramsWithRequestId:(NSString*)requestId {
	NSURL* url = [NSURL URLWithString:
                [NSString stringWithFormat:
                 @"%@programs/?fields=title,short_description,long_description,"
                 "nola_root,associated_images,categories,shop_url,donate_url,website",
                 coveUrl]];
	//NSLog(@"Original COVE url: %@", url); 
	//NSLog(@"  Signed COVE url: %@", signedURL);
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIProgramDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
    request.numberOfTimesToRetryOnTimeout = 3;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
	[request startAsynchronous];
	
}


- (void) getProgramsWithProducerNameIn:(NSArray *)producerNames withRequestId:(NSString *)requestId {
    
    if([producerNames count] == 1) {
        [self getProgramsByProducerName:[producerNames objectAtIndex:0] withRequestId:requestId];
    } else {
        [self getProgramsWithProducerNameInList:[producerNames componentsJoinedByString:@","] withRequestId:requestId];
    }
}

- (void) getProgramsWithoutProducerName:(NSString *)producerName withRequestId:(NSString *)requestId {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:
                   @"%@programs/?fields=associated_images,categories&exclude_producer__name=%@",
                   coveUrl, producerName]];
    
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIProgramDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
}

- (void) getProgramsByProducerName:(NSString *)producerName withRequestId:(NSString *)requestId {
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:
                   @"%@programs/?fields=associated_images,categories&filter_producer__name=%@",
                   coveUrl, producerName]];

	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIProgramDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
}


- (void) getProgramsWithProducerNameInList:(NSString *)producerNames withRequestId:(NSString *)requestId {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:
                   @"%@programs/?fields=associated_images,categories&filter_producer__name__in=%@",
                   coveUrl, producerNames]];
    
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIProgramDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
    
}

- (void) getProgramsWithoutProducerNameInList:(NSString *)producerNames withRequestId:(NSString *)requestId {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:
                                       @"%@programs/?fields=associated_images,categories&exclude_producer__name__in=%@",
                                       coveUrl, producerNames]];
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIProgramDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
}


- (void) getAllCategoriesWithRequestId:(NSString*)requestId {
  NSURL* url = [NSURL URLWithString:
                [NSString stringWithFormat:
                 @"%@categories/?fields=name,id,parent__id",
                 coveUrl]];
	//NSLog(@"Original COVE url: %@", url); 
	//NSLog(@"  Signed COVE url: %@", signedURL);
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPICategoryDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
	
}

- (void) getProgramsByCategory:(COVECategory *) category
                 withRequestId:(NSString*)requestId 
{
  NSURL* url = [NSURL URLWithString:
                [NSString stringWithFormat:
                 @"%@programs/?fields=title,short_description,long_description,"
                 "nola_root,associated_images,categories,shop_url,donate_url,website"
                 "&filter_categories__id=%@",
                 coveUrl,
                 category.categoryId
                 ]];
  
	//NSLog(@"Original COVE url: %@", url); 
	//NSLog(@"  Signed COVE url: %@", signedURL);
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIProgramDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
	
}

- (void) getProgramByIdList:(NSString *)idList withRequestId:(NSString *)requestId 
{
    NSURL* url = [NSURL URLWithString:
                  [NSString stringWithFormat:
                   @"%@programs/?fields=title,short_description,long_description,"
                   "nola_root,associated_images,categories,shop_url,donate_url,website"
                   "&filter_id__in=%@",
                   coveUrl,
                   idList]];
    
	//NSLog(@"Original COVE url: %@", url); 
	//NSLog(@"  Signed COVE url: %@", signedURL);
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIProgramDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
	
}

- (void) getProgramBySlug:(NSString *)slug withRequestId:(NSString *)requestId 
{
    NSURL* url = [NSURL URLWithString:
                  [NSString stringWithFormat:
                   @"%@programs/?fields=title,short_description,long_description,"
                   "nola_root,associated_images,categories,shop_url,donate_url,website"
                   "&filter_slug=%@",
                   coveUrl,
                   slug]];
    
	//NSLog(@"Original COVE url: %@", url); 
	//NSLog(@"  Signed COVE url: %@", signedURL);
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIProgramDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
	
}


- (void) getEpisodesByMediaIdList:(NSString *)mediaIdList withRequestId:(NSString *)requestId {
    NSURL* url = [NSURL URLWithString:
				  [NSString stringWithFormat:
				   @"%@videos/?fields=title,type,gated_content,short_description,"
				   "long_description,episode_url,tp_media_object_id,nola_episode,nola_root,rating,"
				   "buy_dvd_link,itunes_link,donate_url,availability,available_datetime,expire_datetime,program__title,mediafiles,"
				   "associated_images,airdate,program__associated_images,program__website,"
				   "program__short_description,program__long_description,"
				   "program__nola_root,program__shop_url,"
				   "program__donate_url&filter_tp_media_object_id__in=%@"
                   "&filter_availability_status=Available"
                   "&order_by=-airdate"
                   "&filter_gated_content__in=Not+Gated,Registration+Required"
				   "&filter_mediafile_set__video_encoding__mime_type="
				   "application/x-mpegURL",
				   coveUrl, mediaIdList]];
    
	//NSLog(@"Original COVE url: %@", url); 
	//NSLog(@"  Signed COVE url: %@", signedURL);
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIEpisodeDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];

}

- (void) getEpisodesByGroup:(NSString*) group
              withRequestId:(NSString*)requestId {
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@groups/?format=json&fields=videos__title,videos__type,videos__gated_content,videos__short_description,videos__long_description,videos__episode_url,videos__tp_media_object_id,videos__nola_episode,videos__nola_root,videos__program__title,videos__program__website,videos__availability,videos__available_datetime,videos__expire_datetime,videos__associated_images,videos__rating,videos__buy_dvd_link,videos__itunes_link,videos__donate_url,videos__mediafiles__video_data_url,videos__mediafiles__video_encoding,videos__mediafiles__length_mseconds,videos__program__associated_images,videos__program__short_description,videos__program__long_description,videos__program__nola_root,videos__categories,videos__program__shop_url,videos__program__donate_url,videos__airdate"
                                       "&filter_name=%@&filter_videos__gated_content__in=Not+Gated,Registration+Required",
                                       coveUrl, 
                                       [group stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
	//NSLog(@"Original COVE url: %@", url); 
	//NSLog(@"  Signed COVE url: %@", signedURL);
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIGroupDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
	
}

- (void) getEpisodesByProgramId:(NSString *)programId withRequestId:(NSString*)requestId {
	NSURL* url = [NSURL URLWithString:
				  [NSString stringWithFormat:
				   @"%@videos/?fields=title,type,gated_content,short_description,"
				   "long_description,episode_url,tp_media_object_id,nola_episode,nola_root,rating,"
				   "buy_dvd_link,itunes_link,donate_url,availability,available_datetime,expire_datetime,program__title,mediafiles,"
				   "associated_images,airdate,program__associated_images,program__website,"
				   "program__short_description,program__long_description,"
				   "program__nola_root,program__shop_url,"
				   "program__donate_url&filter_program=%@"
                   "&filter_availability_status=Available"
                   "&order_by=-airdate"
                   "&filter_gated_content__in=Not+Gated,Registration+Required"
				   "&filter_mediafile_set__video_encoding__mime_type="
				   "application/x-mpegURL",
				   coveUrl, programId]];
	//NSLog(@"Original COVE url: %@", url); 
	//NSLog(@"  Signed COVE url: %@", signedURL);
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIEpisodeDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
	
}


- (void) getEpisodesByNolaRoot:(NSString *)nolaRoot withRequestId:(NSString*)requestId {
	NSURL* url = [NSURL URLWithString:
                [NSString stringWithFormat:
                 @"%@videos/?fields=title,type,gated_content,short_description,"
                 "long_description,episode_url,tp_media_object_id,nola_episode,nola_root,rating,"
                 "buy_dvd_link,itunes_link,donate_url,availability,available_datetime,expire_datetime,program__title,mediafiles,"
                 "associated_images,airdate,program__associated_images,program__website,"
                 "program__short_description,program__long_description,"
                 "program__nola_root,program__shop_url,"
                 "program__donate_url&filter_nola_root=%@"
                 "&filter_availability_status=Available"
                 "&order_by=-airdate"
                 "&filter_gated_content__in=Not+Gated,Registration+Required"
                 "&filter_mediafile_set__video_encoding__mime_type="
                 "application/x-mpegURL",
                 coveUrl, nolaRoot]];
	//NSLog(@"Original COVE url: %@", url); 
	//NSLog(@"  Signed COVE url: %@", signedURL);
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIEpisodeDelegate alloc] init];
    apiDelegate.client = self;
	apiDelegate.delegate = delegate;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
	
}

- (void) getEpisodesByNolaRoot:(NSString *)nolaRoot andEpisodeNola:(NSString *)episodeNola withRequestId:(NSString *)requestId {
    NSURL* url = [NSURL URLWithString:
                  [NSString stringWithFormat:
                   @"%@videos/?fields=available_datetime,gated_content,expire_datetime,"
                   "mediafiles,title,short_description,long_description,nola_episode,"
                   "nola_root,buy_dvd_link,itunes_link,tp_media_object_id,associated_images,"
                   "program__title,program__short_description,program__long_description"
                   "&filter_mediafile_set__video_encoding__mime_type=application/x-mpegURL"
                   "&filter_availability_status=Available"
                   "&order_by=-airdate"
                   "&filter_gated_content__in=Not+Gated,Registration+Required"
                   "&filter_nola_root=%@&filter_nola_episode=%@",
                   coveUrl, nolaRoot, episodeNola]];
    
    ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIEpisodeDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
}

- (void) getEpisodesByTPMediaId:(NSString *)tpMediaId withRequestId:(NSString *)requestId {
    NSURL* url = [NSURL URLWithString:
				  [NSString stringWithFormat:
				   @"%@videos/?fields=title,type,gated_content,short_description,"
				   "long_description,episode_url,tp_media_object_id,nola_episode,nola_root,rating,"
				   "buy_dvd_link,itunes_link,donate_url,availability,available_datetime,expire_datetime,program__title,mediafiles,"
				   "associated_images,airdate,program__associated_images,program__website,"
				   "program__short_description,program__long_description,"
				   "program__nola_root,program__shop_url,"
				   "program__donate_url&filter_tp_media_object_id=%@"
                   "&filter_availability_status=Available"
                   "&order_by=-airdate"
                   "&filter_gated_content__in=Not+Gated,Registration+Required"
				   "&filter_mediafile_set__video_encoding__mime_type="
				   "application/x-mpegURL",
                   coveUrl, tpMediaId]];
    
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIEpisodeDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
}

- (void) getEpisodeByResourceURI:(NSString *)resourceURI withRequestId:(NSString*)requestId {
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/?fields=title,type,gated_content,short_description,long_description,episode_url,tp_media_object_id,nola_episode,nola_root,rating,airdate,availability,available_datetime,expire_datetime,buy_dvd_link,itunes_link,donate_url,program__title,mediafiles,program__associated_images,program__website,program__short_description,program__long_description,program__nola_root,program__shop_url,program__donate_url"
                                       "&filter_gated_content__in=Not+Gated,Registration+Required"
                                       ,[coveUrl stringByReplacingOccurrencesOfString:@"/cove/v1/" withString:@""], resourceURI]];
	//NSLog(@"Original COVE url: %@", url); 
	//NSLog(@"  Signed COVE url: %@", signedURL);
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIEpisodeDelegate alloc] init];
	apiDelegate.delegate = delegate;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
	
}

- (void) getProgramByResourceURI:(NSString*) resourceURI withRequestId:(NSString*)requestId {
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/?fields=title,short_description,long_description,nola_root,associated_images,shop_url,donate_url,website",[coveUrl stringByReplacingOccurrencesOfString:@"/cove/v1/" withString:@""], resourceURI]];
	//NSLog(@"Original COVE url: %@", url); 
	//NSLog(@"  Signed COVE url: %@", signedURL);
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIProgramDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];
}

- (void) getSegmentsForEpisode:(COVEEpisode *)episode withRequestId:(NSString *)requestId {
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@videos/?filter_segment_parent=%@&filter_gated_content__in=Not+Gated,Registration+Required",coveUrl, episode.episodeId]];
	//NSLog(@"Original COVE url: %@", url); 
	//NSLog(@"  Signed COVE url: %@", signedURL);
	ASIHTTPRequest *request = [self requestSignedWithURL:url consumerKey:consumerKey secretKey:secretKey];
    [request setCachePolicy:ASIUseDefaultCachePolicy];
	[requests addObject:request];		// Store for cancellation
	BaseCOVEAPIDelegate* apiDelegate = [[COVEAPIEpisodeDelegate alloc] init];
	apiDelegate.delegate = delegate;
    apiDelegate.client = self;
	apiDelegate.requestId = requestId;
	request.delegate = apiDelegate;
    [coveApiDelegates addObject:apiDelegate];
    [apiDelegate release];
    request.numberOfTimesToRetryOnTimeout = 3;
	[request startAsynchronous];

    
}


+ (id) sanitize:(id) value {
	return [COVEClientAPI sanitize:value withDefault:@""];
}

+ (id) sanitize:(id)value withDefault:(id)defaultValue {
	if ((NSNull *)value == [NSNull null] || value == nil) {
		return defaultValue;
	} else {
		return value;
	}
}


- (void) cancelRequests {
	self.delegate = nil;
	for (ASIHTTPRequest* request in requests) {
		request.delegate = nil;
		[request cancel];
	}
}

- (void) dealloc {
	
	[self cancelRequests];
	[requests release];
    [coveApiDelegates release];
	[super dealloc];
}


- (ASIHTTPRequest *) requestSignedWithURL:(NSURL *) url consumerKey:(NSString *) consumerKey secretKey: (NSString *) secretKey 
{
	NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
	NSString * strtimestamp = [NSString stringWithFormat:@"%u", (time_t) timestamp];
	
	NSString * nonce = [[NSProcessInfo processInfo] globallyUniqueString];
	
	NSString * query = [url query];
	NSString * queryWithAddedParams = [query stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
	queryWithAddedParams = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)queryWithAddedParams, NULL, (CFStringRef)@"!*'();:@$,/?%#[]", kCFStringEncodingUTF8 );
	
	NSArray * params = [[queryWithAddedParams componentsSeparatedByString:@"&"] sortedArrayUsingSelector:@selector(compare:)];
	[queryWithAddedParams release];
	NSString * sorted = [params componentsJoinedByString:@"&"];
	
	NSString * cannonical = [[url absoluteString] stringByReplacingOccurrencesOfString:query withString:sorted];
	
	NSString * toBeHashed = [NSString stringWithFormat:@"GET%@%@%@%@", cannonical,strtimestamp,consumerKey,nonce];
	
	const char * utf8String = [toBeHashed UTF8String];
	NSData * data = [NSData dataWithBytes:utf8String length:strlen(utf8String)];
	const char * utf8Key = [secretKey UTF8String];
	NSData * key = [NSData dataWithBytes:utf8Key length:strlen(utf8Key)];
	
	void* buffer = malloc(CC_SHA1_DIGEST_LENGTH);
	CCHmac(kCCHmacAlgSHA1,
		   [key bytes],
		   [key length],
		   [data bytes],
		   [data length],
		   buffer
		   );
	
	NSData * sigData = [NSData dataWithBytesNoCopy:buffer length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
	NSCharacterSet *charsToRemove = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
	NSString *sig = [[[sigData description] stringByTrimmingCharactersInSet:charsToRemove] stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:cannonical]];
	[request addRequestHeader:@"X-PBSAuth-Timestamp" value:strtimestamp];
	[request addRequestHeader:@"X-PBSAuth-Nonce" value:nonce];
	[request addRequestHeader:@"X-PBSAuth-Consumer-Key" value:consumerKey];
	[request addRequestHeader:@"X-PBSAuth-Signature" value:sig];
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	[request setSecondsToCache:CACHE_TIME_JSON];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	
	return request;
}

+ (BOOL)isiPhone4 {
    //We make sure that this method is invoked only once throughout the application lifetime
    if( sIsiPhone4 == -1) {
        if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            sIsiPhone4 = [[UIScreen mainScreen] scale] == 2.0 ;
        }
        else {
            sIsiPhone4 = 0;
        }
    }
    return sIsiPhone4;
}

+ (BOOL)getUserInterfaceIdiom {
    //We make sure that this method is invoked only once throughout the application lifetime
    if(sIsiPad == -1) {
        if([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]) {
            sIsiPad = [[UIDevice currentDevice] userInterfaceIdiom];
        }
    }
    return sIsiPad;
}

+ (void)setUseQAKeys:(BOOL)setting {
    useQAKeys = setting;
}

+ (BOOL)useQAKeys {
    return useQAKeys;
}

@end