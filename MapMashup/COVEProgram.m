//
//  COVEProgram.m
//  PBSiPad
//
//  Created by Robert Rosenburgh on 7/28/10.
//  Copyright 2010 BRE Technology LLC. All rights reserved.
//

#import "COVEProgram.h"
#import "COVEClientAPI.h"

@implementation COVEProgram

@synthesize title;
@synthesize shortDescription;
@synthesize longDescription;
@synthesize nolaRoot;
@synthesize resourceURI;
@synthesize website;
@synthesize imageURL;
@synthesize thumbnailURL;
@synthesize categories;
@synthesize programDictionary;
@synthesize sectionNumber;
@synthesize buyLinks;
@synthesize programId;

+ (COVEProgram*) programWithDictionary: (NSDictionary*) dictionary {
	
	COVEProgram* pgm = [[COVEProgram alloc] init];
	pgm.programDictionary = dictionary;
	pgm.title = [COVEClientAPI sanitize:[dictionary objectForKey:@"title"]];
	pgm.shortDescription = [COVEClientAPI sanitize:[dictionary objectForKey:@"short_description"]];
	pgm.longDescription = [COVEClientAPI sanitize:[dictionary objectForKey:@"long_description"]];
	pgm.nolaRoot = [dictionary objectForKey:@"nola_root"];
	pgm.resourceURI = [COVEProgram programURIFromDictionary:dictionary];
	pgm.website = [COVEClientAPI sanitize:[dictionary objectForKey:@"website"] withDefault:nil];	// Make the check cleaner when sharing episode URL
	pgm.imageURL = @"";
    pgm.thumbnailURL = @"";
    
	NSMutableDictionary *consBuyLinks = [NSMutableDictionary dictionary];
	
	 if((NSNull *)[dictionary objectForKey:@"shop_url"] != [NSNull null] && ![[dictionary objectForKey:@"shop_url"] isEqual:@""])
		[consBuyLinks setObject:[dictionary objectForKey:@"shop_url"] forKey:@"Visit the program shop"];
    
	pgm.buyLinks = consBuyLinks;
  
    NSMutableDictionary * urlByUsage = [NSMutableDictionary dictionaryWithCapacity:1];
	for (NSDictionary* image in [dictionary objectForKey:@"associated_images"]) {
		NSString* url = [image objectForKey:@"url"];
		url = [url stringByReplacingOccurrencesOfString:@";" withString:@""];
        
		NSDictionary* type = [image objectForKey:@"type"];
        NSString * usageType = [type objectForKey:@"usage_type"];
        [urlByUsage setObject:url forKey:usageType];
	}

    if (DEVICE_IS_IPAD) {
        if ([urlByUsage objectForKey:@"iPad-Large"] != nil) {
            pgm.imageURL = [urlByUsage objectForKey:@"iPad-Large"];
        } else if ([urlByUsage objectForKey:@"iPhone-Medium"] != nil) {
            pgm.imageURL = [urlByUsage objectForKey:@"iPhone-Medium"];
        } else if ([urlByUsage objectForKey:@"iPad-Small"] != nil) {
            pgm.imageURL = [urlByUsage objectForKey:@"iPad-Small"];
        }
        
        if ([urlByUsage objectForKey:@"iPhone-Medium"] != nil) {
            pgm.thumbnailURL = [urlByUsage objectForKey:@"iPhone-Medium"];
        } else if ([urlByUsage objectForKey:@"iPad-Small"] != nil) {
            pgm.thumbnailURL = [urlByUsage objectForKey:@"iPad-Small"];
        } else if ([urlByUsage objectForKey:@"iPhone-Small"] != nil) {
            pgm.thumbnailURL = [urlByUsage objectForKey:@"iPhone-Small"];
        }
    }
    else {
        if (DEVICE_IS_IPHONE4) {
            if ([urlByUsage objectForKey:@"iPhone-Medium"] != nil) {
                pgm.imageURL = [urlByUsage objectForKey:@"iPhone-Medium"];
            } else if ([urlByUsage objectForKey:@"iPad-Small"] != nil) {
                pgm.imageURL = [urlByUsage objectForKey:@"iPad-Small"];
            } else if ([urlByUsage objectForKey:@"iPhone-Small"] != nil) {
                pgm.imageURL = [urlByUsage objectForKey:@"iPhone-Small"];
            }
            
            if ([urlByUsage objectForKey:@"iPad-Large"] != nil) {
                pgm.thumbnailURL = [urlByUsage objectForKey:@"iPad-Large"];
            } else if ([urlByUsage objectForKey:@"iPhone-Medium"] != nil) {
                pgm.thumbnailURL = [urlByUsage objectForKey:@"iPhone-Medium"];
            } else if ([urlByUsage objectForKey:@"iPad-Small"] != nil) {
                pgm.thumbnailURL = [urlByUsage objectForKey:@"iPad-Small"];
            }
        } else {
            if ([urlByUsage objectForKey:@"iPhone-Small"] != nil) {
                pgm.imageURL = [urlByUsage objectForKey:@"iPhone-Small"];
            } else if ([urlByUsage objectForKey:@"iPad-Small"] != nil) {
                pgm.imageURL = [urlByUsage objectForKey:@"iPad-Small"];
            } else if ([urlByUsage objectForKey:@"iPhone-Medium"] != nil) {
                pgm.imageURL = [urlByUsage objectForKey:@"iPhone-Medium"];
            }
            
            if ([urlByUsage objectForKey:@"iPhone-Medium"] != nil) {
                pgm.thumbnailURL = [urlByUsage objectForKey:@"iPhone-Medium"];
            } else if ([urlByUsage objectForKey:@"iPad-Small"] != nil) {
                pgm.thumbnailURL = [urlByUsage objectForKey:@"iPad-Small"];
            } else if ([urlByUsage objectForKey:@"iPhone-Small"] != nil) {
                pgm.thumbnailURL = [urlByUsage objectForKey:@"iPhone-Small"];
            }
        }
    }
    
	// get program id from the resource_uri property
	NSArray *segments = [[dictionary objectForKey:@"resource_uri"] componentsSeparatedByString:@"/"];
	if([segments count] == 6) {
		pgm.programId = [segments objectAtIndex:4];
	} else {
//		DebugLog(@"Program resource_uri invalid");
	}
	
	pgm.categories = [dictionary objectForKey:@"categories"];
	return [pgm autorelease];
}

+ (NSString *) programURIFromDictionary: (NSDictionary*) dictionary {
	return [dictionary objectForKey:@"resource_uri"];
}

- (NSComparisonResult)compare:(COVEProgram *)p {
    return [self.title compare:p.title];
}

- (BOOL)isEqual:(id)anObject {
  //We're defining equality of programs here based on the program resourceURI
  if ([anObject isKindOfClass:[self class]]==NO) {
    return NO;
  }
  return [self.resourceURI isEqualToString:[(COVEProgram*)anObject resourceURI]];
}

- (NSUInteger)hash {
  return [self.resourceURI hash];
}

-(NSString*) description {
	//For now just return the title
	return self.title;
}

- (void)dealloc
{
	self.title = nil;
	self.shortDescription = nil;
	self.longDescription = nil;
	self.nolaRoot = nil;
	self.programId = nil;
	self.resourceURI = nil;
	self.imageURL = nil;
	self.thumbnailURL = nil;
	self.categories = nil;
	self.programDictionary = nil;
	self.buyLinks = nil;
	self.website = nil;
	
	
	[super dealloc];
}

@end
