//
//  DTVAirdate.h
//  PBSiPad
//
//  Created by Matthew Norton on 8/6/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DTVAirdate : NSObject {
	NSString* title;
	NSString* episodeTitle;
	NSString* short_description;
	NSString* description;
	NSString* channel;
	NSNumber* duration;
	NSString* nolaRoot;
	NSString* nolaEpisode;
	NSNumber* feedID;
	NSDate* startTime;
	NSDate* endTime;
	BOOL live;
	BOOL cc;
	NSString* tvRating;
	NSString* feedCommonName;
	NSNumber* vendorRefNumber;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *episodeTitle;
@property (nonatomic, copy) NSString *short_description;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSNumber *duration;
@property (nonatomic, copy) NSString *nolaRoot;
@property (nonatomic, copy) NSString *nolaEpisode;
@property (nonatomic, copy) NSNumber *feedID;
@property (nonatomic, copy) NSDate *startTime;
@property (nonatomic, copy) NSDate *endTime;
@property (nonatomic, assign) BOOL live;
@property (nonatomic, assign) BOOL cc;
@property (nonatomic, copy) NSString *tvRating;
@property (nonatomic, copy) NSString *feedCommonName;
@property (nonatomic, copy) NSNumber *vendorRefNumber;

+ (DTVAirdate*) airdateWithDictionary:(NSDictionary*)dictionary;
+ (NSDictionary*) validate:(NSDictionary *) dictionary;

/*
{
"live_yn":"R",
"cc_yn":"Y",
"tv_rating":"TVG",
"title30":"Antiques Roadshow",
"joined_in_prog_yn":"N",
"tg_title":"Antiques Roadshow",
"feed_id":167,
"season_prem_finale":"",
"hdtv_level":"",
"duration":"0100",
"cable_channel":"0026",
"bw_yn":"N",
"total_parts":3,
"animated_yn":"N",
"episode_title":"Orlando, Florida",
"feed_name":"WETA",
"vendor_ref_number":7412092,
"cable_in_class_yn":"Y",
"tg_episode_title":"Orlando, Florida",
"repeat_yn":"R",
"parent_program_id":899704,
"stereo_yn":"Y",
"nola_code_2":1204,
"nola_code_3":0,
"nola_code_1":"ANRO",
"program_id":null,
"channel_id_ref":167,
"series_id":null,
"full_title":"Antiques Roadshow",
"letterbox_yn":"N",
"description2":"Part 1 of 3 from Orlando. Items include a Tiffany vase, a collection of etchings.",
"subtitled_yn":"N",
"alternate_title":"Antiques Roadshow",
"description1":"Part 1 of 3 from Orlando. Items include a Tiffany vase.",
"genre":"part info in copy,hobbies & crafts,collectibles",      "call_letters":"WETA",
"episode_id":null,
"medium_title":"Antiques Roadshow",
"pbs_end_time":"2010-06-01T01:00:00",
"hdtv_yn":"N",
"pods_ed_rights":"1 year",
"tg_description":"Part 1 of 3 from Orlando. Items include a sterling silver Tiffany vase, a collection of etchings by James McNeill Whistler, and a photograph 
signed by the cast of the television series \"Bonanza.\"",
"short_title":"Antiques",
"channel_number":"0026",
"part_number":1,
"pods_tconnex":1,      "title15":"Antiques Rdshow",
"is_series":null,
"feed_common_name":"WETA",
"tg_short_description":"Part 1 of 3 from Orlando. Items include a Tiffany vase.",
"title_id":164,
"pbs_start_time":"2010-06-01T00:00:00",
"description3":"Part 1 of 3 from Orlando. Items include a sterling silver Tiffany vase, a collection of etchings by James McNeill Whistler, and a photograph si
gned by the cast of the television series \"Bonanza.\""
}
 */

@end
