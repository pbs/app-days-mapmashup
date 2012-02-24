//
//  CommonDefines.h
//  pbs
//
//  Created by Dan Damian on 5/26/11.
//  Copyright 2011 Three Pillar Global. All rights reserved.
//

//user defaults
#define DEFAULTS_ZIP_CODES @"ZipCodes"
#define DEFAULTS_HEADENDID @"HeadendID"
#define DEFAULTS_STATION_NAME @"StationName"
#define DEFAULTS_CHANNEL @"Channel"
#define DEFAULTS_FEEDID @"FeedID"


//gan events
#define GAN_EVENT_CATEGORY_SCHEDULE @"schedule"
#define GAN_EVENT_CATEGORY_FAVORITES @"favorites"
#define GAN_EVENT_SCHEDULE_SELECT_PROVIDER @"select_provider"
#define GAN_EVENT_SCHEDULE_SELECT_STATION @"select_station"
#define GAN_EVENT_SCHEDULE_SELECT_CHANNEL @"select_channel"
#define GAN_EVENT_FAVORITES_ADD_FAVORITE_EPISODE @"add_favorite_episode"
#define GAN_EVENT_FAVORITES_REMOVE_FAVORITE_EPISODE @"remove_favorite_episode"
#define GAN_EVENT_FAVORITES_ADD_FAVORITE_PROGRAM @"add_favorite_program"
#define GAN_EVENT_FAVORITES_REMOVE_FAVORITE_PROGRAM @"remove_favorite_program"

// video playback events
#define GAN_EVENT_CATEGORY_VIDEO_PLAYBACK @"video_playback"
#define GAN_EVENT_VIDEO_SCRUB_BWD @"scrub_backward"
#define GAN_EVENT_VIDEO_SCRUB_FWD @"scrub_forward"
#define GAN_EVENT_VIDEO_PLAY_COMPLETE @"playback_complete"
#define GAN_EVENT_VIDEO_MEDIA_TYPE_CHANGE @"media_type_change"
#define GAN_EVENT_VIDEO_FULLSCREEN @"fullscreen"
#define GAN_EVENT_VIDEO_LOAD_STALLED @"playback_stalled"
#define GAN_EVENT_VIDEO_LOAD_PLAYABLE @"playback_playable"

#define GAN_EVENT_VIDEO_AD_PLAY @"playback_ad_play"
#define GAN_EVENT_VIDEO_AD_CLOSE @"playback_ad_close"
#define GAN_EVENT_VIDEO_AD_VAST_ERROR @"playback_ad_vast_error"
#define GAN_EVENT_VIDEO_AD_PLAY_ERROR @"playback_ad_play_error"

// system events
#define GAN_EVENT_CATEGORY_SYSTEM @"system"
#define GAN_EVENT_PUSH_NOTIFICATION_REGISTER @"push_notification_register"
#define GAN_EVENT_REQUEST_FAILED @"system_request_failed"
#define GAN_EVENT_REACHABILITY_DOWN @"system_reachability_down"
#define GAN_EVENT_APP_UPDATE_REQUIRED @"app_update_required"

//request failed notification
#define COVE_API @"cove_api"
#define MERLIN_API @"merlin_api"
#define TVSCHEDULES_API @"tvschedules_api"
#define NOTIFICATION_FAILED_REQUEST @"NotificationFailedRequest"

//cache time for json responses
#define CACHE_TIME_JSON 3600

#define GOONHILLY_URL_IPHONE @"http://log.pbs.org/log/cove-mobile-ga-iphone/"
#define GOONHILLY_URL_IPAD @"http://log.pbs.org/log/cove-mobile-ga-ipad/"

//#define VAST_VIDEO_URL @"http://stream.video.pbs.org/mg/variant/%@/%d/"
