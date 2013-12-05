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


@interface ELUConstants ()

@property (strong, nonatomic) NSArray *teams;
@property (strong, nonatomic) NSArray *attributes;

@end

@implementation ELUConstants

+(ELUConstants*)sharedInstance {
    static ELUConstants *constants = nil;
    if(!constants) {
        constants = [[ELUConstants alloc] init];
        constants.teams = @[kGoodTeamString, kBadTeamString];
        constants.attributes = @[kStrengthString, kAgilityString, kIntellectString];
    }
    return constants;
}

@end