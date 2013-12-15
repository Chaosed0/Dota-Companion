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

const NSString *keyName = @"name";
const NSString *keyImageUrlSmall = @"imageUrlSmall";
const NSString *keyImageUrlMedium = @"imageUrlMedium";
const NSString *keySimpleDescription = @"simpleDescription";
const NSString *keyNumericalNotes = @"numericalNotes";
const NSString *keyStringNotes = @"stringNotes";
const NSString *keyManaCosts = @"manaCosts";
const NSString *keyCooldowns = @"cooldowns";
const NSString *keyLore = @"lore";

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

-(id) initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:(NSString*)keyName];
        self.imageUrlSmall = [aDecoder decodeObjectForKey:(NSString*)keyImageUrlSmall];
        self.imageUrlMedium = [aDecoder decodeObjectForKey:(NSString*)keyImageUrlMedium];
        self.simpleDescription = [aDecoder decodeObjectForKey:(NSString*)keySimpleDescription];
        self.numericalNotes = [aDecoder decodeObjectForKey:(NSString*)keyNumericalNotes];
        self.stringNotes = [aDecoder decodeObjectForKey:(NSString*)keyStringNotes];
        self.manaCosts = [aDecoder decodeObjectForKey:(NSString*)keyManaCosts];
        self.cooldowns = [aDecoder decodeObjectForKey:(NSString*)keyCooldowns];
        self.lore = [aDecoder decodeObjectForKey:(NSString*)keyLore];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:(NSString*)keyName];
    [aCoder encodeObject:self.imageUrlSmall forKey:(NSString*)keyImageUrlSmall];
    [aCoder encodeObject:self.imageUrlMedium forKey:(NSString*)keyImageUrlMedium];
    [aCoder encodeObject:self.simpleDescription forKey:(NSString*)keySimpleDescription];
    [aCoder encodeObject:self.numericalNotes forKey:(NSString*)keyNumericalNotes];
    [aCoder encodeObject:self.stringNotes forKey:(NSString*)keyStringNotes];
    [aCoder encodeObject:self.manaCosts forKey:(NSString*)keyManaCosts];
    [aCoder encodeObject:self.cooldowns forKey:(NSString*)keyCooldowns];
    [aCoder encodeObject:self.lore forKey:(NSString*)keyLore];
}

-(id) initWithAbilityId:(NSString*)abilityId {
    NSDictionary *abilityDict = [[ELUAbility sharedAbilityDict] objectForKey:abilityId];
    if(!abilityDict || [abilityId hasSuffix:@"empty1"] || [abilityId hasSuffix:@"empty2"] || [abilityId hasSuffix:@"attribute_bonus"]) {
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
    //Grab some temp variables
    NSDictionary *dotaStrings = [eluUtil dotaStrings];
    NSString *baseDotaString = [eluUtil concatString:(NSString*)kAbilityStringPrefix and:abilityId];
    
    //Try to get the description; if it doesn't exist, then in general,
    // this ability is not correct
    NSString *description = dotaStrings[[eluUtil concatString:baseDotaString and:@"Description"]];
    if(!description) {
        return NO;
    }
    
    //Grab some easy-to-get variables
    self.name = dotaStrings[baseDotaString];
    self.manaCosts = [abilityDict[kManaCostString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.cooldowns = [abilityDict[kCooldownString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.lore = dotaStrings[[eluUtil concatString:baseDotaString and:@"Lore"]];
    if(self.lore == nil) {
        self.lore = @"";
    }
    
    //Change the format of the "AbilitySpecial" dictionary, because it's in an incredibly
    // stupid format
    //srs volvo pls fix
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
    
    //Put together the description, replacing any escaped variables
    NSMutableString *simpleDescription = [NSMutableString string];
    
    BOOL firstEscape = YES;
    BOOL foundDoubleEscape = NO;
    NSUInteger lastEscapeLocation = -1;
    
    while(lastEscapeLocation != NSNotFound) {
        //Try to find a % character, signifying an escape
        NSRange range = [description rangeOfString:@"%" options:NSLiteralSearch range:NSMakeRange(lastEscapeLocation + 1, description.length - lastEscapeLocation - 1)];
        
        if(range.location != NSNotFound) {
            //We found a % char
            if(firstEscape) {
                //This is the first escape character we found; append the characters that were
                // before this and record its position
                [simpleDescription appendString:[description substringWithRange:NSMakeRange(lastEscapeLocation + 1, range.location - lastEscapeLocation - 1)]];
            }
            if(firstEscape && [description characterAtIndex:range.location+1] == '%') {
                //This is the first escape chracter we found, but it's just a double-escape;
                // put down an actual % character
                [simpleDescription appendString:@"%"];
                foundDoubleEscape = YES;
            } else if(firstEscape) {
                //It wasn't a double escape, but this was still the first escape;
                // we must find the next % character
                firstEscape = NO;
            } else {
                //This was a second escape character. Grab the variable name and
                // try to find it in the AbilitySpecial dictionary
                NSString *key = [description substringWithRange:NSMakeRange(lastEscapeLocation + 1, range.location - lastEscapeLocation - 1)];
                [simpleDescription appendString:reformedAbilitySpecial[key]];
                firstEscape = YES;
            }
        } else {
            //We found no escape. Just copy the rest of the characters to the description.
            [simpleDescription appendString:[description substringWithRange:NSMakeRange(lastEscapeLocation + 1, description.length - lastEscapeLocation - 1)]];
        }
        //Record the last place we found the escape character
        lastEscapeLocation = range.location;
        if(foundDoubleEscape) {
            //If we found a double escape, skip the next escape character.
            lastEscapeLocation++;
            foundDoubleEscape = NO;
        }
    }
    
    //Newlines are represented as explicit "\\n" in the description; replace them
    [simpleDescription replaceOccurrencesOfString:@"\\n" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, simpleDescription.length)];
    self.simpleDescription = simpleDescription;
    
    //Iterate through the remaining elements in the abilitySpecial dictionary, checking
    // if they have notes attached to them
    NSMutableArray *numericalNotes = [NSMutableArray array];
    for(NSString *key in reformedAbilitySpecial) {
        NSString *value = dotaStrings[[eluUtil concatString:baseDotaString and:key]];
        if(value) {
            NSString *slashedNumericalAbility = [reformedAbilitySpecial[key] stringByReplacingOccurrencesOfString:@" " withString:@"/"];
            [numericalNotes addObject:[NSString stringWithFormat:@"%@%@%@", value, @" ", slashedNumericalAbility]];
        }
    }
    
    self.numericalNotes = numericalNotes;
    
    //Iterate through notes in the dotaStrings dict about this ability, recording them
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
    
    return YES;
}

+(NSDictionary*)sharedAbilityDict {
    static NSDictionary *abilityDict = nil;
    if(!abilityDict) {
        abilityDict = [eluUtil parseDotaFile:[eluUtil pathForResourceInMainBundle:(NSString*)kAbilityFileName]];
    }
    return abilityDict[@"DOTAAbilities"];
}

@end
