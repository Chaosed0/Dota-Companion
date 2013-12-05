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
@property (strong, nonatomic, readonly) NSURL *image_medium_url;
@property (strong, nonatomic, readonly) NSURL *image_large_url;

-(id)initWithDict:(NSDictionary*)heroDict heroID:(NSString*) heroId stringsDict:(NSDictionary*)stringsDict;

@end
