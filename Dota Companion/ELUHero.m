//
//  ELUHero.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/3/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHero.h"
#import "eluUtil.h"

@interface ELUHero ()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *roles;
@property (strong, nonatomic) UIImage *image_medium;
@property (strong, nonatomic) UIImage *image_large;

@end

@implementation ELUHero

+(id)heroFromDict:(NSDictionary*)heroDict heroID:(NSString*) heroId stringsDict:(NSDictionary*)stringsDict {
    ELUHero *hero = [[ELUHero alloc] init];
    hero.name = stringsDict[heroId];
    hero.roles = [((NSString*)stringsDict[@"hero"]) componentsSeparatedByString:@","];
    hero.image_medium = [UIImage imageNamed:[eluUtil resourcePathLoc:@"EMRAKUL.jpg"]];
    hero.image_large = [UIImage imageNamed:[eluUtil resourcePathLoc:@"EMRAKUL.jpg"]];
    return hero;
}

@end
