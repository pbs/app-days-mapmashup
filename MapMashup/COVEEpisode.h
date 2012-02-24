//
//  COVEEpisode.h
//  PBSiPad
//
//  Created by Robert Rosenburgh on 7/30/10.
//  Copyright 2010 BRE Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COVEProgram.h"


static const NSInteger kGatedContentNotGated = 0;
static const NSInteger kGatedContentRegistrationRequired = 1;

@interface COVEEpisode : NSObject {
	
    NSString* title;
	NSString* shortDescription;
	NSString* longDescription;
	NSString* nolaEpisode;
	NSString* nolaRoot;
	NSString* resourceURI;
	NSString* episodeURL;
	NSString* imageURL;
	NSString* thumbnailURL;
	NSString* videoDataURL;
	COVEProgram* program;
	NSDictionary* episodeDictionary;
	NSNumber* seekTime;
	NSDate* lastWatched;
	NSString* videoType;
	NSDictionary* buyLinks;
	NSNumber* duration;
	NSDate* airdate;
	NSNumber* mediaID;
	NSDate* expires;
    NSString *episodeId;
    BOOL isSegment;
    NSString *segmentParent; // id of the parent video
    NSNumber *segmentStartTime; // these are only present on segment videos 
    NSNumber *segmentEndTime; // these are only present on segment videos 
    NSArray *segments; // this will contain multiple COVEEpisode instances that will have segmentStart and segmentEnd properties populated
    NSNumber *gatedContent;
}

+ (COVEEpisode*) episodeWithDictionary: (NSDictionary*) dictionary;
+ (NSString *) episodeURIFromDictionary: (NSDictionary*) dictionary;
+ (void) addSeekTime:(NSInteger)seekTime ToDictionary:(NSDictionary*) dictionary;

@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* shortDescription;
@property (copy, nonatomic) NSString* longDescription;
@property (copy, nonatomic) NSString* nolaEpisode;
@property (copy, nonatomic) NSString* nolaRoot;
@property (copy, nonatomic) NSString* resourceURI;
@property (copy, nonatomic) NSString* episodeURL;
@property (copy, nonatomic) NSString* imageURL;
@property (copy, nonatomic) NSString* thumbnailURL;
@property (copy, nonatomic) NSString* videoDataURL;
@property (retain, nonatomic) COVEProgram* program;
@property (retain, nonatomic) NSDictionary *episodeDictionary;
@property (retain, nonatomic) NSNumber *seekTime;
@property (retain, nonatomic) NSDate *lastWatched;
@property (copy, nonatomic) NSString *videoType;
@property (retain, nonatomic) NSDictionary *buyLinks;
@property (copy,nonatomic) NSNumber *duration;
@property (copy,nonatomic) NSDate *airdate;
@property (copy,nonatomic) NSNumber *mediaID;
@property (copy, nonatomic) NSDate *expires;
@property (nonatomic) BOOL isSegment;
@property (copy, nonatomic) NSString *episodeId;
@property (copy, nonatomic) NSNumber *segmentStartTime;
@property (copy, nonatomic) NSNumber *segmentEndTime;
@property (copy, nonatomic) NSArray *segments;
@property (copy, nonatomic) NSString *segmentParent;
@property (copy, nonatomic) NSNumber *gatedContent;

- (NSString*)episodeLink;
- (BOOL)expiresInNumberOfDays:(int)numberOfDays;

@end
