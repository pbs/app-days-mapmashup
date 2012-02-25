//
//  MKPolygon+ColorExtension.m
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <objc/runtime.h>
#import "MKPolygon+ColorExtension.h"

@implementation MKPolygon (ColorExtension)

static char colorKey;

- (void) setPolygonColor:(UIColor *)polygonColor {
    objc_setAssociatedObject( self, &colorKey, polygonColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *) polygonColor{
    return objc_getAssociatedObject( self, &colorKey);
}
@end
