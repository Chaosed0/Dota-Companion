//
//  ELUHeroesModel.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/4/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroesModel.h"
#import "ELUHero.h"
#import "eluUtil.h"

#define kInitialCapacity 30

@interface ELUHeroesModel ()

@property (strong, nonatomic) NSArray *heroes;

@end

@implementation ELUHeroesModel

- (NSArray*) fillHeroesFromDict: (NSDictionary*) heroesDict stringsDict: (NSDictionary*)dotaStrings {
    NSMutableArray *heroes = [NSMutableArray arrayWithCapacity:kInitialCapacity];
    for(NSString* heroID in (NSDictionary*)heroesDict[@"DOTAHeroes"]) {
        if([heroID hasPrefix:@"npc_dota_hero_"] && ![heroID hasSuffix:@"base"]) {
            //Valid hero, this is an NSDictionary
            NSDictionary *heroInfo = heroesDict[heroID];
            ELUHero *hero = [ELUHero heroFromDict:heroInfo heroID:heroID stringsDict:dotaStrings];
            [heroes addObject:hero];
        }
    }
    return heroes;
}

- (id) initWithHeroesFile: (NSString*) heroesFileName stringsDict: (NSDictionary*) dotaStrings {
    self = [super init];
    if(self) {
        NSDictionary *heroesDict = [eluUtil parseDotaFile:heroesFileName];
        self.heroes = [self fillHeroesFromDict:heroesDict stringsDict:dotaStrings];
    }
    return self;
}

- (NSUInteger) count {
    return [self.heroes count];
}

- (ELUHero*) heroAtIndex:(NSUInteger)index {
    if(index >= self.count) {
        return nil;
    }
    return [self.heroes objectAtIndex:index];
}

@end
