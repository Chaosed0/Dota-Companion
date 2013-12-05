//
//  ELUHero.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/3/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHero.h"
#import "eluUtil.h"

static const NSString *kMeleeString = @"DOTA_UNIT_CAP_MELEE_ATTACK";
static const NSString *kRangeString = @"DOTA_UNIT_CAP_RANGED_ATTACK";
static const NSString *kRolePrefix = @"DOTA_Hero_Selection_AdvFilter_";
static const NSString *kRangedPrettyString = @"Attack_Ranged";
static const NSString *kMeleePrettyString = @"Attack_Melee";
static const NSString *baseImageURL = @"http://cdn.dota2.com/apps/dota2/images/heroes/";

@interface ELUHero ()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *roles;
@property (strong, nonatomic) NSURL *image_medium_url;
@property (strong, nonatomic) NSURL *image_large_url;

@end

@implementation ELUHero

-(id)initWithDict:(NSDictionary*)heroDict heroID:(NSString*) heroId stringsDict:(NSDictionary*)stringsDict {
    self = [super init];
    if(self) {
        self.name = stringsDict[heroId];
        
        NSString *roleString = (NSString*)heroDict[@"Role"];
        BOOL isMelee = [heroDict[@"AttackCapabilities"] isEqualToString:(NSString*)kMeleeString];
        
        NSArray *roles = [roleString componentsSeparatedByString:@","];
        self.roles = [self rolesFromArray:roles isMelee:isMelee stringsDict:stringsDict];
        
        NSString *imageName = [[[self.name lowercaseString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@"_"];
        NSString *imageURL = [NSString stringWithFormat:@"%@%@%@", baseImageURL, imageName, @"_full.png"];
        self.image_medium_url = [NSURL URLWithString:imageURL];
        self.image_large_url = [NSURL URLWithString:@""];
    }
    return self;
}

-(NSArray*) rolesFromArray:(NSArray*)roles isMelee:(BOOL)melee stringsDict:(NSDictionary*)stringsDict {
    NSMutableArray *prettyRoles = [NSMutableArray arrayWithCapacity:roles.count];
    //First thing should be melee/ranged
    NSString *rangeString;
    if(melee) {
        rangeString = (NSString*)kMeleePrettyString;
    } else {
        rangeString = (NSString*)kRangedPrettyString;
    }
    [prettyRoles addObject:(NSString*)stringsDict[[NSString stringWithFormat:@"%@%@", kRolePrefix, rangeString]]];
    for(NSString *role in roles) {
        if(![role isEqualToString:@""]) {
            NSString *roleString = [NSString stringWithFormat:@"%@%@", kRolePrefix, role];
            [prettyRoles addObject:(NSString*)stringsDict[roleString]];
        }
    }
    return prettyRoles;
}

@end
