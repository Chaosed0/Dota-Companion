//
//  ELUViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/3/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroesCardViewController.h"
#import "ELUHeroesModel.h"
#import "ELUCardView.h"

#import <QuartzCore/QuartzCore.h>

@interface ELUHeroesCardViewController ()
@property(strong, nonatomic) ELUHeroesModel *heroesModel;

@property double rotation;
@property NSUInteger currentHero;
@property BOOL isShowingLandscapeView;

- (IBAction)playButtonPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet ELUCardView *cardView;

@end

@implementation ELUHeroesCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rotation = 0.0;
    self.currentHero = 0;
    self.isShowingLandscapeView = NO;
    self.heroesModel = [ELUHeroesModel sharedInstance];
    [self.cardView setupWithHero:[self.heroesModel heroAtIndex:self.currentHero]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged:(NSNotification*)notification {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !self.isShowingLandscapeView) {
        [self performSegueWithIdentifier:@"OrientationChangeSegue" sender:self];
        self.isShowingLandscapeView = YES;
    }
    
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) && self.isShowingLandscapeView) {
        [self dismissViewControllerAnimated:NO completion:nil];
        self.isShowingLandscapeView = NO;
    }
}

- (IBAction)playButtonPressed:(UIBarButtonItem *)sender {
    self.currentHero++;
    [self.cardView setupWithHero:[self.heroesModel heroAtIndex:self.currentHero]];
    /*self.rotation += M_PI * 0.5;
    CATransform3D rotationAndPerspective = CATransform3DIdentity;
    rotationAndPerspective.m34 = 1.0 / - 1000.0;
    rotationAndPerspective = CATransform3DRotate(rotationAndPerspective, self.rotation, 0.0, 1.0, 0.0);
    [UIView animateWithDuration:0.5f animations:^{
        self.cardView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.cardView.layer.transform = rotationAndPerspective;
        self.cardView.frame = CGRectMake(320, self.view.frame.size.height/2.0 - self.cardView.image.size.height/2.0, 0, self.view.frame.size.height/2.0);
    } completion:^(BOOL complete){
    }];*/
}
@end
