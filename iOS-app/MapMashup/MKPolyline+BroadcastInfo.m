//
//  MKPolyline+BroadcastInfo.m
//  MapMashup
//
//  Created by Rares Zehan on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <objc/runtime.h>
#import "MKPolyline+BroadcastInfo.h"

@implementation MKPolyline (BroadcastInfo)

static char broadcastColorKey;

- (void)setBroadcastColor:(UIColor *)broadcastColor {
    objc_setAssociatedObject( self, &broadcastColorKey, broadcastColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)broadcastColor {
    return objc_getAssociatedObject( self, &broadcastColorKey);
}

@end
