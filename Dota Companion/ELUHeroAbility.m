//
//  ELUHeroAbility.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/4/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroAbility.h"

const NSString *kAbilityFileName = @"npc_abilities.txt";
const NSString *kAbilityStringPrefix = @"DOTA_Tooltip_ability_";

@interface ELUHeroAbility ()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *lore;
@property (strong, nonatomic) NSArray *notes;

@end

@implementation ELUHeroAbility

-(id) initWithAbilityId:(NSString*)abilityId {
    NSDictionary *dotaStrings = [eluUtil dotaStrings];
    NSDictionary *abilityDict = [[ELUHeroAbility sharedAbilityDict] objectForKey:abilityId];
    if(!abilityDict) {
        return nil;
    }
    
    self = [super init];
    if(self) {
        NSString *baseDotaString = [eluUtil concatString:(NSString*)kAbilityStringPrefix and:abilityId];
        self.name = dotaStrings[baseDotaString];
        self.description = dotaStrings[[eluUtil concatString:baseDotaString and:@"Description"]];
    }
    return self;
}

+(NSString*)createDescriptionStringForAbilityId:(NSString*)abilityId abilityDict:(NSDictionary*)abilityDict {
    static const NSInteger bufferLen = 100;
    NSDictionary *dotaStrings = [eluUtil dotaStrings];
    NSString *baseDotaString = [eluUtil concatString:(NSString*)kAbilityStringPrefix and:abilityId];
    NSString *description = [eluUtil concatString:baseDotaString and:@"Description"];
    NSDictionary *abilitySpecial = abilityDict[abilityId][@"AbilitySpecial"];
    NSMutableDictionary *reformedAbilitySpecial;
    for (NSString *key in abilitySpecial) {
        for(NSString *key2 in abilitySpecial[key]) {
            if(![key2 isEqualToString: @"var_type"]) {
                [reformedAbilitySpecial setValue:abilitySpecial[key][key2] forKey:key2];
            }
        }
    }
    
    NSMutableString *finalDescription = [NSMutableString string];
    
    bool firstEscape = YES;
    NSUInteger lastEscapeLocation = -1;
    
    while(lastEscapeLocation != NSNotFound) {
        NSRange range = [description rangeOfString:@"%" options:nil range:NSMakeRange(lastEscapeLocation + 1, description.length - lastEscapeLocation - 1)];
        
        if(firstEscape) {
            [finalDescription appendString:[description substringWithRange:NSMakeRange(lastEscapeLocation + 1, range.location - lastEscapeLocation - 2)]];
        }
               
        lastEscapeLocation = range.location;
        
        if(firstEscape && [description characterAtIndex:range.location+1] == '%') {
            [finalDescription appendString:@"%"];
            lastEscapeLocation++;
        } else if(firstEscape) {
            firstEscape = NO;
        } else {
            NSString *key = [description substringWithRange:NSMakeRange(lastEscapeLocation + 1, range.location - lastEscapeLocation - 2)];
            [finalDescription appendString:reformedAbilitySpecial[key]];
            firstEscape = YES;
        }
    }
    
    //Iterate through the remaining elements in the abilitySpecial dictionary
    for(NSString *key in reformedAbilitySpecial) {
        NSString *value = dotaStrings[[eluUtil concatString:baseDotaString and:key]];
        if(value) {
            [finalDescription appendString:@"\n"];
            [finalDescription appendString:value];
            [finalDescription appendString:@": "];
            [finalDescription appendString:reformedAbilitySpecial[key]];
        }
    }
    
    //Ok, we're done.
    return finalDescription;
}

+(NSDictionary*)sharedAbilityDict {
    static NSDictionary *abilityDict = nil;
    if(!abilityDict) {
        abilityDict = [eluUtil parseDotaFile:(NSString*)kAbilityFileName];
    }
    return abilityDict;
}

@end
