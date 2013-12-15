//
//  ELUConstants.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/5/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUConstants.h"

const NSString *const kGoodTeamString = @"Good";
const NSString *const kBadTeamString = @"Bad";
const NSString *const kStrengthString = @"STRENGTH";
const NSString *const kAgilityString = @"AGILITY";
const NSString *const kIntellectString = @"INTELLECT";
const NSString *const kStrengthStringShort = @"STR";
const NSString *const kAgilityStringShort = @"AGI";
const NSString *const kIntelligenceStringShort = @"INT";
const NSString *const kTeamGood = @"Team_Good";
const NSString *const kTeamBad = @"Team_Bad";
const NSString *const kHeroIdPrefix = @"npc_dota_hero_";


@interface ELUConstants ()

@property (strong, nonatomic) UIFont *heroTitleFont;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *bigTitleFont;
@property (strong, nonatomic) UIFont *subtitleFont;
@property (strong, nonatomic) NSArray *teams;
@property (strong, nonatomic) NSArray *attributes;
@property (strong, nonatomic) UIColor *lightBackColor;
@property (strong, nonatomic) UIColor *darkBackColor;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *darkTextColor;

@end

@implementation ELUConstants

+(ELUConstants*)sharedInstance {
    static ELUConstants *constants = nil;
    if(!constants) {
        constants = [[ELUConstants alloc] init];
        constants.teams = @[kGoodTeamString, kBadTeamString];
        constants.attributes = @[kStrengthString, kAgilityString, kIntellectString];
        
        constants.lightBackColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:49/255.0 alpha:1.0];
        constants.darkBackColor = [UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1.0];
        constants.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        constants.darkTextColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        
        constants.heroTitleFont = [UIFont fontWithName:@"Georgia-Bold" size:22];
        constants.titleFont = [UIFont fontWithName:@"Georgia-Bold" size:16];
        constants.subtitleFont = [UIFont fontWithName:@"Trajan-Bold" size:13];
        constants.bigTitleFont = [UIFont fontWithName:@"Trajan-Bold" size:36];
    }
    return constants;
}

@end