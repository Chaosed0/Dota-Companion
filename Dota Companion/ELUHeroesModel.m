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

const static NSString *keyHeroes = @"heroes";
const static NSString *kModelArchiveFilename = @"heroes.archive";

@interface ELUHeroesModel ()

@property (strong, nonatomic) NSArray *heroes;
@property (strong, nonatomic) NSDictionary *heroesByType;

@end

@implementation ELUHeroesModel

//Returns a singleton instance of the ELUHeroesModel
+ (ELUHeroesModel*) sharedInstance {
    static ELUHeroesModel *model = nil;
    if(!model) {
        NSString *archivePath = [eluUtil pathForResourceInDocumentsDirectory:(NSString*)kModelArchiveFilename];
        if([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
            //Decode it from the archive
            model = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        } else {
            //Create it anew from the base files and archive it
            model = [[ELUHeroesModel alloc] initWithHeroesFile:[eluUtil pathForResourceInMainBundle:(NSString*)kHeroesDictFile] stringsDict:[eluUtil dotaStrings]];
            [NSKeyedArchiver archiveRootObject:model toFile:archivePath];
        }
    }
    return model;
}

//Initialize the model from a file
- (id) initWithHeroesFile: (NSString*) heroesFileName stringsDict: (NSDictionary*) dotaStrings {
    self = [super init];
    if(self) {
        NSDictionary *heroesDict = [eluUtil parseDotaFile:heroesFileName];
        [self fillHeroesFromDict:heroesDict stringsDict:dotaStrings];
    }
    return self;
}

//Initializes this model from a decoder
- (id) initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.heroes = [aDecoder decodeObjectForKey:(NSString*)keyHeroes];
        self.heroesByType = [self constructHeroesByType];
    }
    return self;
}

//Encodes this model with a coder
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.heroes forKey:(NSString*)keyHeroes];
}

//Fills self.heroes and self.heroesByType from a dictionary
- (void) fillHeroesFromDict: (NSDictionary*) heroesDict stringsDict: (NSDictionary*)dotaStrings {
    //Initialization
    NSMutableArray *heroes = [NSMutableArray arrayWithCapacity:kInitialCapacity];
    NSDictionary *heroesDictHeroes = heroesDict[@"DOTAHeroes"];
    
    //Look through all the heroes in the heroesDict for valid heroes
    for(NSString* heroID in heroesDictHeroes) {
        //Only take heroes that are valid right now and have the correct prefix
        if([heroID hasPrefix:kHeroIdPrefix] && [heroesDictHeroes[heroID][kHeroEnabledKey] isEqualToString:@"1"]) {
            NSDictionary *heroInfo = heroesDictHeroes[heroID];
            ELUHero *hero = [[ELUHero alloc] initWithDict:heroInfo heroID:heroID stringsDict:dotaStrings];
            [heroes addObject:hero];
        }
    }
    
    //Sort the heroes by name
    self.heroes = [heroes sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ELUHero* hero1 = obj1;
        ELUHero* hero2 = obj2;
        return [hero1.name compare:hero2.name];
    }];
    
    //Construct the heroesByType dictionary
    self.heroesByType = [self constructHeroesByType];
}

//Constructs the heroesByType dictionary which groups heroes by team and primary attribute
//NOTE: self.heroes must be initialized already
- (NSDictionary*)constructHeroesByType {
    NSMutableDictionary *heroesByType = [NSMutableDictionary dictionaryWithCapacity:self.heroes.count];
       
    for (NSString *team in [ELUConstants sharedInstance].teams) {
        [heroesByType setValue:[NSMutableDictionary dictionary] forKey:team];
        for(NSString *attribute in [ELUConstants sharedInstance].attributes) {
            [heroesByType[team] setValue:[NSMutableArray array] forKey:attribute];
        }
    }
    
    for (ELUHero *hero in self.heroes) {
        [heroesByType[hero.isGood?kGoodTeamString:kBadTeamString][hero.primaryAttribute] addObject:hero];
    }
    return heroesByType;
}

//Returns the number of heroes in this model
- (NSUInteger) count {
    return [self.heroes count];
}

//Returns an array of heroes for a given team and primary attribute. Valid values
// for the inputs are contained in ELUConstants' teams and attributes arrays, respectively.
- (NSArray*) heroesForTeam:(NSString*)team primaryAttribute:(NSString*)primaryAttribute {
    return self.heroesByType[team][primaryAttribute];
}

//Returns a hero at an index. If index is greater than [self count], nil is returned.
- (ELUHero*) heroAtIndex:(NSUInteger)index {
    if(index >= self.count) {
        return nil;
    }
    return [self.heroes objectAtIndex:index];
}

@end
