//
//  StationSignalOverlay.m
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StationSignalOverlayView.h"

@interface StationSignalOverlayView () 
@end

@implementation StationSignalOverlayView

@synthesize broadcastOverlayImage;
@synthesize overlayBoundsCoordsStrArray;

-(void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    NSArray *corner1Array = [self.overlayBoundsCoordsStrArray objectAtIndex:0];
    NSArray *corner2Array = [self.overlayBoundsCoordsStrArray objectAtIndex:1];
    
    CLLocationCoordinate2D corner1 = CLLocationCoordinate2DMake([[corner1Array objectAtIndex:0] doubleValue], [[corner1Array objectAtIndex:1] doubleValue]);
    MKMapPoint mp1 = MKMapPointForCoordinate(corner1);
    
    CLLocationCoordinate2D corner2 = CLLocationCoordinate2DMake([[corner2Array objectAtIndex:0] doubleValue], [[corner2Array objectAtIndex:1] doubleValue]);
    MKMapPoint mp2 = MKMapPointForCoordinate(corner2);
    
    MKMapRect theMapRect = MKMapRectMake(mp1.x, mp2.y, (mp2.x-mp1.x), (mp2.y-mp1.y));
    
    CGRect theRect = [self rectForMapRect:theMapRect];
    
    UIGraphicsPushContext(context);
    [self.broadcastOverlayImage drawInRect:theRect blendMode:kCGBlendModeNormal alpha:0.5];
    UIGraphicsPopContext();
}

@end
