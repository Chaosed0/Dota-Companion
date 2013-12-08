//
//  ELUHero.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/3/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHero.h"
#import "ELUHeroAbility.h"
#import "eluUtil.h"

static const NSString *kAttackString = @"AttackCapabilities";
static const NSString *kPrimaryAttributeString = @"AttributePrimary";
static const NSString *kMeleeString = @"DOTA_UNIT_CAP_MELEE_ATTACK";
static const NSString *kRolePrefix = @"DOTA_Hero_Selection_AdvFilter_";
static const NSString *kRangedPrettyString = @"Attack_Ranged";
static const NSString *kMeleePrettyString = @"Attack_Melee";
static const NSString *kBaseImageURL = @"http://cdn.dota2.com/apps/dota2/images/heroes/";
static const NSString *kFullHeroImageSuffix = @"_full.png";
static const NSString *kMediumHeroImageSuffix = @"_hphover.png";
static const NSString *kSmallHeroImageSuffix = @"_sb.png";
static const NSString *kHeroPortraitImageSuffix = @"_vert.jpg";
static const NSString *kBioSuffix = @"_bio";
static const NSString *kTeamString = @"Team";
static const NSString *kAttributePrefix = @"DOTA_ATTRIBUTE_";

#define kDefaultNumAbilities 4

@interface ELUHero ()

@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSArray *roles;
@property (strong, nonatomic, readwrite) NSArray *abilities;
@property (readwrite) BOOL isGood;
@property (strong, nonatomic, readwrite) NSString *primaryAttribute;
@property (strong, nonatomic, readwrite) NSString *bio;
@property (strong, nonatomic, readwrite) NSURL *imageUrlSmall;
@property (strong, nonatomic, readwrite) NSURL *imageUrlMedium;
@property (strong, nonatomic, readwrite) NSURL *imageUrlLarge;
@property (strong, nonatomic, readwrite) NSURL *imageUrlPortrait;

@end

@implementation ELUHero

-(id)initWithDict:(NSDictionary*)heroDict heroID:(NSString*) heroId stringsDict:(NSDictionary*)stringsDict {
    self = [super init];
    if(self) {
        self.name = stringsDict[heroId];
        
        NSString *roleString = (NSString*)heroDict[@"Role"];
        BOOL isMelee = [heroDict[kAttackString] isEqualToString:(NSString*)kMeleeString];
        
        NSArray *roles = [roleString componentsSeparatedByString:@","];
        self.roles = [self rolesFromArray:roles isMelee:isMelee stringsDict:stringsDict];
        self.isGood = [heroDict[kTeamString] isEqualToString:(NSString*)kGoodTeamString];
        self.primaryAttribute = [heroDict[kPrimaryAttributeString] substringFromIndex:kAttributePrefix.length];
        self.bio = stringsDict[[NSString stringWithFormat:@"%@%@", heroId, kBioSuffix]];
        
        NSString *imageName = [heroId substringFromIndex:kHeroIdPrefix.length];
        self.imageUrlSmall = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", kBaseImageURL, imageName, kSmallHeroImageSuffix]];
        self.imageUrlMedium = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", kBaseImageURL, imageName, kMediumHeroImageSuffix]];
        self.imageUrlLarge = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", kBaseImageURL, imageName, kFullHeroImageSuffix]];
        self.imageUrlPortrait = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", kBaseImageURL, imageName, kHeroPortraitImageSuffix]];
        
        int i = 0;
        NSMutableArray *abilities = [NSMutableArray arrayWithCapacity:kDefaultNumAbilities];
        NSString *key = [NSString stringWithFormat:@"%@%d", @"Ability", i+1];
        NSString *value = heroDict[key];
        while(value) {
            ELUHeroAbility *ability = [[ELUHeroAbility alloc] initWithAbilityId:value];
            if(ability) {
                [abilities addObject:ability];
            }
            
            i++;
            key = [NSString stringWithFormat:@"%@%d", @"Ability", i+1];
            value = heroDict[key];
        }
        
        self.abilities = abilities;
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
