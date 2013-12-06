//
//  ELUHeroViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/6/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroViewController.h"

@interface ELUHeroViewController ()
@property (weak, nonatomic) IBOutlet UILabel *heroNameLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *abilityImageViews;
@property (weak, nonatomic) IBOutlet UIImageView *heroImageView;
@property (weak, nonatomic) IBOutlet UILabel *heroBioLabel;

@end

@implementation ELUHeroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

@end
