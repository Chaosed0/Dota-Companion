//
//  ELURootViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/14/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELURootViewController.h"

#define kPadding 20.0

@interface ELURootViewController ()
@property (weak, nonatomic) IBOutlet UIButton *learnHeroesButton;
@property (weak, nonatomic) IBOutlet UIButton *learnItemsButton;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation ELURootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.learnHeroesButton.titleLabel.font = [ELUConstants sharedInstance].titleFont;
    self.learnItemsButton.titleLabel.font = [ELUConstants sharedInstance].titleFont;
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillLayoutSubviews {
    [self checkOrientation:self.interfaceOrientation];
}

- (void)checkOrientation:(UIInterfaceOrientation)orientation {
    CGSize frameSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        self.logoImageView.frame = CGRectMake(kPadding, kPadding, self.logoImageView.frame.size.width, self.logoImageView.frame.size.height);
        NSInteger xPosition = self.logoImageView.frame.origin.x + self.logoImageView.frame.size.width + kPadding;
        self.titleImageView.frame = CGRectMake(xPosition, self.logoImageView.center.y - self.titleImageView.frame.size.height / 2.0, frameSize.width - xPosition - kPadding*2, self.titleImageView.frame.size.height);
    } else if(UIInterfaceOrientationIsPortrait(orientation)) {
        self.logoImageView.frame = CGRectMake(self.view.bounds.size.width / 2.0 - self.logoImageView.frame.size.width / 2.0, kPadding, self.logoImageView.frame.size.width, self.logoImageView.frame.size.height);
        NSInteger yPosition = self.logoImageView.frame.origin.y + self.logoImageView.frame.size.height + kPadding;
        self.titleImageView.frame = CGRectMake(kPadding, yPosition, frameSize.width - kPadding * 2, self.titleImageView.frame.size.height);
    }
}

@end
