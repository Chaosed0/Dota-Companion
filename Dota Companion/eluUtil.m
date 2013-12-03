//
//  eluUtil.m
//  Pentominoes
//
//  Created by EDWARD LU on 9/15/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "eluUtil.h"

@implementation eluUtil

//Returns an NSString containing the location of a given resource inside the main bundle.
+ (NSString*)resourcePathLoc:(NSString*)resource {
    return [NSString stringWithFormat:@"%@/%@", [NSBundle mainBundle].resourcePath, resource];
}

@end
