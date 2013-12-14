//
//  eluUtil.h
//  Pentominoes
//
//  Created by EDWARD LU on 9/15/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eluUtil : NSObject

+ (NSString*)pathForResourceInMainBundle:(NSString*)resource;
+ (NSString*)pathForResourceInDocumentsDirectory:(NSString*)resource;
+ (NSDictionary*)parseDotaFile:(NSString*)dotaFileName;
+ (NSString*)concatString:(NSString*)str1 and:(NSString*)str2;
+ (NSDictionary*)dotaStrings;
+ (void) logRect:(CGRect)rect;
+ (BOOL) deviceIsRetina;

@end
