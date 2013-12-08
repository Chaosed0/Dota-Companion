//
//  ELUViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/3/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroesCardViewController.h"
#import "ELUHeroViewController.h"
#import "ELUHeroesModel.h"
#import "ELUCardView.h"

#import <QuartzCore/QuartzCore.h>

@interface ELUHeroesCardViewController ()
@property(strong, nonatomic) ELUHeroesModel *heroesModel;

@property double rotation;
@property NSUInteger currentHero;

- (IBAction)playButtonPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet ELUCardView *cardView;

@end

@implementation ELUHeroesCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rotation = 0.0;
    self.currentHero = 0;
    self.heroesModel = [ELUHeroesModel sharedInstance];
    [self.cardView setupWithHero:[self.heroesModel heroAtIndex:self.currentHero]];
    self.cardView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped)];
    gestureRecognizer.numberOfTapsRequired = 1;
    [self.cardView addGestureRecognizer:gestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self checkOrientation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)checkOrientation {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        [self performSegueWithIdentifier:@"OrientationChangeSegue" sender:self];
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

- (void) cardTapped {
    [self performSegueWithIdentifier:@"PortraitHeroSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueId = segue.identifier;
    if([segueId isEqualToString:@"PortraitHeroSegue"]) {
        ELUHeroViewController *viewController = segue.destinationViewController;
        viewController.hero = [self.heroesModel heroAtIndex:self.currentHero];
        viewController.onCompletion = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
}
@end
