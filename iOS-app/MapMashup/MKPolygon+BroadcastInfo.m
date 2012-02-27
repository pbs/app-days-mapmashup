//
//  MKPolygon+ColorExtension.m
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <objc/runtime.h>
#import "MKPolygon+BroadcastInfo.h"

@implementation MKPolygon (BroadcastInfo)

static char boundsArrayKey;
static char imageOverlayKey;

- (void)setCoordinateBoundsArray:(NSArray *)coordinateBoundsArray {
    objc_setAssociatedObject( self, &boundsArrayKey, coordinateBoundsArray, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray *)coordinateBoundsArray {
    return objc_getAssociatedObject( self, &boundsArrayKey);
}

- (void)setBroadcastOverlayURLString:(NSString *)broadcastOverlayURLString {
   objc_setAssociatedObject( self, &imageOverlayKey, broadcastOverlayURLString, OBJC_ASSOCIATION_RETAIN); 
}

- (NSString *)broadcastOverlayURLString {
   return objc_getAssociatedObject( self, &imageOverlayKey); 
}

@end
