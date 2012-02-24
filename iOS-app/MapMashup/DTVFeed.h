//
//  DTVFeed.h
//  PBSiPad
//
//  Created by Matthew Norton on 8/1/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DTVFeed : NSObject<NSCoding> {
	
	NSString * feedCommonName; // WETA Kids
	NSNumber * feedID; // 12435
	NSString * feedName; // WETADT3
	
	// fields for feedsByStation (WETA)
	BOOL otaVisible; // Y
    NSString * parentTvdataName; // WETA	
	
	// fields for feedsByHeadend (WETA, 321927)
	NSString * cableChannel; // 0026
	NSNumber * stationID; // 12435
	
	NSString* callLetters;
}

@property(nonatomic,copy)NSString *feedCommonName;
@property(nonatomic,copy)NSNumber *feedID;
@property(nonatomic,copy)NSString *feedName;

@property BOOL otaVisible;
@property(nonatomic,copy)NSString *parentTvdataName;

@property(nonatomic,copy)NSString *cableChannel;
@property(nonatomic,copy)NSNumber *stationID;
@property(nonatomic,copy)NSString* callLetters;


+ (DTVFeed*) feedWithStationDictionary: (NSDictionary*) dictionary;
+ (DTVFeed*) feedWithHeadendDictionary: (NSDictionary*) dictionary;
+ (DTVFeed*) feedWithMetadataDictionary: (NSDictionary*) dictionary;
+ (NSDictionary*) validate:(NSDictionary *) dictionary;

@end
