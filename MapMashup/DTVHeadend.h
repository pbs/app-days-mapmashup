//
//  DTVHeadend.h
//  PBSiPad
//
//  Created by Matthew Norton on 8/1/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DTVHeadend : NSObject <NSCoding> {
	NSString * dmaCode; // 511
	NSNumber * dmaRank; // 9
	NSNumber * headendID; // 22331
	NSString * headendName; // Comcast - Montgomery County
	NSString * headendType; // cable
	NSNumber * msoID; // 301719
	NSString * msoName; // Comcast Cable Communications
	NSString * obsDst; // Y
}

@property(nonatomic,copy)NSString *dmaCode;
@property(nonatomic,copy)NSNumber *dmaRank;
@property(nonatomic,copy)NSNumber *headendID;
@property(nonatomic,copy)NSString *headendName;
@property(nonatomic,copy)NSString *headendType;
@property(nonatomic,copy)NSNumber *msoID;
@property(nonatomic,copy)NSString *msoName;
@property(nonatomic,copy)NSString *obsDst;

+ (DTVHeadend*) headendWithDictionary: (NSDictionary*) dictionary;
+ (DTVHeadend*) OTAHeadend;
+ (NSDictionary*) validate:(NSDictionary *) dictionary;

	
@end
