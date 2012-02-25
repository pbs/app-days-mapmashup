//
//  UIColor+RGBHexExtension.h
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGBHexExtension)

+ (UIColor *) colorFromHexString:(NSString *)hexString;

@end
