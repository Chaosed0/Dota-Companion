//
//  ELUHeroAbility.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/4/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUAbility.h"

const NSString *kAbilityFileName = @"npc_abilities.txt";
const NSString *kAbilityStringPrefix = @"DOTA_Tooltip_ability_";
const NSString *kAbilityImageUrlSmallSuffix = @"_hp1.png";
const NSString *kAbilityImageUrlMediumSuffix = @"_hp2.png";
const NSString *kAbilityImageUrlPrefix = @"http://cdn.dota2.com/apps/dota2/images/abilities/";

const NSString *kCooldownString = @"AbilityCooldown";
const NSString *kManaCostString = @"AbilityManaCost";

@interface ELUAbility ()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *imageUrlSmall;
@property (strong, nonatomic) NSURL *imageUrlMedium;
@property (strong, nonatomic) NSString *simpleDescription;
@property (strong, nonatomic) NSArray *numericalNotes;
@property (strong, nonatomic) NSArray *stringNotes;
@property (strong, nonatomic) NSArray *manaCosts;
@property (strong, nonatomic) NSArray *cooldowns;
@property (strong, nonatomic) NSString *lore;

@end

@implementation ELUAbility

-(id) initWithAbilityId:(NSString*)abilityId {
    NSDictionary *abilityDict = [[ELUAbility sharedAbilityDict] objectForKey:abilityId];
    if(!abilityDict) {
        return nil;
    }
    
    self = [super init];
    if(self) {
        BOOL success = [self createDescriptionStringsForAbilityId:abilityId abilityDict:abilityDict];
        if(!success) {
            return nil;
        }
        self.imageUrlSmall = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", kAbilityImageUrlPrefix, abilityId, kAbilityImageUrlSmallSuffix]];
        self.imageUrlMedium = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", kAbilityImageUrlPrefix, abilityId, kAbilityImageUrlMediumSuffix]];
    }
    return self;
}

-(BOOL) createDescriptionStringsForAbilityId:(NSString*)abilityId abilityDict:(NSDictionary*)abilityDict {
    NSDictionary *dotaStrings = [eluUtil dotaStrings];
    NSString *baseDotaString = [eluUtil concatString:(NSString*)kAbilityStringPrefix and:abilityId];
    self.name = dotaStrings[baseDotaString];
    
    self.manaCosts = [abilityDict[kManaCostString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.cooldowns = [abilityDict[kCooldownString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    baseDotaString = [baseDotaString stringByAppendingString:@"_"];
    NSDictionary *abilitySpecial = abilityDict[@"AbilitySpecial"];
    NSMutableDictionary *reformedAbilitySpecial = [NSMutableDictionary dictionary];
    for (NSString *key in abilitySpecial) {
        for(NSString *actualKey in abilitySpecial[key]) {
            if(![actualKey isEqualToString: @"var_type"]) {
                NSString *value = abilitySpecial[key][actualKey];
                [reformedAbilitySpecial setValue:value forKey:actualKey];
            }
        }
    }
    
    NSString *description = dotaStrings[[eluUtil concatString:baseDotaString and:@"Description"]];
    if(!description) {
        return NO;
    }
    NSMutableString *simpleDescription = [NSMutableString string];
    
    BOOL firstEscape = YES;
    BOOL foundDoubleEscape = NO;
    NSUInteger lastEscapeLocation = -1;
    
    while(lastEscapeLocation != NSNotFound) {
        NSRange range = [description rangeOfString:@"%" options:NSLiteralSearch range:NSMakeRange(lastEscapeLocation + 1, description.length - lastEscapeLocation - 1)];
        
        if(range.location != NSNotFound) {
            if(firstEscape) {
                [simpleDescription appendString:[description substringWithRange:NSMakeRange(lastEscapeLocation + 1, range.location - lastEscapeLocation - 1)]];
            }
            
            if(firstEscape && [description characterAtIndex:range.location+1] == '%') {
                [simpleDescription appendString:@"%"];
                foundDoubleEscape = YES;
            } else if(firstEscape) {
                firstEscape = NO;
            } else {
                NSString *key = [description substringWithRange:NSMakeRange(lastEscapeLocation + 1, range.location - lastEscapeLocation - 1)];
                [simpleDescription appendString:reformedAbilitySpecial[key]];
                firstEscape = YES;
            }
        } else {
            [simpleDescription appendString:[description substringWithRange:NSMakeRange(lastEscapeLocation + 1, description.length - lastEscapeLocation - 1)]];
        }
        lastEscapeLocation = range.location;
        if(foundDoubleEscape) {
            lastEscapeLocation++;
            foundDoubleEscape = NO;
        }
    }
    
    //Newlines are represented as explicit "\n"; replace them
    [simpleDescription replaceOccurrencesOfString:@"\\n" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, simpleDescription.length)];
    self.simpleDescription = simpleDescription;
    
    NSMutableArray *numericalNotes = [NSMutableArray array];
    
    //Iterate through the remaining elements in the abilitySpecial dictionary
    for(NSString *key in reformedAbilitySpecial) {
        NSString *value = dotaStrings[[eluUtil concatString:baseDotaString and:key]];
        if(value) {
            NSString *slashedNumericalAbility = [reformedAbilitySpecial[key] stringByReplacingOccurrencesOfString:@" " withString:@"/"];
            [numericalNotes addObject:[NSString stringWithFormat:@"%@%@%@", value, @" ", slashedNumericalAbility]];
        }
    }
    
    self.numericalNotes = numericalNotes;
    
    NSMutableArray *stringNotes = [NSMutableArray array];
    
    int i = 0;
    NSString *notePrefix = [eluUtil concatString:baseDotaString and:@"Note"];
    NSString *note = [eluUtil concatString:notePrefix and:[NSString stringWithFormat:@"%d", i]];
    while(dotaStrings[note]) {
        [stringNotes addObject:dotaStrings[note]];
        i++;
        note = [eluUtil concatString:notePrefix and:[NSString stringWithFormat:@"%d", i]];
    }
    self.stringNotes = stringNotes;
    
    self.lore = dotaStrings[[eluUtil concatString:baseDotaString and:@"Lore"]];
    if(self.lore == nil) {
        self.lore = @"";
    }
    return YES;
}

+(NSDictionary*)sharedAbilityDict {
    static NSDictionary *abilityDict = nil;
    if(!abilityDict) {
        abilityDict = [eluUtil parseDotaFile:[eluUtil resourcePathLoc:(NSString*)kAbilityFileName]];
    }
    return abilityDict[@"DOTAAbilities"];
}

@end
