//
//  StationSignalOverlay.h
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface StationSignalOverlayView : MKPolygonView

@property (strong, nonatomic) UIImage *broadcastOverlayImage;
@property (strong, nonatomic) NSArray *overlayBoundsCoordsStrArray;

@end
