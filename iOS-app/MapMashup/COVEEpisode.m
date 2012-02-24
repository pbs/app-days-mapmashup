//
//  COVEEpisode.m
//  PBSiPad
//
//  Created by Robert Rosenburgh on 7/30/10.
//  Copyright 2010 BRE Technology LLC. All rights reserved.
//

#import "COVEEpisode.h"
#import "COVEClientAPI.h"

@implementation COVEEpisode

@synthesize title;
@synthesize shortDescription;
@synthesize longDescription;
@synthesize nolaEpisode;
@synthesize nolaRoot;
@synthesize resourceURI;
@synthesize episodeURL;
@synthesize imageURL;
@synthesize thumbnailURL;
@synthesize videoDataURL;
@synthesize program;
@synthesize episodeDictionary;
@synthesize seekTime,lastWatched;
@synthesize videoType;
@synthesize buyLinks;
@synthesize duration;
@synthesize airdate;
@synthesize mediaID;
@synthesize expires;
@synthesize isSegment;
@synthesize episodeId;
@synthesize segmentParent;
@synthesize segmentEndTime;
@synthesize segmentStartTime;
@synthesize segments;
@synthesize gatedContent;

+ (COVEEpisode*) episodeWithDictionary: (NSDictionary*) dictionary {
	
	if ([[dictionary objectForKey:@"availability"] isEqual:@"Expired"]) return nil;
	
	COVEEpisode* ep = [[COVEEpisode alloc] init];
	ep.episodeDictionary = dictionary;
	ep.seekTime = [dictionary objectForKey:@"seek_time"];
	ep.lastWatched = [dictionary objectForKey:@"last_watched"];
	
	ep.title = [dictionary objectForKey:@"title"];
	ep.shortDescription = [COVEClientAPI sanitize:[dictionary objectForKey:@"short_description"]];
	ep.longDescription = [COVEClientAPI sanitize:[dictionary objectForKey:@"long_description"]];
	ep.resourceURI = [COVEEpisode episodeURIFromDictionary:dictionary];
	ep.episodeURL = [COVEClientAPI sanitize:[dictionary objectForKey:@"episode_url"] withDefault:nil];	// Make the check cleaner when sharing episode URL
	ep.mediaID = [COVEClientAPI sanitize:[dictionary objectForKey:@"tp_media_object_id"]];

    ep.nolaEpisode = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"nola_episode"] intValue]];
	ep.nolaRoot = [dictionary objectForKey:@"nola_root"];
	ep.videoType = [COVEClientAPI sanitize:[dictionary objectForKey:@"type"] withDefault:@"Clip"];
    
    if([dictionary objectForKey:@"gated_content"]) {
		ep.gatedContent = [NSNumber numberWithInt:[[dictionary objectForKey:@"gated_content"] intValue]];
    }
    else {
        // Default to "Not Gated" if field is not returned by the API
        ep.gatedContent = [NSNumber numberWithInteger:kGatedContentNotGated];
    }

    // get episode id from the resource_uri property
	NSArray *segments = [[dictionary objectForKey:@"resource_uri"] componentsSeparatedByString:@"/"];
	if([segments count] == 6) {
		ep.episodeId = [segments objectAtIndex:4];
	} else {
//		DebugLog(@"Episode resource_uri invalid");
	}
    
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];		// This deals with the timezone difference
	
	if([dictionary objectForKey:@"airdate"])
		ep.airdate = [dateFormatter dateFromString:[dictionary objectForKey:@"airdate"]];
	
	
	if([dictionary objectForKey:@"expire_datetime"])
		ep.expires = [dateFormatter dateFromString:[dictionary objectForKey:@"expire_datetime"]];
	
	NSMutableDictionary *consBuyLinks = [NSMutableDictionary dictionaryWithCapacity:0];
	if((NSNull *)[dictionary objectForKey:@"itunes_link"] != [NSNull null] && ![[dictionary objectForKey:@"itunes_link"] isEqual:@""] && [dictionary objectForKey:@"itunes_link"] != nil)
		[consBuyLinks setObject:[dictionary objectForKey:@"itunes_link"] forKey:@"Buy this video on iTunes"];
	
    if((NSNull *)[dictionary objectForKey:@"buy_dvd_link"] != [NSNull null] && ![[dictionary objectForKey:@"buy_dvd_link"] isEqual:@""])
        [consBuyLinks setObject:[dictionary objectForKey:@"buy_dvd_link"] forKey:@"Buy this video on DVD"];
	
	ep.buyLinks = consBuyLinks;
    
    ep.isSegment = [[dictionary objectForKey:@"is_segment"] boolValue];
    
    if(ep.isSegment) {
        ep.segmentStartTime = [NSNumber numberWithInt:[[dictionary objectForKey:@"segment_start_time"] intValue] / 1000];
        ep.segmentEndTime = [NSNumber numberWithInt:[[dictionary objectForKey:@"segment_end_time"] intValue] / 1000];
    }
    
    
    
    NSMutableDictionary * urlByUsage = [NSMutableDictionary dictionaryWithCapacity:1];
	for (NSDictionary* image in [dictionary objectForKey:@"associated_images"]) {
		NSString* url = [image objectForKey:@"url"];
		NSDictionary* type = [image objectForKey:@"type"];
        NSString * usageType = [type objectForKey:@"usage_type"];
        [urlByUsage setObject:url forKey:usageType];
	}
    
    if (DEVICE_IS_IPAD) {
        if ([urlByUsage objectForKey:@"iPad-Large"] != nil) {
            ep.imageURL = [urlByUsage objectForKey:@"iPad-Large"];
        } else if ([urlByUsage objectForKey:@"iPhone-Medium"] != nil) {
            ep.imageURL = [urlByUsage objectForKey:@"iPhone-Medium"];
        } else if ([urlByUsage objectForKey:@"iPad-Small"] != nil) {
            ep.imageURL = [urlByUsage objectForKey:@"iPad-Small"];
        }
        
        if ([urlByUsage objectForKey:@"iPhone-Medium"] != nil) {
            ep.thumbnailURL = [urlByUsage objectForKey:@"iPhone-Medium"];
        } else if ([urlByUsage objectForKey:@"iPad-Small"] != nil) {
            ep.thumbnailURL = [urlByUsage objectForKey:@"iPad-Small"];
        } else if ([urlByUsage objectForKey:@"iPhone-Small"] != nil) {
            ep.thumbnailURL = [urlByUsage objectForKey:@"iPhone-Small"];
        }
    }
    else {
        if (DEVICE_IS_IPHONE4) {
            if ([urlByUsage objectForKey:@"iPhone-Medium"] != nil) {
                ep.imageURL = [urlByUsage objectForKey:@"iPhone-Medium"];
            } else if ([urlByUsage objectForKey:@"iPad-Small"] != nil) {
                ep.imageURL = [urlByUsage objectForKey:@"iPad-Small"];
            } else if ([urlByUsage objectForKey:@"iPhone-Small"] != nil) {
                ep.imageURL = [urlByUsage objectForKey:@"iPhone-Small"];
            }
            
            if ([urlByUsage objectForKey:@"iPad-Large"] != nil) {
                ep.thumbnailURL = [urlByUsage objectForKey:@"iPad-Large"];
            } else if ([urlByUsage objectForKey:@"iPhone-Medium"] != nil) {
                ep.thumbnailURL = [urlByUsage objectForKey:@"iPhone-Medium"];
            } else if ([urlByUsage objectForKey:@"iPad-Small"] != nil) {
                ep.thumbnailURL = [urlByUsage objectForKey:@"iPad-Small"];
            }
        } else {
            if ([urlByUsage objectForKey:@"iPhone-Small"] != nil) {
                ep.imageURL = [urlByUsage objectForKey:@"iPhone-Small"];
            } else if ([urlByUsage objectForKey:@"iPad-Small"] != nil) {
                ep.imageURL = [urlByUsage objectForKey:@"iPad-Small"];
            } else if ([urlByUsage objectForKey:@"iPhone-Medium"] != nil) {
                ep.imageURL = [urlByUsage objectForKey:@"iPhone-Medium"];
            }
            
            if ([urlByUsage objectForKey:@"iPhone-Medium"] != nil) {
                ep.thumbnailURL = [urlByUsage objectForKey:@"iPhone-Medium"];
            } else if ([urlByUsage objectForKey:@"iPad-Small"] != nil) {
                ep.thumbnailURL = [urlByUsage objectForKey:@"iPad-Small"];
            } else if ([urlByUsage objectForKey:@"iPhone-Small"] != nil) {
                ep.thumbnailURL = [urlByUsage objectForKey:@"iPhone-Small"];
            }
        }    
    }
    
	//NSLog(@"mediafiles: %@", [dictionary objectForKey:@"mediafiles"]);
	
	for (NSDictionary* mediafile in [dictionary objectForKey:@"mediafiles"]) {
		NSDictionary* type = [mediafile objectForKey:@"video_encoding"];
		NSNumber* mimeType = [type objectForKey:@"mime_type"];
		
		if ([mimeType isEqual:@"application/x-mpegURL"]) {
			NSString* url = [mediafile objectForKey:@"video_data_url"];
			NSString* encodingName = [type objectForKey:@"name"];
			
            if (DEVICE_IS_IPAD) {
                if ([encodingName isEqualToString:@"iPad-16x9"]) {
                    ep.videoDataURL = url;
                    ep.duration = [NSNumber numberWithInt:[[mediafile objectForKey:@"length_mseconds"] intValue] / 1000];
                    break;
                }
                else if ((ep.videoDataURL == nil) ||
                         ([encodingName isEqualToString:@"iPad-4x3"]) ||
                         (![ep.videoDataURL isEqualToString:@"iPad-4x3"] && [encodingName isEqualToString:@"iPhone-16x9"])) {
                    ep.videoDataURL = url;
                    ep.duration = [NSNumber numberWithInt:[[mediafile objectForKey:@"length_mseconds"] intValue] / 1000];
                }
            }
            else {
                if ([encodingName isEqualToString:@"iPhone-16x9"]) {
                    ep.videoDataURL = url;
                    ep.duration = [NSNumber numberWithInt:[[mediafile objectForKey:@"length_mseconds"] intValue] / 1000];
                    break;
                }
                else if ((ep.videoDataURL == nil) ||
                         ([encodingName isEqualToString:@"iPad-4x3"]) ||
                         (![ep.videoDataURL isEqualToString:@"iPad-4x3"] && [encodingName isEqualToString:@"iPad-16x9"])) {
                    ep.videoDataURL = url;
                    ep.duration = [NSNumber numberWithInt:[[mediafile objectForKey:@"length_mseconds"] intValue] / 1000];
                }
            }
		}
	}
	
	if (!ep.isSegment && (ep.videoDataURL == nil || ep.videoDataURL.length == 0)) {
        [ep release];
		return nil;
	} else {
        if (DEVICE_IS_IPAD) {
            ep.videoDataURL = [NSString stringWithFormat:@"%@&player=iPad-%@", ep.videoDataURL, [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
        } else {
            ep.videoDataURL = [NSString stringWithFormat:@"%@&player=iPhone-%@", ep.videoDataURL, [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
        }		
	}
	
    if(!ep.isSegment) 
        ep.program = [COVEProgram programWithDictionary:[dictionary objectForKey:@"program"]];
	
	return [ep autorelease];
}
	
+ (NSString *) episodeURIFromDictionary: (NSDictionary*) dictionary {
	return [dictionary objectForKey:@"resource_uri"];
}

+ (void) addSeekTime:(NSInteger)seekTime ToDictionary:(NSDictionary*) dictionary {
	[dictionary setValue:[NSNumber numberWithInt:seekTime] forKey:@"seek_time"];
	[dictionary setValue:[NSDate date] forKey:@"last_watched"];
}

-(NSString*)description {
	return [NSString stringWithFormat:@"%@: COVEEpisode entitled %@ \"%@\" with seekTime %d",[super description],self.program,self.title,self.seekTime];
}

- (NSComparisonResult) compareProgramTitle:(COVEEpisode*) episode {
	return [self.program.title caseInsensitiveCompare:episode.program.title];
}

- (NSComparisonResult) compareAirdateDesc:(COVEEpisode*) episode {
	NSComparisonResult compare = [self.airdate compare:episode.airdate];
	if(compare == NSOrderedDescending) return NSOrderedAscending;
	else if(compare == NSOrderedAscending) return NSOrderedDescending;
	else return NSOrderedSame;
}

- (NSString*) episodeLink {
	return [NSString stringWithFormat:@"http://video.pbs.org/video/%@",mediaID];
}

- (BOOL)expiresInNumberOfDays:(int)numberOfDays {
    
    if (self.expires != nil) {
        double timeInterval = [self.expires timeIntervalSinceNow];
        
        if (round(timeInterval / (numberOfDays * 24 * 3600)) <= 1) {
            return YES;
        }
    }
    return NO;
}

- (void)dealloc {
	self.title = nil;
	self.shortDescription = nil;
	self.longDescription = nil;
	self.nolaEpisode = nil;
	self.nolaRoot = nil;
    self.episodeId = nil;
	self.resourceURI = nil;
	self.imageURL = nil;
	self.thumbnailURL = nil;
	self.program = nil;
	self.episodeURL = nil;
	self.buyLinks = nil;
	self.duration = nil;
	self.airdate = nil;
	self.episodeDictionary = nil;
	self.seekTime = nil;
	self.videoDataURL = nil;
	self.lastWatched = nil;
	self.videoType = nil;
	self.expires = nil;
    self.mediaID = nil;
    self.segments = nil;
    self.segmentStartTime = nil;
    self.segmentEndTime = nil;
    self.segmentParent = nil;
    self.gatedContent = nil;
	[super dealloc];
}

@end
