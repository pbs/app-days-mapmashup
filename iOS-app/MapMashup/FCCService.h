//
//  FCCService.h
//  MapMashup
//
//  Created by Rares Zehan on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FCCServiceDelegate
-(void) didFindResults:(NSArray*) results;
-(void) didFail:(NSError*) error;
@end

@interface FCCService : NSObject

@property (nonatomic, assign) id<FCCServiceDelegate> delegate;

- (void)downloadFCCData:(NSString *)stationName;

@end
