//
//  ELURootViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/14/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELURootViewController.h"

@interface ELURootViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *learnHeroesButton;
@property (weak, nonatomic) IBOutlet UIButton *learnItemsButton;

@end

@implementation ELURootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.titleLabel.font = [ELUConstants sharedInstance].bigTitleFont;
    self.learnHeroesButton.titleLabel.font = [ELUConstants sharedInstance].titleFont;
    self.learnItemsButton.titleLabel.font = [ELUConstants sharedInstance].titleFont;
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

@end
