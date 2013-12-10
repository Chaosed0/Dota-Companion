//
//  ELUConstants.h
//  Dota Companion
//
//  Created by EDWARD LU on 12/5/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kGoodTeamString;
FOUNDATION_EXPORT NSString *const kBadTeamString;
FOUNDATION_EXPORT NSString *const kStrengthString;
FOUNDATION_EXPORT NSString *const kAgilityString;
FOUNDATION_EXPORT NSString *const kIntellectString;
FOUNDATION_EXPORT NSString *const kTeamGood;
FOUNDATION_EXPORT NSString *const kTeamBad;
FOUNDATION_EXPORT NSString *const kHeroIdPrefix;


@interface ELUConstants : NSObject

@property (strong, nonatomic, readonly) NSArray *teams;
@property (strong, nonatomic, readonly) NSArray *attributes;
@property (strong, nonatomic, readonly) UIColor *lightBackColor;
@property (strong, nonatomic, readonly) UIColor *darkBackColor;
@property (strong, nonatomic, readonly) UIColor *textColor;
@property (strong, nonatomic, readonly) UIColor *darkTextColor;
+(ELUConstants*)sharedInstance;

@end