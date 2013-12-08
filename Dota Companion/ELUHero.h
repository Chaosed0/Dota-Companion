//
//  ELUHero.h
//  Dota Companion
//
//  Created by EDWARD LU on 12/3/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELUHero : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSArray *roles;
@property (strong, nonatomic, readonly) NSArray *abilities;
@property (readonly) BOOL isGood;
@property (strong, nonatomic, readonly) NSString *primaryAttribute;
@property (strong, nonatomic, readonly) NSString *bio;
@property (strong, nonatomic, readonly) NSURL *imageUrlSmall;
@property (strong, nonatomic, readonly) NSURL *imageUrlMedium;
@property (strong, nonatomic, readonly) NSURL *imageUrlLarge;
@property (strong, nonatomic, readonly) NSURL *imageUrlPortrait;

-(id)initWithDict:(NSDictionary*)heroDict heroID:(NSString*) heroId stringsDict:(NSDictionary*)stringsDict;

@end
