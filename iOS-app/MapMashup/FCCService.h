//
//  FCCService.h
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"

@interface FCCService : NSObject

- (void)downloadFCCData:(NSString *)stationName delegate:(id)delegate;

@end
