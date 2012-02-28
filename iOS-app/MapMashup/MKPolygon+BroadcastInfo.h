//
//  MKPolygon+ColorExtension.h
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKPolygon (BroadcastInfo)

@property (strong, nonatomic) NSArray *coordinateBoundsArray;
@property (strong, nonatomic) UIImage *broadcastOverlayImage;
@property (strong, nonatomic) NSString *broadcastOverlayImageURLString;

@end
