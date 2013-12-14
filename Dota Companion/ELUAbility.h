//
//  ELUHeroAbility.h
//  Dota Companion
//
//  Created by EDWARD LU on 12/4/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELUAbility : NSObject <NSCoding>

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSURL *imageUrlSmall;
@property (strong, nonatomic, readonly) NSURL *imageUrlMedium;
@property (strong, nonatomic, readonly) NSString *simpleDescription;
@property (strong, nonatomic, readonly) NSArray *numericalNotes;
@property (strong, nonatomic, readonly) NSArray *stringNotes;
@property (strong, nonatomic, readonly) NSArray *manaCosts;
@property (strong, nonatomic, readonly) NSArray *cooldowns;
@property (strong, nonatomic, readonly) NSString *lore;

-(id) initWithAbilityId:(NSString*)abilityId;

@end