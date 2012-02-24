//
//  DTVHeadend.m
//  PBSiPad
//
//  Created by Matthew Norton on 8/1/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "DTVHeadend.h"


@implementation DTVHeadend

@synthesize dmaCode;
@synthesize dmaRank;
@synthesize headendID;
@synthesize headendName;
@synthesize headendType;
@synthesize msoID;
@synthesize msoName;
@synthesize obsDst;


+ (DTVHeadend*) headendWithDictionary: (NSDictionary*) dictionary {
	
	dictionary = [self validate:dictionary];
	if(dictionary == nil) return nil;
	
	DTVHeadend* headend = [[DTVHeadend alloc] init];
	
	headend.dmaCode = [dictionary objectForKey:@"dma_code"];	
	headend.dmaRank = [dictionary objectForKey:@"dma_rank"];
	headend.headendID = [dictionary objectForKey:@"headend_id"];
	headend.headendName = [dictionary objectForKey:@"headend_name"];
	headend.headendType = [dictionary objectForKey:@"headend_type"];
	headend.msoID = [dictionary objectForKey:@"mso_id"];
	headend.msoName = [dictionary objectForKey:@"mso_name"];
	headend.obsDst = [dictionary objectForKey:@"obs_dst"];
	
	return [headend autorelease];
}

+ (DTVHeadend*) OTAHeadend {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setValue:[NSNumber numberWithInt:0] forKey:@"headend_id"];
	[dictionary setValue:@"Over the Air" forKey:@"headend_name"];
    [dictionary setValue:@"Over the Air" forKey:@"headend_type"];
	
	return [DTVHeadend headendWithDictionary:dictionary];
}

// Validates headend data, returning nil if the data is unusable
// Also sets default values for fields if not defined
+ (NSDictionary*) validate: (NSDictionary*) dictionary {
	NSMutableDictionary *mDictionary = [dictionary mutableCopy];
	
	// We cannot work with a station that has no tv data name
	if( (NSNull *)[mDictionary objectForKey:@"headend_id"] == [NSNull null] ) {
		[mDictionary release];
		return nil;
	}
	
	// We can't allow the headend name to be null, if the headend name is null, attempt to use the
	// MSO name, otherwise fail
	if( (NSNull *)[mDictionary objectForKey:@"headend_name"] == [NSNull null] ) {
		if( (NSNull *)[mDictionary objectForKey:@"mso_name"] != [NSNull null] ) {
			
			[mDictionary setValue:[mDictionary objectForKey:@"mso_name"] forKey:@"headend_name"];
		
		} else {
		
			[mDictionary release];
			return nil;
			
		}
	}
	
	return [mDictionary autorelease];
}

- (NSComparisonResult)compare:(DTVHeadend *)h {
    return [self.headendName compare:h.headendName];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.dmaCode forKey:@"DmaCode"];
	[aCoder encodeObject:self.dmaRank forKey:@"DmaRank"];
	[aCoder encodeObject:self.headendID forKey:@"HeadendID"];
	[aCoder encodeObject:self.headendName forKey:@"HeadendName"];
	[aCoder encodeObject:self.headendType forKey:@"HeadendType"];
	[aCoder encodeObject:self.msoID forKey:@"MsoID"];
	[aCoder encodeObject:self.msoName forKey:@"MsoName"];
	[aCoder encodeObject:self.obsDst forKey:@"ObsDst"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self.dmaCode = [aDecoder decodeObjectForKey:@"DmaCode"];
	self.dmaRank = [aDecoder decodeObjectForKey:@"DmaRank"];
	self.headendID = [aDecoder decodeObjectForKey:@"HeadendID"];
	self.headendName = [aDecoder decodeObjectForKey:@"HeadendName"];
	self.headendType = [aDecoder decodeObjectForKey:@"HeadendType"];
	self.msoID = [aDecoder decodeObjectForKey:@"MsoID"];
	self.msoName = [aDecoder decodeObjectForKey:@"MsoName"];
	self.obsDst = [aDecoder decodeObjectForKey:@"ObsDst"];
	return self;
}

- (void)dealloc
{
	[dmaCode release];
	[dmaRank release];
	[headendID release];
	[headendName release];
	[headendType release];
	[msoID release];
	[msoName release];
	[obsDst release];
	
	[super dealloc];
}

@end
