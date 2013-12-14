//
//  ELUHeroViewController.h
//  Dota Companion
//
//  Created by EDWARD LU on 12/6/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELUHero;

@interface ELUHeroViewController : UIViewController <UINavigationBarDelegate>

@property (strong, nonatomic) ELUHero *hero;
@property (copy, nonatomic) void (^onCompletion)(void);

@end
