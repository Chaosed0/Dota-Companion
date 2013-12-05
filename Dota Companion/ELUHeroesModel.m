//
//  ELUHeroesModel.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/4/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroesModel.h"
#import "ELUHero.h"

#define kInitialCapacity 30

const static NSString *kHeroesDictFile = @"npc_heroes.txt";

@interface ELUHeroesModel ()

@property (strong, nonatomic) NSArray *heroes;
@property (strong, nonatomic) NSDictionary *heroesByType;

@end

@implementation ELUHeroesModel

+ (ELUHeroesModel*) sharedInstance {
    static ELUHeroesModel *model = nil;
    if(!model) {
        model = [[ELUHeroesModel alloc] initWithHeroesFile:[eluUtil resourcePathLoc:(NSString*)kHeroesDictFile] stringsDict:[eluUtil dotaStrings]];
    }
    return model;
}

- (void) fillHeroesFromDict: (NSDictionary*) heroesDict stringsDict: (NSDictionary*)dotaStrings {
    NSMutableArray *heroes = [NSMutableArray arrayWithCapacity:kInitialCapacity];
    NSMutableDictionary *heroesByType = [[NSMutableDictionary alloc] init];
    
    [heroesByType setValue:[NSMutableDictionary dictionary] forKey:kGoodTeamString];
    [heroesByType setValue:[NSMutableDictionary dictionary] forKey:kBadTeamString];
    [heroesByType[kGoodTeamString] setValue:[NSMutableArray array] forKey:kStrengthString];
    [heroesByType[kBadTeamString] setValue:[NSMutableArray array] forKey:kStrengthString];
    [heroesByType[kGoodTeamString] setValue:[NSMutableArray array] forKey:kAgilityString];
    [heroesByType[kBadTeamString] setValue:[NSMutableArray array] forKey:kAgilityString];
    [heroesByType[kGoodTeamString] setValue:[NSMutableArray array] forKey:kIntelligenceString];
    [heroesByType[kBadTeamString] setValue:[NSMutableArray array] forKey:kIntelligenceString];
    
    NSDictionary *heroesDictHeroes = heroesDict[@"DOTAHeroes"];
    for(NSString* heroID in heroesDictHeroes) {
        if([heroID hasPrefix:@"npc_dota_hero_"] && ![heroID hasSuffix:@"base"]) {
            //Valid hero, this is an NSDictionary
            NSDictionary *heroInfo = heroesDictHeroes[heroID];
            ELUHero *hero = [[ELUHero alloc] initWithDict:heroInfo heroID:heroID stringsDict:dotaStrings];
            [heroes addObject:hero];
            [heroesByType[hero.isGood?kGoodTeamString:kBadTeamString][hero.primaryAttribute] addObject:hero];
        }
    }
    
    self.heroes = heroes;
    self.heroesByType = heroesByType;
}

- (id) initWithHeroesFile: (NSString*) heroesFileName stringsDict: (NSDictionary*) dotaStrings {
    self = [super init];
    if(self) {
        NSDictionary *heroesDict = [eluUtil parseDotaFile:heroesFileName];
        [self fillHeroesFromDict:heroesDict stringsDict:dotaStrings];
    }
    return self;
}

- (NSUInteger) count {
    return [self.heroes count];
}

- (NSArray*) heroesForTeam:(NSString*)team primaryAttribute:(NSString*)primaryAttribute {
    return self.heroesByType[team][primaryAttribute];
}

- (ELUHero*) heroAtIndex:(NSUInteger)index {
    if(index >= self.count) {
        return nil;
    }
    return [self.heroes objectAtIndex:index];
}

@end
