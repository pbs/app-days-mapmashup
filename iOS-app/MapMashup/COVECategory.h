//
//  COVECategory.h
//  PBSiPad
//
//  Created by Jason Jenkins on 9/10/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface COVECategory : NSObject {
 NSString *name;
 NSString *categoryId;
 NSMutableArray *children;
}
+ (COVECategory *) categoryWithDictionary: (NSDictionary*) dictionary;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSMutableArray *children;

- (void) addChild:(COVECategory *) child;
@end
