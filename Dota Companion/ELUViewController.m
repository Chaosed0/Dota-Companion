//
//  ELUViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/3/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface ELUViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *cardView;
- (IBAction)playButtonPressed:(UIBarButtonItem *)sender;

@property double rotation;

@end

@implementation ELUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rotation = 0.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonPressed:(UIBarButtonItem *)sender {
    self.rotation += M_PI * 0.5;
    CATransform3D rotationAndPerspective = CATransform3DIdentity;
    rotationAndPerspective.m34 = 1.0 / - 1000.0;
    rotationAndPerspective = CATransform3DRotate(rotationAndPerspective, self.rotation, 0.0, 1.0, 0.0);
    [UIView animateWithDuration:0.5f animations:^{
        self.cardView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.cardView.layer.transform = rotationAndPerspective;
        self.cardView.frame = CGRectMake(320, self.view.frame.size.height/2.0 - self.cardView.image.size.height/2.0, 0, self.view.frame.size.height/2.0);
    } completion:^(BOOL complete){
    }];
}
@end
