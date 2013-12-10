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
const static NSString *kHeroEnabledKey = @"Enabled";

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
    
    for (NSString *team in [ELUConstants sharedInstance].teams) {
        [heroesByType setValue:[NSMutableDictionary dictionary] forKey:team];
        for(NSString *attribute in [ELUConstants sharedInstance].attributes) {
            [heroesByType[team] setValue:[NSMutableArray array] forKey:attribute];
        }
    }
    
    NSDictionary *heroesDictHeroes = heroesDict[@"DOTAHeroes"];
    for(NSString* heroID in heroesDictHeroes) {
        if([heroID hasPrefix:kHeroIdPrefix] && [heroesDictHeroes[heroID][kHeroEnabledKey] isEqualToString:@"1"]) {
            //Valid hero, this is an NSDictionary
            NSDictionary *heroInfo = heroesDictHeroes[heroID];
            ELUHero *hero = [[ELUHero alloc] initWithDict:heroInfo heroID:heroID stringsDict:dotaStrings];
            [heroes addObject:hero];
            [heroesByType[hero.isGood?kGoodTeamString:kBadTeamString][hero.primaryAttribute] addObject:hero];
        }
    }
    
    [self.heroes sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ELUHero* hero1 = obj1;
        ELUHero* hero2 = obj2;
        return [hero1.name compare:hero2.name];
    }];
    
    self.heroesByType = heroesByType;
    self.heroes = heroes;
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
