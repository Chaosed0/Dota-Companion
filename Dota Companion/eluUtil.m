//
//  eluUtil.m
//  Pentominoes
//
//  Created by EDWARD LU on 9/15/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "eluUtil.h"

static const NSString *kStringsDictLoc = @"dota_english.txt";

@interface eluUtil ()
@end

@implementation eluUtil

//Returns an NSString containing the location of a given resource inside the main bundle.
+ (NSString*)resourcePathLoc:(NSString*)resource {
    return [NSString stringWithFormat:@"%@/%@", [NSBundle mainBundle].resourcePath, resource];
}

+ (NSDictionary*)parseDotaFile:(NSString*)dotaFileName {
    static int length = 100;
    NSError *error;
    NSStringEncoding *enc = nil;
    NSString *strings = [NSString stringWithContentsOfFile:dotaFileName usedEncoding:enc error:&error];
    unichar *buffer = malloc(sizeof(unichar)*length);
    [strings getCharacters:buffer range:NSMakeRange(0, length)];
    NSUInteger current = 0;
    NSUInteger start = 0;
    
    return [eluUtil parseStrings:strings curBuffer:&buffer bufferStart:&start bufferLen:length bufferLoc:&current];
}

+ (NSDictionary*)parseStrings:(NSString*)string curBuffer:(unichar**)buffer bufferStart:(NSUInteger*)start bufferLen:(NSUInteger)bufferLen bufferLoc:(NSUInteger*)loc {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    unichar c = (*buffer)[*loc];
    BOOL inString = NO;
    BOOL foundKey = NO;
    BOOL escape = NO;
    BOOL beganComment = NO;
    BOOL inComment = NO;
    NSMutableString *key;
    NSObject *value;
    
    BOOL recurse = NO;
    BOOL stop = NO;
    while(!stop) {
        if(inComment) {
            if([[NSCharacterSet newlineCharacterSet] characterIsMember:c]) {
                inComment = NO;
            }
        } else if(c == '\"' && !escape) {
            //We found a quote character; we either ended or began a string
            if(foundKey) {
                //We've already found the key; this is beginning or ending a value
                if(inString) {
                    //We were already in a string; ending this value. Store the key value pair
                    // and reset
                    [result setValue:value forKey:key];
                    key = nil;
                    value = nil;
                    foundKey = NO;
                } else {
                    //We are starting a string
                    value = [[NSMutableString alloc] init];
                }
            } else {
                //We've not found the key yet; this is beginning or ending a key
                if(inString) {
                    //We were already in a string; save the key and say we found one
                    foundKey = YES;
                } else {
                    //We are starting a key
                    key = [[NSMutableString alloc] init];
                }
            }
            //Whatever it was, we are now opposite of in a string
            inString = !inString;
        } else if(inString) {
            //If we're in a string, append the character to the correct string
            if(foundKey) {
                [(NSMutableString*)value appendString:[NSString stringWithCharacters:&c length:1]];
            } else {
                [key appendString:[NSString stringWithCharacters:&c length:1]];
            }
        } else if(c == '/') {
            if(!beganComment) {
                beganComment = YES;
            } else {
                beganComment = NO;
                inComment = YES;
            }
        } else if(c == '{') {
            //We are beginning a dictionary
            if(foundKey) {
                //We want to advance the character first
                recurse = YES;
            } else {
                NSLog(@"Error: Found dict but expected string (key)");
            }
        } else if(c == '}' || c == '\0') {
            //We are ending a dictionary; we want to advance the character first
            stop = true;
        }
        (*loc)++;
        if(*loc >= bufferLen) {
            *loc = 0;
            *start += bufferLen;
            if(*start + bufferLen < string.length) {
                [string getCharacters:(*buffer) range: NSMakeRange((*start), bufferLen)];
            } else {
                [string getCharacters:(*buffer) range: NSMakeRange((*start), string.length - *start)];
                (*buffer)[string.length - *start + 1] = '\0';
            }
        }
        if(!stop) {
            if(recurse) {
                value = [eluUtil parseStrings:string curBuffer:buffer bufferStart:start bufferLen:bufferLen bufferLoc:loc];
               [result setValue:value forKey:key];
                key = nil;
                value = nil;
                foundKey = NO;
                recurse = NO;
            }
            c = (*buffer)[*loc];
        }
    }
    
    return result;
}

+ (NSDictionary*)dotaStrings {
    static NSDictionary *dotaStringsDict = nil;
    if(!dotaStringsDict) {
        dotaStringsDict = [eluUtil parseDotaFile: [eluUtil resourcePathLoc:(NSString*)kStringsDictLoc]];
        dotaStringsDict = dotaStringsDict[@"lang"][@"Tokens"];
    }
    return dotaStringsDict;
}

@end
