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
static char imageOverlayURLKey;

- (void)setCoordinateBoundsArray:(NSArray *)coordinateBoundsArray {
    objc_setAssociatedObject( self, &boundsArrayKey, coordinateBoundsArray, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray *)coordinateBoundsArray {
    return objc_getAssociatedObject( self, &boundsArrayKey);
}

- (void)setBroadcastOverlayImage:(UIImage *)broadcastOverlayImage {
   objc_setAssociatedObject( self, &imageOverlayKey, broadcastOverlayImage, OBJC_ASSOCIATION_RETAIN); 
}

- (UIImage *)broadcastOverlayImage {
   return objc_getAssociatedObject( self, &imageOverlayKey); 
}

- (void)setBroadcastOverlayImageURLString:(NSString *)broadcastOverlayImageURLString {
   objc_setAssociatedObject( self, &imageOverlayURLKey, broadcastOverlayImageURLString, OBJC_ASSOCIATION_RETAIN);  
}

- (NSString *)broadcastOverlayImageURLString {
   return objc_getAssociatedObject( self, &imageOverlayURLKey);  
}

@end
