//
//  ELUHeroesModel.h
//  Dota Companion
//
//  Created by EDWARD LU on 12/4/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ELUHero;

@interface ELUHeroesModel : NSObject

- (id) initWithHeroesFile: (NSString*) heroesFileName stringsDict: (NSDictionary*) dotaStrings;
- (NSUInteger) count;
- (ELUHero*) heroAtIndex:(NSUInteger)index;
- (NSArray*) heroesForTeam:(NSString*)team primaryAttribute:(NSString*)primaryAttribute;
+ (ELUHeroesModel*) sharedInstance;

@end
