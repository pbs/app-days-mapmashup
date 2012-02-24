//
//  COVEProgram.h
//  PBSiPad
//
//  Created by Robert Rosenburgh on 7/28/10.
//  Copyright 2010 BRE Technology LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COVEProgram : NSObject {
  NSInteger sectionNumber;
}

+ (COVEProgram*) programWithDictionary: (NSDictionary*) dictionary;
+ (NSString *) programURIFromDictionary: (NSDictionary*) dictionary;

@property(nonatomic,copy)NSString *programId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *shortDescription;
@property(nonatomic,copy)NSString *longDescription;
@property(nonatomic,copy)NSString *nolaRoot;
@property(nonatomic,copy)NSString *resourceURI;
@property(nonatomic,copy)NSString *imageURL;
@property(nonatomic,copy)NSString *thumbnailURL;
@property(nonatomic,copy)NSString *website;
@property(nonatomic,retain) NSArray *categories;
@property(nonatomic,retain) NSDictionary *programDictionary;
@property(nonatomic,assign) NSInteger sectionNumber;
@property(nonatomic,retain) NSDictionary *buyLinks;

@end
