//
//  ELUAbilityViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/9/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUAbilityViewController.h"
#import "ELUHeroAbility.h"

@interface ELUAbilityViewController ()

@end

@implementation ELUAbilityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.ability.name;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
