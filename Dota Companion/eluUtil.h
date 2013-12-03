//
//  eluUtil.h
//  Pentominoes
//
//  Created by EDWARD LU on 9/15/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eluUtil : NSObject

+ (NSString*)resourcePathLoc:(NSString*)resource;
+ (NSDictionary*)createThemeWithColor:(UIColor*)color andFont:(UIFont*) font;

@end
