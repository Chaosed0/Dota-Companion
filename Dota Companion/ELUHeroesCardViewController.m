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

#define kMainCardWidth 0.8
#define kMainCardHeight 0.8
#define kSideCardWidth 0.5
#define kSideCardHeight 0.5
#define kSideCardPadding 50

@interface ELUHeroesCardViewController ()
@property(strong, nonatomic) ELUHeroesModel *heroesModel;

@property (strong, nonatomic) NSMutableArray *cardViews;

@property NSUInteger currentHero;
@property NSInteger curCard;

- (IBAction)playButtonPressed:(UIButton *)sender;

@end

@implementation ELUHeroesCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentHero = 0;
    self.heroesModel = [ELUHeroesModel sharedInstance];
    
    self.cardViews = [NSMutableArray arrayWithCapacity:3];
    
    for(int i = 0; i < 3; i++) {
        ELUCardView *cardView = [[ELUCardView alloc] initWithFrame:self.view.bounds];
        [cardView setupWithHero:[self.heroesModel heroAtIndex:i]];
        cardView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped)];
        gestureRecognizer.numberOfTapsRequired = 1;
        [cardView addGestureRecognizer:gestureRecognizer];
        
        [self.cardViews addObject:cardView];
    }
    
    for(int i = 2; i >= 0; i--) {
        [self.view addSubview:self.cardViews[i]];
    }
    
    {
    ELUCardView *cardView = self.cardViews[0];
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kMainCardWidth, kMainCardHeight);
    cardView.transform = scaleTransform;
    }
    
    {
    ELUCardView *cardView = self.cardViews[1];
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);;
    cardView.transform = scaleTransform;
    cardView.center = CGPointMake(self.view.bounds.size.width - kSideCardPadding, self.view.bounds.size.height/2.0);
    }
       {
    ELUCardView *cardView = self.cardViews[2];
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);;
    cardView.transform = scaleTransform;
    cardView.center = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height/2.0);
       }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkOrientation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    [self.cardViews[0] setupWithHero:[self.heroesModel heroAtIndex:self.currentHero]];
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
