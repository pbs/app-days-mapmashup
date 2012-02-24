//
//  COVECategory.m
//  PBSiPad
//
//  Created by Jason Jenkins on 9/10/10.
//  Copyright 2010 Three Pillar Global. All rights reserved.
//

#import "COVECategory.h"


@implementation COVECategory
@synthesize name;
@synthesize categoryId;
@synthesize children;

+ (COVECategory *) categoryWithDictionary: (NSDictionary*) dictionary 
{  
  COVECategory * category = [[COVECategory alloc] init];
  category.categoryId = [dictionary objectForKey:@"id"];
  category.name = [dictionary objectForKey:@"name"];
  return [category autorelease];
}
- (void) addChild:(COVECategory *) child
{
  if (self.children == NULL) {
    children = [[NSMutableArray alloc] init];
  }
  [children addObject:child];
}

- (NSComparisonResult)compare:(COVECategory *)c {
  return [self.name compare:c.name];
}

-(NSString*) description {
	//For now just return the title
	return self.name;
}

- (void)dealloc
{
  [name release];
  name = nil;
  [categoryId release];
  categoryId = nil;
  [children release];
  children = nil;
  
  [super dealloc];
}

@end
