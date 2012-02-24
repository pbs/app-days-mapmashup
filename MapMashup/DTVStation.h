//
//  DTVStation.h
//  PBSiPad
//
//  Created by Matthew Norton on 8/1/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DTVStation : NSObject <NSCoding> {
	NSString * commonName; // WETA Television
    NSString * city; // Arlington
    NSString * state; // VA
    NSString * rank; // 1623
    NSString * tvdataName; // WETA
	
	NSNumber * stationID;
	
	NSMutableArray *feeds;
}

@property(nonatomic,copy)NSString *commonName;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *rank;
@property(nonatomic,copy)NSString *tvdataName;
@property(nonatomic,copy)NSNumber *stationID;
@property(nonatomic,retain) NSMutableArray *feeds;

+ (DTVStation*) stationWithDictionary: (NSDictionary*) dictionary;
+ (NSDictionary*) validate:(NSDictionary *) dictionary;

@end
