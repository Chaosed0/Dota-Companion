//
//  ELUHeroDataDelegate.h
//  Dota Companion
//
//  Created by EDWARD LU on 12/13/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ELUHero;

@protocol ELUHeroDelegate <NSObject>

- (ELUHero*)heroForIndex:(NSUInteger)index;
- (NSArray*)heroesForTeam:(NSString*)team primaryAttribute:(NSString*)primaryAttribute;
- (NSInteger)heroCount;
- (void)heroTapped:(ELUHero*)hero;

@end
