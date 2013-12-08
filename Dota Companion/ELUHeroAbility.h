//
//  ELUHeroAbility.h
//  Dota Companion
//
//  Created by EDWARD LU on 12/4/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELUHeroAbility : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSURL *imageUrlSmall;
@property (strong, nonatomic, readonly) NSURL *imageUrlMedium;
@property (strong, nonatomic, readonly) NSString *simpleDescription;
@property (strong, nonatomic, readonly) NSArray *statNotes;
@property (strong, nonatomic, readonly) NSArray *notes;
@property (strong, nonatomic, readonly) NSString *lore;

-(id) initWithAbilityId:(NSString*)abilityId;

@end
